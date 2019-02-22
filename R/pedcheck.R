#' @title Basic pedigree checks
#'
#' @description Performs basic pedigree checks.
#'
#' @param ped : \code{data.frame} with integer columns corresponding to ID, SIRE, DAM. Missing value is 0.
#'
#' @examples
#' set.seed(127)
#' ped = data.frame(ID=c(1:50,NA,0,1:3),
#'                  SIRE=c(0, sample(c(0,10:25), 53, replace=TRUE), 51),
#'                  DAM=c(0, NA, 52, sample(c(0,20:35), 52, replace=TRUE)))
#' pedcheck(ped)
#'
#' @export
pedcheck = function(ped) {
   WARNS = 0
   if(nrow(ped) > 0)
   {
      colnames(ped) = c("ID", "SIRE", "DAM")
      if(nrow(ped[duplicated(ped$ID),]) > 0)
      {
         print("WARNING: Found duplicates in the first column:")
         print(sort(unique(ped$ID[duplicated(ped$ID)])))
         WARNS = WARNS + 1
      }
      if(nrow(ped[na.omit(ped$ID)==0,]) > 0)
      {
         print("WARNING: Found zeros in the first column, in the following rows:")
         print(which(ped$ID==0))
         WARNS = WARNS + 1
      }
      if(nrow(ped[is.na(ped)==TRUE,]) > 0)
      {
         print("WARNING: Found missing values in the following rows:")
         print(which(is.na(ped$ID) | is.na(ped$SIRE) | is.na(ped$DAM)))
         WARNS = WARNS + 1
      }
      sires = unique(ped$SIRE[ped$SIRE!=0])
      dams  = unique(ped$DAM[ped$DAM!=0])
      if(length(intersect(sires, dams)) > 0)
      {
         print("WARNING: Found parents represented as both sire and dam:")
         print(sort(intersect(sires, dams)))
         WARNS = WARNS + 1
      }
      if(length(sires[!sires %in% ped$ID]) > 0)
      {
         print("WARNING: Found sires not available in the first column:")
         print(sort(sires[!sires %in% ped$ID]))
         WARNS = WARNS + 1
      }
      if(length(dams[!dams %in% ped$ID]) > 0)
      {
         print("WARNING: Found dams not available in the first column:")
         print(sort(dams[!dams %in% ped$ID]))
         WARNS = WARNS + 1
      }
      if(nrow(ped[ped$ID <= ped$SIRE,]) > 0)
      {
         print("WARNING: Found individuals with an ID not greater than sire ID:")
         print(sort(ped[ped$ID <= ped$SIRE,]$ID))
         WARNS = WARNS + 1
      }
      if(nrow(ped[ped$ID <= ped$DAM,]) > 0)
      {
         print("WARNING: Found individuals with an ID not greater than dam ID:")
         print(sort(ped[ped$ID <= ped$DAM,]$ID))
         WARNS = WARNS + 1
      }
      if(identical(ped$ID, sort(ped$ID))==FALSE)
      {
         print("WARNING: Pedigree is not sorted.")
         WARNS = WARNS + 1
      }
      if(length(intersect(na.omit(ped[ped$SIRE==0 & ped$DAM==0,]$ID), ped$ID[!ped$ID %in% ped$SIRE & !ped$ID %in% ped$DAM])) > 0)
      {
         print("WARNING: Found individuals with no parent and no progeny. You may consider excluding them:")
         print(sort(intersect(na.omit(ped[ped$SIRE==0 & ped$DAM==0,]$ID), ped$ID[!ped$ID %in% ped$SIRE & !ped$ID %in% ped$DAM])))
         WARNS = WARNS + 1
      }
   } else {
      print("WARNING: The data.frame is empty.")
      WARNS = WARNS + 1
   }
   if(WARNS==0) print("No WARNING!")
}
