#' @title \strong{Qg} + \strong{u}
#'
#' @description Add genetic group contributions to genetic merit of animals in a pedigree.
#'
#' @param
#' Qmat : The output matrix from \code{qmat}; for more details: \code{?qmat}
#'
#' @param
#' sol : A \code{data.frame} with 2 numeric columns corresponding to ID, EBV ([\strong{ĝ}, \strong{û}]).
#'
#' A sample data for solutions is provided (\code{samplesol}) by the package, with columns corresponding to ID, EBV ([\strong{ĝ}, \strong{û}]).
#'
#' @return uhatplus : Vector of \strong{Qĝ} + \strong{û}
#'
#' @examples
#' Qgpu(qmat(gghead(sampleped)), samplesol)
#'
#' @export
Qgpu = function(Qmat, sol) {
   if(identical(as.integer(c(colnames(Qmat), rownames(Qmat))), sol$ID))
   {
      Ngg = ncol(Qmat)
      ghat = sol[1:Ngg,]$EBV
      uhat = sol[(Ngg + 1):nrow(sol),]$EBV
      uhatplus = (Qmat %*% ghat) + uhat
      return(uhatplus)
   } else {
      print("ERROR: identical(c(colnames(Qmat), rownames(Qmat)), sol$ID) = FALSE")
   }
}
