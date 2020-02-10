#' @title Vector \strong{Qg} + \strong{u}
#'
#' @description Adds genetic group contributions to the genetic merit of individuals.
#'
#' @param Q : The output \code{matrix} from \code{qmatL} (for more details: \code{?qmatL})
#'
#' @param sol : \code{data.frame} with 2 numeric columns corresponding to ID, EBV ([\ifelse{latex}{\out{$\hat{\bf g}$}}{\ifelse{html}{\out{<b>&gcirc;</b>}}{ghat}}, \ifelse{latex}{\out{$\hat{\bf u}$}}{\ifelse{html}{\out{<b>&ucirc;</b>}}{uhat}}]), where \ifelse{latex}{\out{$\hat{\bf g}$}}{\ifelse{html}{\out{<b>&gcirc;</b>}}{ghat}} and \ifelse{latex}{\out{$\hat{\bf u}$}}{\ifelse{html}{\out{<b>&ucirc;</b>}}{uhat}} are the genetic group and genetic merit solutions, respectively. The order of solutions must be the order of columns and the order of rows in matrix \strong{Q}.
#'
#' @return Vector of \strong{Q}\ifelse{latex}{\out{$\hat{\bf g}$}}{\ifelse{html}{\out{<b>&gcirc;</b>}}{ghat}} + \ifelse{latex}{\out{$\hat{\bf u}$}}{\ifelse{html}{\out{<b>&ucirc;</b>}}{uhat}}
#'
#' @examples
#' ped = data.frame(ID=c(3,4,6,5), SIRE=c(1,3,4,1), DAM=c(2,2,5,2))
#' Q = qmatL(gghead(ped))
#' ghat = c(0.1, -0.2)
#' uhat = seq(-1.5, 1.5, 1)
#' sol = data.frame(ID=1:6, EBV=c(ghat, uhat))
#' Qgpu(Q, sol)
#'
#' @export
Qgpu = function(Q, sol) {
   if(!identical(as.integer(c(colnames(Q), rownames(Q))), sol$ID)) stop("identical(c(colnames(Q), rownames(Q)), sol$ID) = FALSE")
   colnames(sol) = c("ID","EBV")
   Ngg = ncol(Q)
   ghat = sol[1:Ngg,]$EBV
   uhat = sol[(Ngg + 1):nrow(sol),]$EBV
   uhatplus = (Q %*% ghat) + uhat
   return(uhatplus)
}
