#' @title Inverse of the dominance relationship matrix \strong{D} in a tabular format
#'
#' @description Creates the \code{data.frame} of the inverse of the pedigree-based dominance relationship matrix.
#'
#' @param ped : \code{data.frame} with integer columns corresponding to ID, SIRE, DAM. Missing value is 0.
#'
#' @param A : Relationship matrix \strong{A} in a tabular format created by function \code{tabA}.
#'
#' @return \code{data.frame} of the inverse of the dominance relationship matrix
#'
#' @examples
#' ped = data.frame(ID=1:6, SIRE=c(0,0,1,3,1,4), DAM=c(0,0,2,2,2,5))
#' tabDinv(ped, tabA(ped))
#'
#' @export
tabDinv = function(ped, A) {
   colnames(ped) = c("ID", "SIRE", "DAM")
   D = tabD(ped, A)
   D2 = D[D$ID1!=D$ID2,]
   inD2 = unique(c(unique(D2$ID1), unique(D2$ID2)))
   D2 = rbind(D2, data.frame(ID1=inD2, ID2=inD2, d=1))
   Dinv = solve(tab2mat(D2))
   Dinv = mat2tab(Dinv)
   sprs = ped$ID[!ped$ID %in% inD2]
   Dinv = rbind(data.frame(ID1=sprs, ID2=sprs, val=1), Dinv)
   return(Dinv[order(Dinv$ID1),])
}
