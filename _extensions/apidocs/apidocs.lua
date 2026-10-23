-- ApiDocs.jl shortcodes. This file ships with ApiDocs.jl; reinstall it with
-- `ApiDocs.install_quarto_extension(".", force=true)` instead of editing a copy.
--
--   {{< api julia through >}}                     every callout of a symbol
--   {{< api julia VAR key="(DataFrame, Int)" >}}  one method doc
--   {{< api julia VAR key="generic" >}}           only the generic doc
--   {{< api julia LP index="2" >}}                the second doc entry (in source order)
--   {{< api matlab VAR.fit >}}                    a class member
--   {{< api-link julia transmission >}}           an inline link to the reference page
--   {{< api-link matlab VAR.fit label="fit" >}}   ... with a custom label
--
-- The shortcode only looks things up: ApiDocs.render_quarto writes the rendered
-- Markdown into a snippets file, configured per language in _quarto.yml:
--
--   apidocs:
--     julia:
--       snippets: documentation/_api/api-julia.snippets.json

local cache = {}

local function str(x)
  if x == nil then return nil end
  local s = pandoc.utils.stringify(x)
  if s == "" then return nil end
  return s
end

local function project_dir()
  if quarto.project ~= nil and quarto.project.directory ~= nil then
    return quarto.project.directory
  end
  return os.getenv("QUARTO_PROJECT_DIR") or "."
end

local function load(lang, meta)
  if cache[lang] ~= nil then return cache[lang] end
  local cfg = meta and meta.apidocs and meta.apidocs[lang]
  local path = cfg and str(cfg.snippets)
  if path == nil then
    return nil, "no `apidocs: " .. lang .. ": snippets:` entry in _quarto.yml"
  end
  -- Quarto rewrites project-relative paths of existing files in _quarto.yml to be
  -- relative to the document being rendered (the working directory of filters), so
  -- try the path as given first and only then relative to the project directory.
  local f = io.open(path, "r")
  if f == nil and not pandoc.path.is_absolute(path) then
    path = pandoc.path.join({ project_dir(), path })
    f = io.open(path, "r")
  end
  if f == nil then
    return nil, "cannot read " .. path .. " (did the ApiDocs pre-render step run?)"
  end
  local data = quarto.json.decode(f:read("a"))
  f:close()
  cache[lang] = data
  return data
end

local function lookup(data, lang, name)
  local id = lang .. ":" .. name
  if data.symbols[id] ~= nil then return data.symbols[id] end
  local nid = data.names[name]
  if nid ~= nil then return data.symbols[nid] end
  return nil
end

local function strip_ws(s) return (s:gsub("%s+", "")) end

-- Parse Markdown so that Quarto still processes its own syntax (callouts) in it;
-- plain pandoc.read would leave the callout divs as ordinary divs.
local function to_blocks(md)
  if quarto.utils ~= nil and quarto.utils.string_to_blocks ~= nil then
    return quarto.utils.string_to_blocks(md)
  end
  return pandoc.read(md, "markdown").blocks
end

local function warn_block(msg)
  quarto.log.warning("apidocs: " .. msg)
  return pandoc.Div(
    { pandoc.Para({ pandoc.Strong({ pandoc.Str("ApiDocs:") }), pandoc.Space(), pandoc.Str(msg) }) },
    pandoc.Attr("", { "callout-important" }))
end

-- args[1] = language, args[2] = name
local function target(args, meta)
  local lang, name = str(args[1]), str(args[2])
  if lang == nil or name == nil then
    return nil, nil, nil, "usage: {{< api LANGUAGE NAME [key=\"...\"] >}}"
  end
  local data, err = load(lang, meta)
  if data == nil then return nil, lang, name, err end
  local sym = lookup(data, lang, name)
  if sym == nil then return nil, lang, name, "no " .. lang .. " symbol \"" .. name .. "\"" end
  return sym, lang, name, nil
end

return {
  ["api"] = function(args, kwargs, meta)
    local sym, lang, name, err = target(args, meta)
    if sym == nil then return warn_block(err) end
    local key = str(kwargs["key"])
    local index = tonumber(str(kwargs["index"]) or "")
    local parts = {}
    for i, c in ipairs(sym.callouts) do
      local wanted
      if index ~= nil then
        wanted = (i == index)
      elseif key ~= nil then
        wanted = (key == "generic" and c.key == "") or strip_ws(c.key) == strip_ws(key)
      else
        wanted = true
      end
      if wanted then table.insert(parts, c.markdown) end
    end
    if #parts == 0 then
      local keys = {}
      for i, c in ipairs(sym.callouts) do table.insert(keys, i .. ": " .. (c.key == "" and "generic" or c.key)) end
      return warn_block(lang .. " symbol \"" .. name .. "\" has no doc with " ..
        (index ~= nil and ("index " .. index) or ("key " .. key)) .. "; it has " .. table.concat(keys, ", "))
    end
    return to_blocks(table.concat(parts, "\n\n"))
  end,

  ["api-link"] = function(args, kwargs, meta)
    local sym, lang, name, err = target(args, meta)
    local label = str(kwargs["label"]) or name or "?"
    if sym == nil then
      quarto.log.warning("apidocs: " .. err)
      return pandoc.Code(label)
    end
    if sym.url == nil or sym.url == pandoc.Null or type(sym.url) ~= "string" then
      quarto.log.warning("apidocs: " .. lang .. " symbol \"" .. name .. "\" has no page; not linked")
      return pandoc.Code(label)
    end
    return pandoc.Link({ pandoc.Code(label) }, sym.url)
  end,
}
