#' Get Arguments as List
#'
#' This function takes a variable number of arguments and
#'  returns them as a list.
#'
#' @param ... Any number of arguments.
#'
#' @return A list containing the arguments provided.
#'
#' @examples
#' # Get arguments as a list
#' args_list <- as_args_list(10, "hello", TRUE)
#' print(args_list)
#'
#' @export
as_args_list <- function(...) {
  args <- as.list(substitute(list(...)))[-1]
  return(args)
}


#' Save Class
#'
#' @description
#' This R6 class provides methods to handle file saving and naming operations.
#' @import R6
#' @importFrom ggplot2 ggsave
#' @export
Save <- R6::R6Class(
  "Save",

  public = list(
    #' @field dir The directory path where files will be saved.
    #'  Default is the current working directory.
    dir = getwd(),

    #' @field prefix The prefix used in the file naming. Default is "file".
    prefix = "file",

    #' @field count The numeric count used in the file naming. Default is 1.
    count = 1,

    #' @description
    #' This method initializes the "Save" object with optional
    #'  directory argument.
    #' @param wd The directory path for saving files. Default is the
    #'  current working directory.
    initialize = function(wd = getwd()) {
      self$set_dir(wd)
    },

    #' @description
    #' This method generates a filename.
    #' @param filename Optional filename string.
    #' @return The generated filename.
    make_filename = function(filename) {
      if (missing(filename)) {
        filename <-
          paste0(self$dir, "/", self$prefix, "-", self$count)
        self$count <- self$count + 1
      } else{
        filename <- paste0(self$dir, "/", filename)
      }
      filename
    },

    #' @description
    #' This method sets the directory path where files will be saved.
    #' @param value The directory path for saving files.
    set_dir = function(value) {
      self$dir <- value
    },

    #' @description
    #' This method sets the prefix used in the file naming.
    #' @param value The prefix used in the file naming.
    set_prefix = function(value) {
      self$prefix <- value
    },

    #' @description
    #' This method sets the numeric count used in the file naming.
    #' @param value The numeric count used in the file naming.
    set_count = function(value) {
      self$count <- value
    },

    #' @description
    #' This method saves the provided data as a CSV file.
    #' @param data The data to be saved.
    #' @param file The filename for the CSV file.
    #' @param ... Passed to \code{write.csv}.
    #' @return Returns the data provided (pipe compatible).
    csv = function(data, file, ...) {
      filename <- self$make_filename(file)
      filename <- paste0(filename, ".csv")
      write.csv(data, file = filename, ...)
      data
    },

    #' @description
    #' This method saves the provided data as a text file.
    #' @param data The data to be saved.
    #' @param file The filename for the text file.
    #' @param ... Passed to \code{sink}.
    #' @return Returns the data provided (pipe compatible).
    text = function(data, file, ...) {
      filename <- self$make_filename(file)
      filename <- paste0(filename, ".txt")
      sink(filename, ...)
      print(data)
      sink()
      data
    },

    #' @description
    #' This method saves the provided plot as an image file in the
    #'  specified device format.
    #' @param plot The plot to be saved.
    #' @param file The filename for the image file.
    #' @param device The file type. PDF not currently supported.
    #' @param width,height,units,res,... Sent to device.
    #' @return Returns the data provided (pipe compatible).
    plot = function(plot,
                    file,
                    device = "png",
                    width = 5,
                    height = 5,
                    units = "in",
                    res = 600,
                    ...) {
      filename <- self$make_filename(file)
      filename <- paste0(filename, ".", device)
      generic_args <- as_args_list(...)
      default_args <-
        list(
          filename = filename,
          width = width,
          height = height,
          units = units,
          res = res
        )

      do.call(device, append(default_args, generic_args))
      eval(plot)
      dev.off()

      plot
    },

    #' @description
    #' This method saves the provided plot as an image file in the
    #'  specified device format.
    #'  \strong{For gg method you MUST pipe with + instead of \%>\%!}
    #' @param plot The plot to be saved.
    #' @param file The filename for the image file.
    #' @param device The file type. PDF not currently supported.
    #' @param width,height,units,res,... Sent to \code{ggsave}.
    #' @return Returns the data provided (pipe compatible).
    #'  \strong{For gg method you MUST pipe with + instead of \%>\%!}
    gg = function(plot,
                  file,
                  device = "png",
                  width = 5,
                  height = 5,
                  units = "in",
                  res = 600,
                  ...) {
      filename <- self$make_filename(file)
      filename <- paste0(filename, ".", device)
      ggplot2::ggsave(
        filename = filename,
        device = device,
        width = width,
        height = height,
        units = units,
        dpi = res,
        ...
      )
      invisible()
    }
  )
)
