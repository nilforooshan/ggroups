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
   if(nrow(ped) < 1) stop("The data.frame is empty.")
   colnames(ped) = c("ID", "SIRE", "DAM")
   WARNS = 0
   if(nrow(ped[duplicated(ped$ID),]) > 0)
   {
      cat("Found duplicates in the first column:", "\n")
      cat(sort(unique(ped$ID[duplicated(ped$ID)])), "\n")
      WARNS = WARNS + 1
   }
   if(nrow(ped[na.omit(ped$ID)==0,]) > 0)
   {
      cat("Found zeros in the first column, in the following rows:", "\n")
      cat(which(ped$ID==0), "\n")
      WARNS = WARNS + 1
   }
   if(nrow(ped[is.na(ped)==TRUE,]) > 0)
   {
      cat("Found missing values in the following rows:", "\n")
      cat(which(is.na(ped$ID) | is.na(ped$SIRE) | is.na(ped$DAM)), "\n")
      WARNS = WARNS + 1
   }
   sires = unique(ped$SIRE[ped$SIRE!=0])
   dams  = unique(ped$DAM[ped$DAM!=0])
   if(length(intersect(sires, dams)) > 0)
   {
      cat("Found parents represented as both sire and dam:", "\n")
      cat(sort(intersect(sires, dams)), "\n")
      WARNS = WARNS + 1
   }
   if(length(sires[!sires %in% ped$ID]) > 0)
   {
      cat("Found sires not available in the first column:", "\n")
      cat(sort(sires[!sires %in% ped$ID]), "\n")
      WARNS = WARNS + 1
   }
   if(length(dams[!dams %in% ped$ID]) > 0)
   {
      cat("Found dams not available in the first column:", "\n")
      cat(sort(dams[!dams %in% ped$ID]), "\n")
      WARNS = WARNS + 1
   }
   if(nrow(ped[ped$ID <= ped$SIRE,]) > 0)
   {
      cat("Found individuals with an ID not greater than sire ID:", "\n")
      cat(sort(ped[ped$ID <= ped$SIRE,]$ID), "\n")
      WARNS = WARNS + 1
   }
   if(nrow(ped[ped$ID <= ped$DAM,]) > 0)
   {
      cat("Found individuals with an ID not greater than dam ID:", "\n")
      cat(sort(ped[ped$ID <= ped$DAM,]$ID), "\n")
      WARNS = WARNS + 1
   }
   if(identical(ped$ID, sort(ped$ID))==FALSE)
   {
      cat("Pedigree is not sorted.", "\n")
      WARNS = WARNS + 1
   }
   if(length(intersect(na.omit(ped[ped$SIRE==0 & ped$DAM==0,]$ID), ped$ID[!ped$ID %in% ped$SIRE & !ped$ID %in% ped$DAM])) > 0)
   {
      cat("Found individuals with no parent and no progeny. You may consider excluding them:", "\n")
      cat(sort(intersect(na.omit(ped[ped$SIRE==0 & ped$DAM==0,]$ID), ped$ID[!ped$ID %in% ped$SIRE & !ped$ID %in% ped$DAM])), "\n")
      WARNS = WARNS + 1
   }
   if(WARNS==0) cat("No warnings!", "\n")
}
