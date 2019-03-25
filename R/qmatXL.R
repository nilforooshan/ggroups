#' @title Matrix \strong{Q} for large pedigrees (parallel processing)
#'
#' @description Creates the genetic group contribution matrix for large pedigrees, with parallel processing.
#'
#' @details
#' This function is the parallel version of \code{qmatL}. It requires \code{foreach} and \code{doParallel} packages.
#'
#' @param ped2 : The output \code{data.frame} from \code{gghead} (for more details: \code{?gghead})
#'
#' @param ncl : User defined number of nodes; if the number of user defined nodes is greater than the number of genetic groups, the number genetic groups is considered as the number of nodes.
#'
#' @return Matrix \strong{Q}
#'
#' @examples
#' ped = data.frame(ID=c(3,4,6,5), SIRE=c(1,3,4,1), DAM=c(2,2,5,2))
#' ped2 = gghead(ped)
#' qmatXL(ped2, 2)
#'
if(getRversion() >= "2.15.1")  utils::globalVariables("i")
#' @export
qmatXL = function(ped2, ncl) {
   if(ncl < 2) stop("Use qmatL() for ncl < 2")
   if(requireNamespace(c("doParallel", "foreach"), quietly=TRUE))
   {
      colnames(ped2) = c("ID", "SIRE", "DAM")
      Ngg = nrow(ped2[ped2$SIRE==0 & ped2$DAM==0,])
      if(ncl > Ngg) ncl = Ngg
      message(paste("Found", Ngg, "genetic groups"))
      ggID = ped2[1:Ngg,]$ID
      animID = ped2[(Ngg+1):nrow(ped2),]$ID
      cl = parallel::makeCluster(ncl)
      doParallel::registerDoParallel(cl)
      `%dopar%` <- foreach::`%dopar%`
      Q = foreach::foreach(i=ggID, .combine='cbind', .export=c('Arow1', 'peddown')) %dopar%
      {
         Qc = matrix(0, nrow=nrow(ped2)-Ngg, dimnames=list(animID, i))
         descendants = peddown(ped2, i)
         A.row1 = Arow1(descendants)[-1,]
         for(j in 1:nrow(A.row1)) Qc[as.character(A.row1[j,]$ID),] = A.row1[j,]$rg
         Qc
      }
      parallel::stopCluster(cl)
      return(Q)
   } else {
      message("Package doParallel needed for this function to work. Please install it.")
   }
}
