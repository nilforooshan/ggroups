#' @title Pedigree processing
#'
#' @description Does specific pedigree checks; adds genetic groups to the head of the pedigree and sorts it.
#'
#' @param ped : A \code{data.frame} with integer columns corresponding to ID, SIRE, DAM
#'
#' @return ped2 : A processed pedigree \code{data.frame}
#'
#' @examples
#' ped = data.frame(ID=c(3,4,6,5), SIRE=c(1,3,4,1), DAM=c(2,2,5,2))
#' gghead(ped)
#'
#' @details
#' Consider this simple pedigree:
#'
#' 3 0 0
#'
#' 4 3 0
#'
#' 6 4 5
#'
#' 5 0 0
#'
#' First, unknown parents are replaced with the corresponding genetic groups.
#'
#' Please note that unknown parent IDs should be smaller than animal IDs.
#'
#' 3 1 2
#'
#' 4 3 2
#'
#' 6 4 5
#'
#' 5 1 2
#'
#' This pedigree is used as an example.
#'
#' @export
gghead = function(ped) {
   ped[is.na(ped)] = 0
   if(length(ped[ped==0])==0)
   {
      if(nrow(ped[ped$ID < ped$SIRE | ped$ID < ped$DAM,])==0)
      {
         parents = c(unique(ped$SIRE), unique(ped$DAM))
         gg = parents[!parents %in% ped$ID]
         if(max(gg) < min(ped$ID))
         {
            tmp = data.frame(ID=gg, SIRE=rep(0, length(gg)), DAM=rep(0, length(gg)))
            ped2 = rbind(tmp, ped)
            ped2 = ped2[order(ped2$ID),]
            return(ped2)
         } else {
            print(paste("ERROR: max(genetic group ID)", max(gg), ">", min(ped$ID), "min(ID)"))
         }
      } else {
         print("ERROR: ID < SIRE and/or ID < DAM.")
      }
   } else {
      print("ERROR: found missing value in the pedigree")
   }
}
