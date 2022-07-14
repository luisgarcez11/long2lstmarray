
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `long2lstmarray`

The goal of `long2lstmarray` is to transform 2D longitudinal data into
3D arrays suitable for neural networks training that require
longitudinal data (e.g. Long short-term memory). The array output can be
used by the R `keras` or other similar packages as a X/label set.

## Installation

You can install the `long2lstmarray` from [GitHub](https://github.com/)
with:

``` r
# install.packages("devtools")
devtools::install_github("luisgarcez11/long2lstmarray")
```

## Guide

We will follow a step-by-step approach, starting with the most basic
function and advancing to the most advanced function. Note that the most
advanced functions rely on the most basic ones to function properly.

### Data

The `alsfrs_data` dataset will be used to guide you through the package
functionality. This data is invented.

``` r
library(long2lstmarray)
head(alsfrs_data, n = 10)
```

    ## # A tibble: 10 × 15
    ##    subjid visdy    p1    p2    p3    p4    p5    p6    p7    p8    p9   p10
    ##     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
    ##  1      1     0     3     3     0     0     2     3     3     4     0     4
    ##  2      1   151     0     0     2     4     3     0     3     1     3     3
    ##  3      1   223     3     4     0     3     2     3     0     2     2     0
    ##  4      1   372     1     3     1     3     3     3     4     3     1     1
    ##  5      1   459     0     4     0     1     1     4     0     0     4     2
    ##  6      1   535     2     2     4     1     1     0     2     3     0     1
    ##  7      1   644     4     2     2     3     2     1     0     2     0     0
    ##  8      1   759     4     0     4     1     2     3     0     2     1     3
    ##  9      2     0     4     0     3     3     0     0     1     2     3     1
    ## 10      2   244     3     4     0     4     0     2     1     4     2     4
    ## # … with 3 more variables: x1r <dbl>, x2r <dbl>, x3r <dbl>

### `get_var_sequence` function

The most basic function has the goal to retrieve the variable values
from a subject/variable name pair, like this:

``` r
get_var_sequence(data = alsfrs_data, subj_var = "subjid", subj = 1, var = "p1")
```

    ## [1] 3 0 3 1 0 2 4 4

### `slice_var_sequence` function

Then, the package has the ability to generate a matrix with various lags
from a sequence. For example, take a simple numeric sequence:

``` r
slice_var_sequence(sequence = 1:10, lags = 3, label_length = 1, label_output = TRUE)
```

    ## $x
    ##      [,1] [,2] [,3]
    ## [1,]    1    2    3
    ## [2,]    2    3    4
    ## [3,]    3    4    5
    ## [4,]    4    5    6
    ## [5,]    5    6    7
    ## [6,]    6    7    8
    ## [7,]    7    8    9
    ## 
    ## $y
    ## [1]  4  5  6  7  8  9 10

The result is a list with `x` representing the lags from the sequence,
and `y` represents the value that follows each lag, and that will be
used as label. If `label_output = FALSE`, only `x` is returned. The
`lags` argument represents the number of columns of `x`, and
`label_length` represents how many values after the lag is considered to
be the label. If `label_length = 1`, the label value is always the value
following the sliced sequence.

### `get_var_array` function

This function has the ability to generate a matrix with various lags
from a variable in a dataframe. This function is analogous to
`slice_var_sequence` but its scope is larger, because it takes an
`data.frame` as an argument, and so the `var` to be sequenced has to
stated. The `time_var` is the time variable which is important to be
stated because it orders the lags correctly.

``` r
get_var_array(data = alsfrs_data, subj_var = "subjid", var = "p3", time_var = "visdy", lags = 5, label_length = 1, label_output = TRUE)
```

    ## $x
    ##       time1 time2 time3 time4 time5
    ## seq1      0     2     0     1     0
    ## seq2      2     0     1     0     4
    ## seq3      0     1     0     4     2
    ## seq4      3     0     2     3     4
    ## seq5      0     2     3     4     3
    ## seq6      2     3     4     3     1
    ## seq7      3     4     3     1     3
    ## seq8      4     3     1     3     3
    ## seq9      3     1     3     3     0
    ## seq10     1     3     3     0     2
    ## seq11     3     3     0     2     4
    ## seq12     3     0     2     4     1
    ## seq13     0     2     4     1     0
    ## seq14     2     4     1     0     1
    ## seq15     0     1     1     3     2
    ## seq16     1     1     3     2     4
    ## seq17     1     3     2     4     1
    ## seq18     3     2     4     1     0
    ## seq19     2     4     1     0     3
    ## seq20     1     0     3     0     2
    ## seq21     0     3     0     2     1
    ## seq22     3     0     2     1     4
    ## seq23     0     2     1     4     4
    ## seq24     2     1     4     4     4
    ## seq25     1     4     4     4     2
    ## seq26     4     4     4     2     4
    ## seq27     4     4     2     4     4
    ## seq28     4     2     1     3     0
    ## seq29     2     1     3     0     1
    ## seq30     1     3     0     1     0
    ## seq31     3     0     1     0     4
    ## seq32     0     1     0     4     1
    ## seq33     4     4     4     1     0
    ## seq34     4     4     1     0     2
    ## seq35     4     1     0     2     2
    ## seq36     1     0     2     2     3
    ## seq37     0     2     2     3     0
    ## 
    ## $y
    ##  [1] 4 2 4 3 1 3 3 0 2 4 1 0 1 2 4 1 0 3 4 1 4 4 4 2 4 4 0 1 0 4 1 0 2 2 3 0 2

### `longitudinal_array` function

This function is analogous to the previous get_var_array function. This
function has the ability to generate a matrix with various lags from
various variables in a dataframe. The returned object is a 3D array. The
array dimensions are respectively, subject, time and variable. If
`label_output` is `TRUE`, a list with the 3D array and vector with the
labels is returned.

``` r
array3d <- longitudinal_array(alsfrs_data, "subjid", vars =  c("p1", "p2", "p3"), time_var =  "visdy", lags = 3, label_output = FALSE)
```

First dimension, representing the subjects (e.g. `subjid` = 1):

``` r
array3d[1,,]
```

    ##       p1 p2 p3
    ## time1  3  3  0
    ## time2  0  0  2
    ## time3  3  4  0

Second dimension, representing time (e.g. first visit):

``` r
array3d[,1,]
```

    ##       p1 p2 p3
    ## seq1   3  3  0
    ## seq2   0  0  2
    ## seq3   3  4  0
    ## seq4   1  3  1
    ## seq5   0  4  0
    ## seq6   4  0  3
    ## seq7   3  4  0
    ## seq8   0  3  2
    ## seq9   1  4  3
    ## seq10  3  3  4
    ## seq11  3  3  3
    ## seq12  4  0  1
    ## seq13  3  0  3
    ## seq14  2  4  3
    ## seq15  3  1  0
    ## seq16  1  3  2
    ## seq17  4  4  4
    ## seq18  2  0  1
    ## seq19  1  0  1
    ## seq20  3  3  3
    ## seq21  2  4  0
    ## seq22  4  1  1
    ## seq23  4  4  1
    ## seq24  1  3  3
    ## seq25  1  4  2
    ## seq26  3  3  4
    ## seq27  1  2  1
    ## seq28  2  1  1
    ## seq29  3  4  0
    ## seq30  0  1  3
    ## seq31  3  0  0
    ## seq32  1  3  2
    ## seq33  4  3  1
    ## seq34  1  2  4
    ## seq35  3  2  4
    ## seq36  1  0  4
    ## seq37  1  4  2
    ## seq38  0  3  4
    ## seq39  4  0  1
    ## seq40  2  0  0
    ## seq41  0  4  4
    ## seq42  2  4  2
    ## seq43  2  3  1
    ## seq44  4  1  3
    ## seq45  0  3  0
    ## seq46  1  4  1
    ## seq47  0  3  0
    ## seq48  0  3  4
    ## seq49  1  0  4
    ## seq50  1  4  4
    ## seq51  1  1  1
    ## seq52  1  3  0
    ## seq53  3  0  2
    ## seq54  1  1  2
    ## seq55  4  3  4

Third dimension, representing the variables (e.g. `p1`):

``` r
array3d[,,1] 
```

    ##       time1 time2 time3
    ## seq1      3     0     3
    ## seq2      0     3     1
    ## seq3      3     1     0
    ## seq4      1     0     2
    ## seq5      0     2     4
    ## seq6      4     3     0
    ## seq7      3     0     1
    ## seq8      0     1     3
    ## seq9      1     3     3
    ## seq10     3     3     4
    ## seq11     3     4     3
    ## seq12     4     3     2
    ## seq13     3     2     3
    ## seq14     2     3     1
    ## seq15     3     1     4
    ## seq16     1     4     2
    ## seq17     4     2     1
    ## seq18     2     1     1
    ## seq19     1     3     0
    ## seq20     3     0     3
    ## seq21     2     4     4
    ## seq22     4     4     1
    ## seq23     4     1     1
    ## seq24     1     1     3
    ## seq25     1     3     1
    ## seq26     3     1     4
    ## seq27     1     4     1
    ## seq28     2     3     0
    ## seq29     3     0     3
    ## seq30     0     3     1
    ## seq31     3     1     4
    ## seq32     1     4     1
    ## seq33     4     1     3
    ## seq34     1     3     1
    ## seq35     3     1     1
    ## seq36     1     1     4
    ## seq37     1     4     1
    ## seq38     0     3     0
    ## seq39     4     2     1
    ## seq40     2     1     4
    ## seq41     0     2     2
    ## seq42     2     2     4
    ## seq43     2     4     0
    ## seq44     4     0     1
    ## seq45     0     1     0
    ## seq46     1     0     3
    ## seq47     0     3     0
    ## seq48     0     1     1
    ## seq49     1     1     1
    ## seq50     1     1     1
    ## seq51     1     1     3
    ## seq52     1     3     1
    ## seq53     3     1     0
    ## seq54     1     0     0
    ## seq55     4     0     0

## `keras` interface

The great advantage of this package is that the `longitudinal_array`
function output can be used to train Long short-term memory neural
networks in R `keras` package or other similar packages to train models
that use longitudinal data.

To show an example, first install `keras` package.

``` r
#install.packages("keras")
library(keras)
```

Set X train and labels:

``` r
array3d <- longitudinal_array(alsfrs_data, "subjid", vars =  c("p1", "p2", "p3"), label_var = "p4", time_var =  "visdy", lags = 3, label_output = TRUE)

x_train = array3d$x
y_train = array3d$y
```

Set a Long short-term memory neural network model:

``` r
model <- keras::keras_model_sequential()
model %>%
    layer_lstm(
      units = 100,
      input_shape = dim(x_train)[2:3],
      return_sequences = TRUE,
      stateful = FALSE) %>%
    layer_dense(units = 1)
        
# compile model
model %>% keras::compile(loss = "mse")

#fit model
history <- model %>% fit(
          x = x_train,
          y = y_train)
```
