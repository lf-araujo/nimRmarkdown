nim_collectcode <- function() {
  # Message when nimmarkdown loads
  if (file.exists(file.path(dirname(find_nim(message=FALSE)), "sysprofile.do"))) {
    message("Found a 'sysprofile.do'")
  }
  if (file.exists(file.path(dirname(find_nim(message=FALSE)), "profile.do"))) {
    message("Found a 'profile.do' in the nim executable directory.")
    message("  This prevents 'collectcode' from working.")
    message("  Please rename this 'sysprofile.do'.")
  }
  if (file.exists("profile.do")){
#    print(sys.frames())
#    print(sys.calls())
#    print(sys.nframe())
    assign("oprofile", readLines("profile.do"), pos=2)
#    oprofile <- readLines("profile.do")
    message("Found an existing 'profile.do'")
    message(paste("  ", oprofile, "\n"))
  }
  else {
    oprofile <- NULL
  }
  # Hook for code processing
  knitr::knit_hooks$set(collectcode = function(before, options, envir) {
    if (!before) {
        if (options$engine == "nim") {
#          print(options$engine.path$nim)
          if (file.exists(file.path(dirname(options$engine.path$nim), "profile.do"))) {
            message("Found a 'profile.do' in the nim executable directory.")
            message("  This prevents 'collectcode' from working properly.")
            message("  Please rename this 'sysprofile.do'.")
          }
            autoexec <- file("profile.do", open="at")
            writeLines(options$code, autoexec)
            close(autoexec)
#            print(sys.frames())
#            print(sys.calls())
        do.call("on.exit",
            list(quote(unlink("profile.do")), add=TRUE),
            envir = sys.frame(-9))
        if (!is.null(oprofile)) {
            do.call("on.exit",
                list(quote(writeLines(oprofile, "profile.do")), add=TRUE),
                envir = sys.frame(-9))
        }
            # sys.frame(1) or sys.frame(-10) is rmarkdown::render()
            # sys.frame(-9) is knitr::knit()
        }
    }
})
}
