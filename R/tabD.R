#' @title Dominance relationship matrix \strong{D} in a tabular format
#'
#' @description Creates the pedigree-based dominance relationship \code{data.frame}.
#'
#' @param ped : \code{data.frame} with integer columns corresponding to ID, SIRE, DAM. Missing value is 0.
#'
#' @return Dominance relationship \code{data.frame}
#'
#' @examples
#' ped = data.frame(ID=1:6, SIRE=c(0,0,1,3,1,4), DAM=c(0,0,2,2,2,5))
#' tabD(ped)
#'
#' @export
tabD = function(ped) {
  colnames(ped) = c("ID", "SIRE", "DAM")
  A = buildA(ped)
  excl = ped[ped$SIRE==0 | ped$DAM==0,]$ID
  D = data.frame(ID1=excl, ID2=excl, d=1)
  ped = ped[!ped$ID %in% excl,]
  if(nrow(ped)==0) stop("No animals with both parents known")
  for(i in 1:nrow(ped))
  {
    for(j in i:nrow(ped))
    {
      if(i==j)
      {
        dij = 1
      } else {
        Si = ped[i,2]
        Di = ped[i,3]
        Sj = ped[j,2]
        Dj = ped[j,3]
        B = A[c(which(rownames(A)==Si), which(rownames(A)==Di)),
              c(which(colnames(A)==Sj), which(colnames(A)==Dj))]
        dij = (B[1,2]*B[2,1] + B[1,1]*B[2,2])/4
      }
      if(dij > 0) D = rbind(D, c(ped[i,]$ID, ped[j,]$ID, dij))
    }
  }
  return(D[order(D$ID1),])
}
