#' @title Relationship matrix \strong{D}
#'
#' @description Builds the pedigree-based dominance relationship matrix.
#'
#' @param ped : \code{data.frame} with integer columns corresponding to ID, SIRE, DAM. Missing value is 0.
#'
#' @param A : Relationship matrix \strong{A} created by function \code{buildA}.
#'
#' @return Relationship \code{matrix} \strong{D}
#'
#' @examples
#' ped = data.frame(ID=1:6, SIRE=c(0,0,1,3,1,4), DAM=c(0,0,2,2,2,5))
#' buildD(ped, buildA(ped))
#'
#' @export
buildD = function(ped, A) {
  colnames(ped) = c("ID", "SIRE", "DAM")
  if(!identical(rownames(A), colnames(A))) stop("!identical(rownames(A), colnames(A))")
  if(nrow(ped)!=nrow(A)) stop("nrow(ped)!=nrow(A)")
  if(!identical(rownames(A), as.character(ped[,1]))) stop("!identical(rownames(A), as.character(ped[,1]))")
  D = diag(nrow(ped))
  for(i in 2:nrow(ped))
  {
    si = ped[i, 2]
    di = ped[i, 3]
    if(si > 0) {
      if(di > 0) {
        si = which(ped$ID==si)
        di = which(ped$ID==di)
        for(j in 1:(i-1))
        {
          sj = ped[j, 2]
          dj = ped[j, 3]
          if(sj > 0) {
            if(dj > 0) {
              sj = which(ped$ID==sj)
              dj = which(ped$ID==dj)
              D[i,j] = D[j,i] = (A[si,dj]*A[di,sj] + A[si,sj]*A[di,dj])/4
            }
          }
        }
      }
    }
    if((i %% 1000)==0) message(i, " of ", nrow(ped))
  }
  if(i > 1000) message(i, " of ", nrow(ped))
  colnames(D) = row.names(D) = ped$ID
  return(D)
}
