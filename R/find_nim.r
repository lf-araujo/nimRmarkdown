find_nim <- function(message=TRUE) {
  nimexe <- ""
  if (.Platform$OS.type == "unix") {
      nimexe = Sys.which("nim")
      if (message) message("Nim found at ", nimexe)
  } else {
    message("Unrecognized operating system.")
  }
#  if (nimexe=="") message("nim executable not found.\n Specify the location of your nim executable.")
  return(nimexe)
}

