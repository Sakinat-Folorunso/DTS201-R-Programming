# ==============================================================================
# DTS 201 (R edition) - scripts/build_starters.R   [FOR THE LECTURER]
#
# The complete, worked notebooks live in  solutions/*.Rmd.
# This script generates the student STARTER notebooks in  notebooks/*.Rmd  by
# blanking every block that sits between the two marker lines
#
#     # >>> SOLUTION
#     ...answer code...
#     # <<< SOLUTION
#
# Lines inside a block that begin with "# HINT:" are kept for the students.
# Everything outside the markers (explanations, demonstrations, plots) is copied
# unchanged, so the starter and solution files can never drift apart.
#
# Run from the project root:   Rscript scripts/build_starters.R
# ==============================================================================

src_files <- list.files("solutions", pattern = "\\.Rmd$", full.names = TRUE)
dir.create("notebooks", showWarnings = FALSE)

blank_block <- function(lines) {
  out <- character(); in_block <- FALSE
  for (ln in lines) {
    if (grepl("^\\s*(#|<!--)\\s*>>>\\s*SOLUTION", ln)) {
      in_block <- TRUE
      # R-code marker "# >>> SOLUTION"  -> placeholder comment in the chunk
      # Markdown marker "<!-- >>> SOLUTION -->" -> placeholder text in the document
      out <- c(out, if (grepl("^\\s*<!--", ln)) "*Your answer here:*" else "# TODO: write your code here")
      next
    }
    if (grepl("^\\s*(#|<!--)\\s*<<<\\s*SOLUTION", ln)) { in_block <- FALSE; next }
    if (in_block) {
      if (grepl("^\\s*#\\s*HINT:", ln)) out <- c(out, ln)
      next
    }
    out <- c(out, ln)
  }
  if (in_block) stop("Unclosed SOLUTION block")
  out
}

suffix <- " \u2013 SOLUTIONS (lecturer copy)"

for (f in src_files) {
  lines <- readLines(f, encoding = "UTF-8", warn = FALSE)
  has_task <- any(grepl(">>> SOLUTION", lines))
  is_sub   <- grepl("^subtitle: \"", lines)
  base     <- sub(paste0(suffix, "\"$"), "\"", lines, fixed = FALSE)   # strip old suffix, if any
  base[!is_sub] <- lines[!is_sub]
  starter  <- blank_block(base)

  # Starter notebook for students
  out <- file.path("notebooks", basename(f))
  writeLines(starter, out, useBytes = TRUE)

  # Solution notebook: add the suffix to the subtitle (only for weeks that have tasks)
  sol <- base
  if (has_task) sol[is_sub] <- sub("\"$", paste0(suffix, "\""), base[is_sub])
  writeLines(sol, f, useBytes = TRUE)

  message("Built ", out, "  (", sum(grepl(">>> SOLUTION", lines)), " task block(s) blanked)")
}
