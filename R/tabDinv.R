#' @title Inverse of the dominance relationship matrix \strong{D} in a tabular format
#'
#' @description Creates the \code{data.frame} of the inverse of the pedigree-based dominance relationship matrix.
#'
#' @param ped : \code{data.frame} with integer columns corresponding to ID, SIRE, DAM. Missing value is 0.
#'
#' @return \code{data.frame} of the inverse of the dominance relationship matrix
#'
#' @examples
#' ped = data.frame(ID=1:6, SIRE=c(0,0,1,3,1,4), DAM=c(0,0,2,2,2,5))
#' tabDinv(ped)
#'
#' @export
tabDinv = function(ped) {
   colnames(ped) = c("ID", "SIRE", "DAM")
   D = tabD(ped)
   diagD = D[D$ID1==D$ID2,]$ID1
   D2 = D[D$ID1!=D$ID2,]
   if(nrow(D2)==0)
   {
     Dinv = D
   } else {
     diags = unique(c(unique(D2$ID1), unique(D2$ID2)))
     D2 = rbind(D2, data.frame(ID1=diags, ID2=diags, d=1))
     Dinv = solve(tab2mat(D2))
     rownames(Dinv) = colnames(Dinv) = substring(rownames(Dinv), 2)
     Dinv = mat2tab(Dinv)
     diags = diagD[!diagD %in% diags]
     Dinv = rbind(data.frame(ID1=diags, ID2=diags, val=1), Dinv)
   }
   return(Dinv[order(Dinv$ID1),])
}

