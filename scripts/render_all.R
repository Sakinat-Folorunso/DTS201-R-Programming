# Render every notebook to HTML (used to test that all code runs end to end).
# Usage (project root):  Rscript scripts/render_all.R [solutions|notebooks] [outdir]
args <- commandArgs(trailingOnly = TRUE)
dir_in  <- if (length(args) >= 1) args[1] else "solutions"
dir_out <- if (length(args) >= 2) args[2] else file.path("html_preview", dir_in)
dir.create(dir_out, recursive = TRUE, showWarnings = FALSE)
for (f in list.files(dir_in, pattern = "\\.Rmd$", full.names = TRUE)) {
  message(">>> rendering ", f)
  rmarkdown::render(f, output_dir = dir_out, quiet = TRUE,
                    envir = new.env(), knit_root_dir = normalizePath(dir_in))
}
