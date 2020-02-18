#' @title Upward pedigree extraction
#'
#' @description Extracts pedigree upward for one or a group of individuals to find their ascendants
#'
#' @param ped : \code{data.frame} with integer columns corresponding to ID, SIRE, DAM. Missing value is 0.
#'
#' @param progeny : Vector of individual ID(s), from which the new pedigree is being extracted.
#'
#' @param maxgen : (optional) a positive integer for the maximum number of generations (continuing from parents of \code{progeny}) to proceed. If no value is provided, there is no limitation on the maximum number of generations to proceed.
#'
#' @return newped : Extracted pedigree \code{data.frame}
#'
#' @examples
#' ped = data.frame(ID=1:6, SIRE=c(0,0,1,3,1,4), DAM=c(0,0,2,2,2,5))
#' pedup(ped, c(1,4))
#' pedup(ped, 6, maxgen=1)
#'
#' @export
pedup = function(ped, progeny, maxgen=c()) {
   if(length(maxgen) >1) stop("Provide a positive integer for maxgen.")
   if(length(maxgen)==1) {
      if(maxgen!=round(maxgen) | maxgen<1) stop("Invalid maxgen")
   }
   if(length(maxgen)==0) maxgen = nrow(ped)
   colnames(ped) = c("ID","SIRE","DAM")
   parents = progeny
   curr.parents = c(unique(ped[ped$ID %in% progeny,]$SIRE), unique(ped[ped$ID %in% progeny,]$DAM))
   curr.parents = curr.parents[curr.parents!=0]
   iter = 0
   while(length(curr.parents) > 0 & iter < maxgen)
   {
      parents = unique(c(parents, curr.parents))
      progeny = curr.parents
      curr.parents = c(unique(ped[ped$ID %in% progeny,]$SIRE), unique(ped[ped$ID %in% progeny,]$DAM))
      curr.parents = curr.parents[curr.parents!=0]
      iter = iter + 1
   }
   newped = ped[ped$ID %in% parents,]
   parents = c(unique(newped$SIRE), unique(newped$DAM))
   parents = parents[parents > 0]
   misspar = parents[!parents %in% newped$ID]
   if(length(misspar) > 0) {
      newped = rbind(data.frame(ID=misspar, SIRE=0, DAM=0), newped)
      newped = newped[order(newped$ID),]
   }
   return(newped)
}
