#' @title Downward pedigree extraction
#'
#' @description Extracts pedigree downward for one or a group of individuals to find their descendants
#'
#' @param ped : \code{data.frame} with integer columns corresponding to ID, SIRE, DAM. Missing value is 0.
#'
#' @param parents : Vector of individual ID(s), from which the new pedigree is being extracted.
#'
#' @param maxgen : (optional) a positive integer for the maximum number of generations to proceed. If no value is provided, there is no limitation on the maximum number of generations to proceed.
#'
#' @return newped : Extracted pedigree \code{data.frame}
#'
#' @examples
#' ped = data.frame(ID=1:6, SIRE=c(0,0,1,3,1,4), DAM=c(0,0,2,2,2,5))
#' peddown(ped, c(1,4))
#' peddown(ped, 1, maxgen=1)
#'
#' @export
peddown = function(ped, parents, maxgen=c()) {
   if(length(maxgen) >1) stop("Provide a positive integer for maxgen.")
   if(length(maxgen)==1) {
     if(maxgen!=round(maxgen) | maxgen<1) stop("Invalid maxgen")
   }
   colnames(ped) = c("ID","SIRE","DAM")
   oldped = data.frame()
   newped = data.frame(ID=parents, SIRE=0, DAM=0)
   curr.parents = parents
   iter = 0
   maxgen2 = maxgen
   if(length(maxgen)==0) maxgen2 = 1
   while(nrow(oldped) < nrow(newped) & iter < maxgen2)
   {
      oldped = newped
      tmp = ped[ped$SIRE %in% curr.parents | ped$DAM %in% curr.parents,]
      newped = unique(rbind(newped, tmp))
      extra  = newped[ newped$ID %in% newped$ID[duplicated(newped$ID)],]
      if(nrow(extra) > 0)
      {
         newped = newped[!newped$ID %in% newped$ID[duplicated(newped$ID)],]
         for(i in unique(extra$ID))
         {
            newped = rbind(newped, extra[extra$ID==i & extra$SIRE+extra$DAM==max(extra[extra$ID==i,]$SIRE+extra[extra$ID==i,]$DAM),])
         }
      }
      curr.parents = tmp$ID
      if(length(maxgen)==1) iter = iter + 1
   }
   newped[!newped$SIRE %in% newped$ID,]$SIRE = 0
   newped[!newped$DAM  %in% newped$ID,]$DAM  = 0
   newped = newped[order(newped$ID),]
   return(newped)
}
