#' @title Pedigree renumbering
#'
#' @description Renumbering pedigree to numerical IDs, so that progeny's ID is smaller than parents' IDs.
#'
#' @param ped : \code{data.frame} with columns corresponding to ID, SIRE, DAM. Missing value is 0.
#'
#' @return newped : Pedigree \code{data.frame} with renumberred IDs.
#'
#' @return xrf : Cross-reference \code{data.frame} with 2 columns for original and renumberred IDs.
#'
#' @examples
#' ped = data.frame(ID=letters[1:6], SIRE=c(0,0,letters[c(1,3,1,4)]), DAM=c(0,0,letters[c(2,2,2,5)]))
#' renum(ped)
#'
#' @export
renum = function(ped) {
   colnames(ped) = c("ID", "SIRE", "DAM")
   for(i in 1:3) ped[,i] = paste0("x", ped[,i])
   ped[ped=="x0"] = 0
   newped = ped
   xrf = data.frame(ID=c(), newID=c())
   curr.set = ped[ped$SIRE==0 & ped$DAM==0,]$ID
   xrf = data.frame(ID=curr.set, newID=1:length(curr.set))
   ped = ped[!ped$ID %in% curr.set,]
   gen = 1
   while(nrow(ped) > 0)
   {
      curr.set = ped[!ped$SIRE %in% ped$ID & !ped$DAM %in% ped$ID,]
      curr.set = curr.set[order(curr.set$DAM, curr.set$SIRE),]$ID
      xrf = rbind(xrf, data.frame(ID=curr.set, newID=(xrf[nrow(xrf),]$newID+1):(xrf[nrow(xrf),]$newID+length(curr.set))))
      ped = ped[!ped$ID %in% curr.set,]
      gen = gen + 1
   }
   newped[] = xrf$newID[match(unlist(newped), xrf$ID)]
   newped[is.na(newped)] = 0
   newped = newped[order(newped$ID),]
   xrf$ID = substring(xrf$ID, 2)
   message(paste("Found", gen, "generations"))
   return(list(newped, xrf))
}
