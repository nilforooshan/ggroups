#' @title Matrix \strong{Q} for large pedigrees
#'
#' @description Creates a genetic group contribution matrix for large pedigrees.
#'
#' @details
#' Calculation of a genetic group contribution matrix for large pedigrees requires a lot of memory and time.
#' This might not be possible on ordinary computers, using the function \code{qmat}.
#' The function \code{qmatXL} takes less RAM and time, making the calculation possible on ordinary computers.
#'
#' @param ped2 : The output of \code{gghead}; for more details: \code{?gghead}
#'
#' @return Q : Matrix \strong{Q}
#'
#' @examples
#' ped = data.frame(ID=c(3,4,6,5), SIRE=c(1,3,4,1), DAM=c(2,2,5,2))
#' ped2 = gghead(ped)
#' qmatXL(ped2)
#'
#' @export
qmatXL = function(ped2) {
   Ngg = nrow(ped2[ped2$SIRE==0 & ped2$DAM==0,])
   print(paste("Found", Ngg, "genetic groups"))
   ggID = ped2[1:Ngg,]$ID
   animID = ped2[(Ngg+1):nrow(ped2),]$ID
   Q = matrix(0, nrow=nrow(ped2)-Ngg, ncol=Ngg, dimnames=list(animID, ggID))
   for(i in ggID)
   {
      print(paste("Processing genetic group", i))
      descendants = peddown(ped2, i)
      A.row1 = Arow1(descendants)[-1,]
      for(j in 1:nrow(A.row1)) Q[as.character(A.row1[j,]$ID), as.character(i)] = A.row1[j,]$rg
   }
   return(Q)
}
#' @title Pedigree extraction from an ancestor
#'
#' @description Extracts pedigree from an ancestor.
#'
#' @param
#' ped2 : The output of \code{gghead}; for more details: \code{?gghead}
#'
#' @param
#' indv : An integer ID of an ancestor
#'
#' @return newped : An extracted pedigree \code{data.frame} with columns corresponding to ID, SIRE, DAM.
#'
#' @noRd
peddown = function(ped2, indv) {
   oldped = data.frame()
   newped = data.frame(ID=indv, SIRE=0, DAM=0)
   parents = indv
   while(nrow(oldped) < nrow(newped))
   {
      oldped = newped
      tmp = ped2[ped2$SIRE %in% parents | ped2$DAM %in% parents,]
      newped = unique(rbind(newped, tmp))
      parents = tmp$ID
   }
   newped[!newped$SIRE %in% newped$ID,]$SIRE = 0
   newped[!newped$DAM  %in% newped$ID,]$DAM  = 0
   newped = newped[order(newped$ID),]
   return(newped)
}
#' @title Row 1 of matrix \strong{A}
#'
#' @description Calculates the 1st row of a genetic relationship matrix.
#'
#' @param ped3 : A pedigree \code{data.frame} with columns corresponding to ID, SIRE, DAM.
#'    This is usually a fraction of a pedigree extracted from an ancestor, which is the output of \code{peddown}.
#'
#' @return A.row1 : Genetic relationships with an ancestor; a \code{data.frame} with columns corresponding to ID, rg.
#'
#' @noRd
Arow1 = function(ped3) {
   ped3$rg = 0
   ped3[1,]$rg = 1
   for(i in 2:nrow(ped3))
   {
      i_s = i_d = 0
      if(ped3[i,]$SIRE > 0) i_s = ped3[ped3$ID==ped3[i,]$SIRE,]$rg
      if(ped3[i,]$DAM  > 0) i_d = ped3[ped3$ID==ped3[i,]$DAM ,]$rg
      ped3[i,]$rg = (i_s + i_d)/2
   }
   A.row1 = ped3[,c("ID","rg")]
   return(A.row1)
}
