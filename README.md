
<!-- README.md is generated from README.Rmd. Please edit that file -->

## Welcome

<!-- badges: start -->
<!-- badges: end -->

The `save` package is an experimental tool designed to simplify
file-saving tasks for data analysis and visualization. It offers methods
like csv, text, and plot to save data, text, and plot outputs with ease.
As an experimental package, it aims to provide a user-friendly
experience while exploring file-saving options. Please note that this
package is still under development and may undergo changes in future
releases.

You can install the development version of `save` like so:

``` r
devtools::install_github("tpq/save")
```

## Example

The `save` package is an experimental tool designed to streamline
file-saving tasks for data analysis and visualization in R. With its
intuitive interface, the package supports piping using the %\>%
operator, providing a seamless workflow for saving data and plot
outputs.

Let’s see a minimal example of how to use the `save` package with
piping:

``` r
library(dplyr)
library(ggplot2)
library(save)

# Set directory to use for all saved files
save <- Save$new(wd = getwd())

# Save data as CSV
data <-
  data.frame(A = 1:5, B = 6:10) %>%
  save$csv(file = "csv-1") %>%
  mutate(C = A + B) %>%
  save$csv(file = "csv-2")

# Save data as text
model <-
  lm(C ~ A + B, data) %>%
  save$text(file = "model")

# Save data as plot (base R plot)
# (note: pipe with %>%)
null <-
  plot(data$A, data$B) %>%
  save$plot(file = "plot-1")

# Save data as plot (ggplot2)
# (note: pipe with +)
gg <-
  data %>%
  ggplot(aes(x = A, y = B)) +
  geom_point() +
  save$gg(file = "plot-2") +
  theme_bw() +
  save$gg(file = "plot-3")
```

In these examples, the `save` package allows you to directly pipe data
frames and plot objects into the respective saving methods, providing a
concise and efficient workflow for file-saving operations. Please note
that the package is still under development, and your feedback is
valuable for further improvements and enhancements.

    #> [1] TRUE
    #> [1] TRUE
    #> [1] TRUE
    #> [1] TRUE
    #> [1] TRUE
    #> [1] TRUE
