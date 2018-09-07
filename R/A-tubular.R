#' @name buildA
#'
#' @title Relationship matrix \strong{A}
#'
#' @description Creates the pedigree-based additive genetic relationship matrix.
#'
#' @param ped : The pedigree \code{data.frame} with integer columns corresponding to ID, SIRE, DAM.
#'
#' @return A : Relationship matrix \strong{A}
#'
#' @examples
#' ped = data.frame(ID=1:6, SIRE=c(0,0,1,3,1,4), DAM=c(0,0,2,2,2,5))
#' buildA(ped)
#'
#' @export
buildA = function(ped) {
   pedlist = split(ped[,1:3], seq(nrow(ped)))
   A = diag(nrow(ped))
   colnames(A) = rownames(A) = ped[["ID"]]
   for(i in 1:nrow(A))
   {
      for(j in 2:ncol(A))
      {
         if(j >= i)
         {
            sire= c(pedlist[[j]]["SIRE"])
            dam = c(pedlist[[j]]["DAM"])
            i_s = i_d = s_d = 0
            if(sire > 0) i_s = A[i,which(colnames(A)==sire)]
            if(dam  > 0) i_d = A[i,which(colnames(A)==dam) ]
            if(sire > 0 & dam > 0) s_d = A[which(rownames(A)==sire),which(colnames(A)==dam)]
            A[i,j] = (i_s + i_d)/2
            if(j==i) A[i,j] = 1 + s_d/2
         }
      }
   }
   A = A + t(A)
   diag(A) = diag(A)/2
   return(A)
}
