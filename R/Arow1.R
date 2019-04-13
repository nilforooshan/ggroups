#' @title Calculate the first row of matrix \strong{A}
#'
#' @noRd
Arow1 = function(ped2) {
   colnames(ped2) = c("ID","SIRE","DAM")
   ped2$rg = 0
   ped2[1,]$rg = 1
   for(i in 2:nrow(ped2))
   {
      i_s = i_d = 0
      if(ped2[i,]$SIRE > 0) i_s = ped2[ped2$ID==ped2[i,]$SIRE,]$rg
      if(ped2[i,]$DAM  > 0) i_d = ped2[ped2$ID==ped2[i,]$DAM ,]$rg
      ped2[i,]$rg = (i_s + i_d)/2
   }
   A.row1 = ped2[,c("ID","rg")]
   return(A.row1)
}
