#' @title Vector \strong{Qg} + \strong{u}
#'
#' @description Adds genetic group contributions to the genetic merit of animals.
#'
#' @param Q : The output matrix from \code{qmat} (for more details: \code{?qmat})
#'
#' @param sol : \code{data.frame} with 2 numeric columns corresponding to ID, EBV ([\strong{ĝ}, \strong{û}]), where \strong{ĝ} and \strong{û} are the genetic group and genetic merit solutions, respectively.
#'
#' @return Vector of \strong{Qĝ} + \strong{û}
#'
#' @examples
#' ped = data.frame(ID=c(3,4,6,5), SIRE=c(1,3,4,1), DAM=c(2,2,5,2))
#' Q = qmat(gghead(ped))
#' ghat = c(0.1, -0.1)
#' uhat = seq(-0.15, 0.15, 0.1)
#' sol = data.frame(ID=1:6, EBV=c(ghat, uhat))
#' Qgpu(Q, sol)
#'
#' @export
Qgpu = function(Q, sol) {
   if(identical(as.integer(c(colnames(Q), rownames(Q))), sol$ID))
   {
      Ngg = ncol(Q)
      ghat = sol[1:Ngg,]$EBV
      uhat = sol[(Ngg + 1):nrow(sol),]$EBV
      uhatplus = (Q %*% ghat) + uhat
      return(uhatplus)
   } else {
      print("ERROR: identical(c(colnames(Q), rownames(Q)), sol$ID) = FALSE")
   }
}
