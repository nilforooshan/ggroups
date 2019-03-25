#' @title Pedigree pruning
#'
#' @description Pruning pedigree in two different modes (strict, loose)
#'
#' @details
#' In strict pruning, animals without progeny and phenotype are recursively deleted from the pedigree, and then animals without known parent and without progeny (if any) are deleted. Therefore, all uninfluential animals are deleted. The downside is that animals without phenotype or phenotyped progeny cannot receive any genetic merit based on the information from their phenotyped relatives.
#' In loose pruning, the pedigree is upward extracted for phenotyped animals to thier founders, and then the pedigree is downward extracted from the founders.
#'
#' @param ped : \code{data.frame} with integer columns corresponding to ID, SIRE, DAM. Missing value is 0.
#'
#' @param pheno : Vector of phenotyped animals
#'
#' @param mode : \code{strict} or \code{loose}
#'
#' @return newped : Pruned pedigree \code{data.frame}
#'
#' @examples
#' ped = data.frame(ID=1:7, SIRE=c(0,0,1,3,1,4,0), DAM=c(0,0,2,2,2,5,0))
#' pheno = c(1,4)
#' pruneped(ped, pheno, mode="strict")
#' pruneped(ped, pheno, mode="loose")
#'
#' @export
pruneped = function(ped, pheno, mode) {
   colnames(ped) = c("ID","SIRE","DAM")
   if(!mode %in% c("strict","loose")) stop("Choose mode strict or loose.")
   if(mode=="strict")
   {
      newped = data.frame()
      oldped = ped
      iter = 0
      while(nrow(newped) < nrow(oldped))
      {
         if(iter==0) newped = oldped
         oldped = newped
         parents = c(unique(newped$SIRE), unique(newped$DAM))
         noprogphe = newped[!newped$ID %in% parents & !newped$ID %in% pheno,]$ID
         newped = newped[!newped$ID %in% noprogphe,]
         iter = iter + 1
      }
      parents = c(unique(newped$SIRE), unique(newped$DAM))
      noparent  = newped[newped$SIRE==0 & newped$DAM==0,]$ID
      noprogeny = newped$ID[!newped$ID %in% parents]
      noparentnoprogeny = intersect(noparent, noprogeny)
      newped = newped[!newped$ID %in% noparentnoprogeny,]
      return(newped)
   } else {
      founders = pedup(ped, pheno)
      founders = founders[founders$SIRE==0 & founders$DAM==0,]$ID
      newped = peddown(ped, founders)
      return(newped)
   }
}
