#' @title Inbreeding coefficient
#'
#' @description Calculate inbreeding coefficient for an individual.
#'
#' @param ped : \code{data.frame} with integer columns corresponding to ID, SIRE, DAM. Missing value is 0.
#'
#' @param id : Numeric ID of an individual
#'
#' @return Inb : Inbreeding coefficient of the individual
#'
#' @examples
#' ped = data.frame(ID=1:7, SIRE=c(0,0,1,1,3,1,5), DAM=c(0,0,0,2,4,4,6))
#' inb(ped, 7)
#'
#' @export
inb = function(ped, id) {
   colnames(ped) = c("ID","SIRE","DAM")
   sire = ped[ped$ID==id,]$SIRE
   dam  = ped[ped$ID==id,]$DAM
   if(sire > 0 & dam > 0)
   {
      Inb = rg(ped, sire, dam)/2
   } else {
      Inb = 0
   }
   return(Inb)
}
