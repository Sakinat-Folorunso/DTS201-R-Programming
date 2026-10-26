# DTS 201 – Introduction to Data Science (R edition)

Olabisi Onabanjo University · Dr. Sakinat Folorunso · R / RStudio / R Markdown version of the original Python (Colab) course.

## Lecture note
The R edition of the course outline and weekly lecture notes (Weeks 0–12, with an R practical in every week) is in 

[Open the DTS 201 Class Note on Google Docs](https://docs.google.com/document/d/1bIfX-ji2wZgDNOhSoo3csQWm1ctP066KMOFHXPm0EaY/edit?usp=sharing).



## Ways to run the notebooks
| Option | Steps |
|---|---|
| **RStudio on your laptop** (recommended) | Install R and RStudio (Week 0), download or clone this repository, double-click `DTS201_R.Rproj`. |
| **Posit Cloud** (free, in the browser; no installation) | Sign up at [posit.cloud](https://posit.cloud) > New Project > **New RStudio Project from Git Repository** > paste the repository URL. Then run `source("scripts/install_packages.R")` once. |
| **Download only** | Click Code > Download ZIP on GitHub, unzip, open the `.Rproj`. |

Google Colab works with an R runtime but is not recommended: packages reinstall every session and the project paths differ.

## Start here
1. Do **Week 0** (`notebooks/DTS201_Week00_Setup_R_RStudio.Rmd`): install R, RStudio and the packages.
2. Double-click `DTS201_R.Rproj` so RStudio opens in the project folder.
3. Run `source("scripts/check_setup.R")`. Every line should say `[PASS]`.
4. Open a notebook in `notebooks/`, click **Knit** (or run chunk by chunk with Ctrl/Cmd + Shift + Enter).

## Folders
| Folder | Content |
|---|---|
| `notebooks/` | **Student starters** – same text and examples, task code blanked (`# TODO`). |
| `solutions/` | **Lecturer copies** – complete worked solutions (subtitle ends “SOLUTIONS”). |
| `data/` | All datasets used (see below). |
| `scripts/` | `labs/` (lecture-note practicals), `install_packages.R`, `check_setup.R`, `make_datasets.R`, `week10_import_clean_visualise.R`, `build_starters.R`. |
| `docs/` | Lecture note (Word) for the R edition. |
| `outputs/` | Files written by the notebooks (cleaned data, PNGs, CSVs for Excel/Power BI). |

Edit only `solutions/`, then run `Rscript scripts/build_starters.R` to regenerate `notebooks/`.
Run the notebooks in order: Week 2 writes the cleaned files used in later weeks.

## Course map
| Week | Topic | Main R tools |
|---|---|---|
| 0 | Installing R and RStudio, projects, packages | RStudio, `install.packages`, R Markdown |
| 1 | Datasets and data types | `readr`, `readxl`, `jsonlite` |
| 2 | Data collection and cleaning | `dplyr`, `tidyr`, `stringr`, `parse_number` |
| 2B | Preprocessing and feature engineering | `mutate`, `model.matrix`, `scale`, leakage |
| 3 | EDA and visualisation | `ggplot2`, `cor.test` |
| 4 | Distributions, probability, simulation | `rbinom`, `rnorm`, `binom.test`, `chisq.test` |
| 4B | Sampling and bias | `slice_sample`, standard error, stratified and biased samples |
| 5 | Prediction and simple regression | `lm`, RMSE/MAE/R², repeated splits, LOOCV |
| 6 | Data mining: basket analysis and clustering | `arules`, `kmeans`, `prcomp`, silhouette |
| 7 | Statistical analysis | `t.test`, `chisq.test`, Cohen's d, Cramér's V |
| 8 | BI dashboards and decisions | `dplyr` KPIs, `ggplot2`, export for Excel/Power BI |
| 9 | Big data and large files | `read_csv_chunked`, ANOVA, type optimisation |
| 10 | R programming basics and scripts | vectors, functions, loops, `source()` |
| 11A | Classification | `glm`, `rpart`, confusion matrix, precision/recall |
| 11B | Model evaluation and cross-validation | overfitting, k-fold CV |
| 11 | Integrated mini-project | EDA + regression / group test / clustering |
| 12 | Use cases (image, text, audio, video) and course review | base R demos, `binom.test`, `lm` |
| – | EDA template | Reusable EDA notebook (`DTS201_EDA_Student_Centred_Template.Rmd`) |

## Alignment with the NUC CCMAS specification (DTS 201, 3 units, LH 30, PH 45)
| NUC course content | Week | Practical in this repository |
|---|---|---|
| Fundamentals; tools and platforms | 0, 1, 9, 10 | Week 0 set-up; Weeks 9–10 |
| What is data; structured, semi-structured, unstructured | 1 | Week 1 |
| Steps of the process: collection, pre-processing, training, testing | 1, 2, 5, 11 | Weeks 2, 2B, 5, 11A and 11B |
| Rudiments of data visualisation | 3 | Week 3 |
| Distributions, probability, simulations | 4 | Weeks 4 and 4B |
| Predictions and models | 5, 11 | Weeks 5, 11A and 11B |
| Use cases: image, natural language, audio, video | 12 | Week 12 |
| Data mining (knowledge extraction) | 6 | Week 6 |
| Business intelligence and knowledge management | 8 | Week 8 |
| Big data integration and intelligence; data analytics | 9 | Week 9 |
| Introduction to programming (R) | 0, 10 | Weeks 0 and 10 |

Statistical analysis (Week 7) and the mini-project (Week 11) support the NUC lab work on prediction models and knowledge extraction.

## Lecture-note practicals as scripts
Every R practical printed in the lecture note is also provided as a runnable script in `scripts/labs/` (for example `lab_w06A.R` for Week 6, Part A). Run them from the project root.

## Datasets
| File | Origin |
|---|---|
| `advertising.csv`, `student_score.csv`, `titanic_train.csv`, `titanic_test.csv`, `heart.csv`, `data.csv`, `Sales_data.*` | From the original course repository. |
| `grocery_transactions.csv` | **Simulated** (seed 42) Nigerian grocery baskets with five latent shopping missions. |
| `retail_sales_ng.csv` | **Simulated** (seed 42) retail sales in ₦, 2024–2025, six cities. |

The simulated files replace placeholder datasets that the Python notebooks referenced but did not ship. Regenerate them with `scripts/make_datasets.R`. They are for teaching only; do not report their results as real findings.

**Caveat (Week 11):** public copies of `heart.csv` disagree on whether `target = 1` means disease or no disease. Use the neutral labels “target = 0/1” and check the data dictionary of your source.

## Python → R quick map
| Python | R |
|---|---|
| `pandas.read_csv` | `readr::read_csv` |
| `df.head()`, `df.info()` | `head(df)`, `glimpse(df)` |
| `df.groupby().agg()` | `group_by()` then `summarise()` |
| `matplotlib`/`seaborn` | `ggplot2` |
| `scipy.stats.ttest_ind` | `t.test()` |
| `sklearn LinearRegression` | `lm()` |
| `sklearn KMeans` | `kmeans()` |
| `mlxtend apriori` | `arules::apriori` |
| Colab / Jupyter `.ipynb` | RStudio / R Markdown `.Rmd` |

## Requirements
R ≥ 4.1, RStudio, and the packages in `scripts/install_packages.R` (`tidyverse`, `readxl`, `arules`, `rmarkdown`, `knitr`; `jsonlite`, `broom` and `scales` come with the tidyverse; `cluster` ships with R). Licence: see `LICENSE`.

📌 Important

This repository is a learning resource for DTS 201: Introduction to Data Science.

Students should use the repository together with the official course teaching materials and instructions provided by the lecturer.

👩🏽‍🏫 Course Instructor

Dr. Sakinat Folorunso
Department of Computer Science
Olabisi Onabanjo University

📜 License

See the LICENSE file for information about permitted use and redistribution of the repository materials.
