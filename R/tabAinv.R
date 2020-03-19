#' @title Inverse of the relationship matrix \strong{A} in a tabular format
#'
#' @description Creates the \code{data.frame} of the inverse of the pedigree-based genetic relationship matrix.
#'
#' @param ped : \code{data.frame} with integer columns corresponding to ID, SIRE, DAM. Missing value is 0.
#'
#' @param inbr : Vector of inbreeding coefficients in the order of individuals in the relationship matrix.
#'
#' @return \code{data.frame} of the inverse of the genetic relationship matrix
#'
#' @examples
#' ped = data.frame(ID=1:6, SIRE=c(0,0,1,3,1,4), DAM=c(0,0,2,2,2,5))
#' inbr = c(0, 0, 0, 0.25, 0, 0.25)
#' # or
#' (inbr = diag(buildA(ped)) - 1)
#' # or
#' inbr = tabA(ped); (inbr = inbr[inbr[,1]==inbr[,2],]$a - 1)
#' # or
#' # For individual inbreeding values, use function inb.
#' tabAinv(ped, inbr)
#'
#' @export
tabAinv = function(ped, inbr) {
  colnames(ped) = c("ID", "SIRE", "DAM")
  if(any(inbr < 0 | inbr > 1)) stop("Inbreeding values should be between 0 and 1.")
  if(nrow(ped)!=length(inbr)) stop("Number of individuals in the pedigree does not match with the number of inbreeding values.")
  inbr = data.frame(ID=ped$ID, F=inbr)
  ped = merge(ped, inbr, by.x="SIRE", by.y="ID", all.x=TRUE)
  ped = merge(ped, inbr, by.x="DAM",  by.y="ID", all.x=TRUE)
  ped = ped[order(ped$ID),]
  colnames(ped)[4:5] = c("fs", "fd")
  ped[is.na(ped)] = 0
  Ai = data.frame(ID1=ped$ID[1], ID2=ped$ID[1], ai=1)
  for(i in 2:nrow(ped))
  {
    iID = ped$ID[i]
    si = ped$SIRE[i]
    di = ped$DAM[i]
    Fs = ped$fs[i]
    Fd = ped$fd[i]
    if(si >0 & di==0) {
      b = (3 - Fs)/4
      tmp = data.frame(ID1=c(si,si,iID), ID2=c(si,iID,iID), ai=c(0.25,-0.5,1)/b)
      Ai = rbind(Ai, tmp)
    }
    if(si==0 & di >0) {
      b = (3 - Fd)/4
      tmp = data.frame(ID1=c(di,di,iID), ID2=c(di,iID,iID), ai=c(0.25,-0.5,1)/b)
      Ai = rbind(Ai, tmp)
    }
    if(si >0 & di >0) {
      b = (2 - Fs - Fd)/4
      tmp = data.frame(ID1=c(si,si,si,di,di,iID),
                       ID2=c(si,di,iID,di,iID,iID),
                       ai=c(0.25,0.25,-0.5,0.25,-0.5,1)/b)
      Ai = rbind(Ai, tmp)
    }
    if(si==0 & di==0) {
      Ai = rbind(Ai, c(iID, iID, 1))
    }
    if((i %% 1000)==0) message(i, " of ", nrow(ped))
  }
  if(i > 1000) message(i, " of ", nrow(ped))
  Ai = transform(Ai, ID1=pmin(Ai$ID1, Ai$ID2), ID2=pmax(Ai$ID1, Ai$ID2))
  Ai = aggregate(Ai$ai, by=list(Ai$ID1, Ai$ID2), FUN=sum)
  colnames(Ai) = c("ID1","ID2","ai")
  return(Ai)
}
