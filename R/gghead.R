#' @title Append genetic groups to the pedigree
#'
#' @description This function appends parents that are not available in the first column of the pedigree, to the head of the pedigree, and sorts it. Given a pedigree with all missing parents replaced with the corresponding genetic groups, this functions appends genetic groups to the head of the pedigree.
#'
#' @param ped : \code{data.frame} with integer columns corresponding to ID, SIRE, DAM. Missing value is 0.
#'
#' @return Processed pedigree \code{data.frame}
#'
#' @examples
#' ped = data.frame(ID=c(3,4,6,5), SIRE=c(1,3,4,1), DAM=c(2,2,5,2))
#' gghead(ped)
#'
#' @details
#' Consider this simple pedigree:
#'
#' \code{3 0 0}
#'
#' \code{4 3 0}
#'
#' \code{6 4 5}
#'
#' \code{5 0 0}
#'
#' First, unknown parents are replaced with the corresponding genetic groups.
#'
#' Please note that unknown parent IDs should be smaller than animal IDs.
#'
#' \code{3 1 2}
#'
#' \code{4 3 2}
#'
#' \code{6 4 5}
#'
#' \code{5 1 2}
#'
#' Then, \code{gghead} is applied to this pedigree (see the example).
#'
#' @export
gghead = function(ped) {
   colnames(ped) = c("ID", "SIRE", "DAM")
   parents = c(unique(ped$SIRE), unique(ped$DAM))
   gg = parents[!parents %in% ped$ID]
   if(max(gg) >= min(ped$ID)) stop(paste("max(genetic group ID)", max(gg), ">=", min(ped$ID), "min(ID)"))
   tmp = data.frame(ID=gg, SIRE=rep(0, length(gg)), DAM=rep(0, length(gg)))
   ped2 = rbind(tmp, ped)
   ped2 = ped2[order(ped2$ID),]
   return(ped2)
}
