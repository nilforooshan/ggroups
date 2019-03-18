#' @title Calculate the first row of matrix \strong{A}
#'
#' @noRd
Arow1 = function(ped3) {
   colnames(ped3) = c("ID","SIRE","DAM")
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
