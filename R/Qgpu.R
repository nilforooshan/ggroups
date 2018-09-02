#' @title \strong{Qg} + \strong{u}
#'
#' @description Adds genetic group contributions to genetic merit of animals in a pedigree.
#'
#' @param
#' Qmat : The output matrix from \code{qmat}; for more details: \code{?qmat}
#'
#' @param
#' sol : A \code{data.frame} with 2 numeric columns corresponding to ID, EBV ([\strong{ĝ}, \strong{û}]).
#'
#' @return uhatplus : Vector of \strong{Qĝ} + \strong{û}
#'
#' @examples
#' ped = data.frame(ID=c(3,4,6,5), SIRE=c(1,3,4,1), DAM=c(2,2,5,2))
#' Qmat = qmat(gghead(ped))
#' ghat = c(0.1, -0.1)
#' uhat = seq(-0.15, 0.15, 0.1)
#' sol = data.frame(ID=1:6, EBV=c(ghat, uhat))
#' Qgpu(Qmat, sol)
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
