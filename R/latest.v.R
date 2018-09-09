#' @title Latest Version
#'
#' @description Reports the latest version of the package in the repository.
#'
#' @export
latest.v = function() {
   descrpt = file.path(tempdir(), "DESCRIPTION")
   download.file("https://github.com/nilforooshan/ggroups/raw/master/DESCRIPTION", destfile=descrpt)
   system(paste("grep Version", descrpt))
}
