using DocUtils
using JSON

function load_from_json(filename)
  dict = open(filename, "r") do file
    JSON.parse(file)
  end
  return dict
end

functions = load_from_json("./matlab-documentation-functions.json")
classes = load_from_json("./matlab-documentation-classes.json")
class_methods = load_from_json("./matlab-documentation-class-methods.json")

function make_doc_page_function(name, functions, path)
  file = joinpath(path, "$(name).qmd")

  doc = functions[name]
  if doc == ""
    @info "Skipping function $name because doc is empty."
    return
  end

  doc = callout_block_matlab(name, functions)

  page_content = """
--- 
title: | 
  $name
sidebar: doc
---

$doc

    """

  open(file, "w") do file
    write(file, page_content)
  end
end


function make_doc_page_class(name, classes, class_methods, path)
  file = joinpath(path, "$(name).qmd")

  doc = classes[name]
  if doc == ""
    @info "Skipping function $name because doc is empty."
    return
  end

  doc = callout_block_matlab(name, classes)

  page_content = """
--- 
title: | 
  $name
sidebar: doc
---

$doc

    """

  for cm in keys(class_methods[name])
    doc = class_methods[name][cm]
    if doc == ""
      @info "Skipping $(name).$cm because doc is empty."
      continue
    end

    doc = callout_block_matlab(cm, class_methods[name])
    page_content *= "\n$doc"
  end

  open(file, "w") do file
    write(file, page_content)
  end
end

path = "all-functions/"
for func in keys(functions)
  make_doc_page_function(func, functions, path)
end

for cl in keys(classes)
  make_doc_page_class(cl, classes, class_methods, path)
end
