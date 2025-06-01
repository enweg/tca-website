using DocUtils
using TransmissionChannelAnalysis
using CairoMakie  # Need to load this so that extensions are also documented

function make_doc_page(s, path)
  name = string(s)
  name_clean = replace(name, "@" => "\\@")
  file = joinpath(path, "$(name).qmd")

  page_content = """
--- 
title: | 
  $name_clean
sidebar: doc
engine: julia
---

```{julia}
#| echo: false 
#| output: false 

using DocUtils
using TransmissionChannelAnalysis
using CairoMakie  # Must include this to also document extensions
```

```{julia}
#| echo: false
#| output: asis

include_quarto_callout_doc(TransmissionChannelAnalysis, Symbol("$name"))
```
    """ 

  open(file, "w") do file 
    write(file, page_content)
  end
end

exported_symbols = names(TransmissionChannelAnalysis; all=false, imported=false)
for s in exported_symbols
  string(s) == "TransmissionChannelAnalysis" && continue
  make_doc_page(s, "./all-functions/")
end

