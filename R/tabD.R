#' @title Dominance relationship matrix \strong{D} in a tabular-sparse format
#'
#' @description Creates the pedigree-based dominance relationship \code{data.frame}.
#'
#' @param ped : \code{data.frame} with integer columns corresponding to ID, SIRE, DAM. Missing value is 0.
#'
#' @param A : Relationship matrix \strong{A} in a tabular format created by function \code{tabA}.
#'
#' @return Dominance relationship \code{data.frame}
#'
#' @examples
#' ped = data.frame(ID=1:6, SIRE=c(0,0,1,3,1,4), DAM=c(0,0,2,2,2,5))
#' tabD(ped, tabA(ped))
#'
#' @export
tabD = function(ped, A) {
  colnames(ped) = c("ID", "SIRE", "DAM")
  colnames(A) = c("ID1","ID2","a")
  tmp = A[,c(2,1,3)]
  colnames(tmp) = colnames(A)
  tmp = tmp[tmp$ID1!=tmp$ID2,]
  A = rbind(A, tmp)
  if(!all(ped$ID %in% unique(A$ID1))) stop("Found ID in ped not in A.")
  if(!all(unique(A$ID1) %in% ped$ID)) stop("Found ID in A not in ped.")
  D = A[A$ID1!=A$ID2, 1:2]
  D = merge(D, ped, by.x="ID1", by.y="ID")
  D = D[D$SIRE > 0 & D$DAM > 0,]
  colnames(D)[3:4] = c("SIRE1","DAM1")
  D = merge(D, ped, by.x="ID2", by.y="ID")
  D = D[D$SIRE > 0 & D$DAM > 0,]
  colnames(D)[5:6] = c("SIRE2","DAM2")
  D = merge(D, A, by.x=c("SIRE1","SIRE2"), by.y=c("ID1","ID2"), all.x=TRUE)
  colnames(D)[ncol(D)] = "SiSj"
  D = merge(D, A, by.x=c("DAM1","DAM2"), by.y=c("ID1","ID2"), all.x=TRUE)
  colnames(D)[ncol(D)] = "DiDj"
  D = merge(D, A, by.x=c("SIRE1","DAM2"), by.y=c("ID1","ID2"), all.x=TRUE)
  colnames(D)[ncol(D)] = "SiDj"
  D = merge(D, A, by.x=c("DAM1","SIRE2"), by.y=c("ID1","ID2"), all.x=TRUE)
  colnames(D)[ncol(D)] = "DiSj"
  D = D[,c("ID1","ID2","SiDj","DiSj","SiSj","DiDj")]
  D[is.na(D)] = 0
  D$d = (D$SiDj*D$DiSj + D$SiSj*D$DiDj)/4
  D = D[D$d > 0, c("ID1","ID2","d")]
  D = rbind(D, data.frame(ID1=ped$ID, ID2=ped$ID, d=1))
  D = D[order(D$ID1, D$ID2),]
  return(D)
}
#################################################################
tabD = function(ped, A) {
  colnames(ped) = c("ID", "SIRE", "DAM")
  colnames(A) = c("ID1","ID2","a")
  if(!all(ped$ID %in% unique(A$ID1))) stop("Found ID in ped not in A.")
  if(!all(unique(A$ID1) %in% ped$ID)) stop("Found ID in A not in ped.")
  D = A[A$ID1!=A$ID2, 1:2]
  D = merge(D, ped, by.x="ID1", by.y="ID")
  D = D[D$SIRE > 0 & D$DAM > 0,]
  colnames(D)[3:4] = c("SIRE1","DAM1")
  D = merge(D, ped, by.x="ID2", by.y="ID")
  D = D[D$SIRE > 0 & D$DAM > 0,]
  colnames(D)[5:6] = c("SIRE2","DAM2")
  tmp = A[,c(2,1,3)]
  colnames(tmp) = colnames(A)
  tmp = tmp[tmp$ID1!=tmp$ID2,]
  A = rbind(A, tmp)
  D = merge(D, A, by.x=c("SIRE1","SIRE2"), by.y=c("ID1","ID2"), all.x=TRUE)
  colnames(D)[ncol(D)] = "SiSj"
  D = merge(D, A, by.x=c("DAM1","DAM2"), by.y=c("ID1","ID2"), all.x=TRUE)
  colnames(D)[ncol(D)] = "DiDj"
  D = merge(D, A, by.x=c("SIRE1","DAM2"), by.y=c("ID1","ID2"), all.x=TRUE)
  colnames(D)[ncol(D)] = "SiDj"
  D = merge(D, A, by.x=c("DAM1","SIRE2"), by.y=c("ID1","ID2"), all.x=TRUE)
  colnames(D)[ncol(D)] = "DiSj"
  D = D[,c("ID1","ID2","SiDj","DiSj","SiSj","DiDj")]
  D[is.na(D)] = 0
  D$d = (D$SiDj*D$DiSj + D$SiSj*D$DiDj)/4
  D = D[D$d > 0, c("ID1","ID2","d")]
  D = rbind(D, data.frame(ID1=ped$ID, ID2=ped$ID, d=1))
  D = D[order(D$ID1, D$ID2),]
  return(D)
}
