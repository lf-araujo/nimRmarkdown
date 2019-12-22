.onLoad <- function (libname, pkgname) {
    if (!requireNamespace("utils")) stop("Requires utils package.")
  # print(".onLoad")
  # print(utils::globalVariables())
    utils::globalVariables("hook_orig") # to suppress CHECK note
}

.onAttach <- function (libname, pkgname) {
#  if (!requireNamespace("knitr")) stop("Requires knitr package.")
  knitr::knit_engines$set(nim=nim_engine)
#  packageStartupMessage("nim engine redefined")

  nimexe <- find_nim()
  if (nimexe!="") {
    knitr::opts_chunk$set(engine.path=list(nim=nimexe))
  } else {
    packageStartupMessage("No nim executable found.")
  }
  knitr::opts_chunk$set(#engine="nim",
                        error=TRUE, cleanlog=TRUE, comment=NA)
#  packageStartupMessage("Chunk options optimized")

  nim_collectcode()
#  packageStartupMessage("collectcode option defined")

  assign("hook_orig", knitr::knit_hooks$get("output"), pos=2)
  knitr::knit_hooks$set(output = nimoutputhook)
#  packageStartupMessage("output for nim redefined")

  if (nimexe!="") {
    packageStartupMessage("The 'nim' engine is ready to use.")
  }

}
