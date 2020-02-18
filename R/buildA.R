#' @title Relationship matrix \strong{A}
#'
#' @description Builds the pedigree-based additive genetic relationship matrix.
#'
#' @param ped : \code{data.frame} with integer columns corresponding to ID, SIRE, DAM. Missing value is 0.
#'
#' @return Relationship \code{matrix} \strong{A}
#'
#' @examples
#' ped = data.frame(ID=1:6, SIRE=c(0,0,1,3,1,4), DAM=c(0,0,2,2,2,5))
#' buildA(ped)
#'
#' @export
buildA = function(ped) {
  colnames(ped) = c("ID", "SIRE", "DAM")
  A = diag(nrow(ped))
  for(i in 2:nrow(ped))
  {
    si = ped[i, 2:3]
    di = si[[2]]
    si = si[[1]]
    if(si > 0 | di > 0) {
      if(si > 0) si = which(ped$ID==si)
      if(di > 0) di = which(ped$ID==di)
      for(j in 1:i)
      {
        if(j==i) {
          if(si > 0 & di > 0) A[i,j] = 1 + A[si,di]/2
        } else {
          if(si > 0) A[i,j] = A[j,i] = A[j,si]/2
          if(di > 0) A[i,j] = A[j,i] = A[j,i] + A[j,di]/2
        }
      }
    }
  }
  colnames(A) = row.names(A) = ped$ID
  return(A)
}
