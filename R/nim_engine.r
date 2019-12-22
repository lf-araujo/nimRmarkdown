nim_engine <- function(options)
{
  code <- {
    if (is.null(options$savedo) || options$savedo==FALSE) {
      f <- basename(tempfile(pattern="nim", tmpdir=".", fileext=".r"))
      on.exit(unlink(f), add = TRUE)
    } else {
      f <- basename(paste0(options$label, ".r"))
    }
    writeLines(options$code, f)

    logf = sub("[.]r$", ".log", f)
    if (is.null(options$savedo) || options$savedo==FALSE)
      on.exit(unlink(logf), add = TRUE)
    paste(switch(Sys.info()[["sysname"]], Windows = "/q /e do",
                 Darwin = "-q -e do", Linux = "c --hints:off --hint[CC]:off -r ", "c --hints:off --hint[CC]:off -r "),
          shQuote(normalizePath(f)))
  }

  if (is.list(options$engine.opts)) {
    code = paste(options$engine.opts[[options$engine]], code, options$doargs)
  } else { # backwards compatability
    code = paste(options$engine.opts, code, options$doargs)
  }
# print(code)

  cmd = options$engine.path
  if (is.list(options$engine.path)) {
    cmd = options$engine.path[[options$engine]]
  } else { # backwards compatability
    cmd = options$engine.path
  }

  out = if (options$eval) {
    message("running: ", cmd, " ", code)
    tryCatch(system2(cmd, code, stdout = TRUE, stderr = TRUE,
                     env = options$engine.env), error = function(e) {
                       if (!options$error)
                         stop(e)
                       paste("Error in running command", cmd)
                     })
  }
  else ""
  if (!options$error && !is.null(attr(out, "status")))
    stop(paste(out, collapse = "\n"))
  if (options$eval && options$engine == "nim" && file.exists(logf))
    out = c(readLines(logf), out)
#  nimengine_output(options, options$code, out)
#  print("log file read")
  knitr::engine_output(options, options$code, out)
}
