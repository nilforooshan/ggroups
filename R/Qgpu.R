#' @title \strong{Qg} + \strong{u}
#'
#' @description Add genetic group contributions to genetic merit of animals in a pedigree.
#'
#' @param
#' Qmat : The output matrix from function \code{qmat}
#'
#' @param
#' sol : A \code{data.frame} with 2 numeric columns corresponding to ID, EBV ([\strong{ĝ}, \strong{û}]).
#'
#' @return uhatplus : Vector of \strong{Qĝ} + \strong{û}
#'
#' @examples
#' Qmat = qmat(ped)
#' # For details about qmat and ped: ?qmat
#' sol = data.frame(ID=c(1:2,4:7), EBV=c(0.2,seq(-0.1,0.3,0.1)))
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
      print("colnames(Qmat) and rownames(Qmat) do not match with sol$ID!")
   }
}
