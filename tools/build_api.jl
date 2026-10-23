# Pre-render step (see `project.pre-render` in _quarto.yml): renders the committed
# API JSON files in documentation/_api/ into the reference pages
# (documentation/<lang>/all-functions/*.qmd) and the snippets used by the
# `{{< api >}}` shortcode. Rewrites nothing when nothing changed.
#
# The JSON files are produced in the package repositories:
# - TransmissionChannelAnalysis.jl: docs/api/make_api.jl
# - tca-matlab-toolbox: julia -m ApiDocs extract-matlab
using ApiDocs

cd(joinpath(@__DIR__, ".."))

for lang in ("julia", "matlab")
    api = read_api("documentation/_api/api-$lang.json")
    report = render_quarto(api, RenderOptions(
        outdir        = "documentation/$lang/all-functions",
        url_base      = "/documentation/$lang/all-functions/",
        snippets_file = "documentation/_api/api-$lang.snippets.json",
        visibilities  = lang == "julia" ? [:exported] : [:public],
    ))
    @info "$lang API" written=length(report.written) deleted=length(report.deleted)
end
