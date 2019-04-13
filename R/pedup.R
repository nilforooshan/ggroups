#' @title Upward pedigree extraction
#'
#' @description Extracts pedigree upward for one or a group of individuals to find their ascendants
#'
#' @param ped : \code{data.frame} with integer columns corresponding to ID, SIRE, DAM. Missing value is 0.
#'
#' @param progeny : Vector of individual ID(s), from which the new pedigree is being extracted.
#'
#' @return newped : Extracted pedigree \code{data.frame}
#'
#' @examples
#' ped = data.frame(ID=1:6, SIRE=c(0,0,1,3,1,4), DAM=c(0,0,2,2,2,5))
#' pedup(ped, c(1,4))
#'
#' @export
pedup = function(ped, progeny) {
   colnames(ped) = c("ID","SIRE","DAM")
   parents = progeny
   curr.parents = c(unique(ped[ped$ID %in% progeny,]$SIRE), unique(ped[ped$ID %in% progeny,]$DAM))
   curr.parents = curr.parents[curr.parents!=0]
   while(length(curr.parents) > 0)
   {
      parents = unique(c(parents, curr.parents))
      progeny = curr.parents
      curr.parents = c(unique(ped[ped$ID %in% progeny,]$SIRE), unique(ped[ped$ID %in% progeny,]$DAM))
      curr.parents = curr.parents[curr.parents!=0]
   }
   parents = sort(parents)
   newped = ped[ped$ID %in% parents,]
   return(newped)
}
