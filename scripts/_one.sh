#!/bin/sh
# usage: _one.sh <Rmd path> ; renders with UTF-8 locale and prints text outputs
export LC_ALL=C.UTF-8
Rscript -e 'f <- commandArgs(TRUE)[1]; out <- file.path("/tmp/claude-0/-home-claude/97e6c7f1-b34f-52fa-9a99-b45b53566091/scratchpad/render", dirname(f)); dir.create(out, recursive=TRUE, showWarnings=FALSE); rmarkdown::render(f, output_dir=out, quiet=TRUE, envir=new.env(), knit_root_dir=normalizePath(dirname(f)))' "$1" 2>&1 | tail -20
