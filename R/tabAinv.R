#' @title Inverse of the relationship matrix \strong{A} in a tabular format
#'
#' @description Creates the inverse of the pedigree-based additive genetic relationship matrix in a \code{data.frame}.
#'
#' @param ped : \code{data.frame} with integer columns corresponding to ID, SIRE, DAM. Missing value is 0.
#'
#' @param inbr : Inbreeding coefficients in the order of animals in the relationship matrix.
#'
#' @return Inverse of the genetic relationship \code{data.frame}
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
   if(nrow(ped)!=length(inbr)) stop("Number of animals in the pedigree does not match with the number of inbreeding values.")
   curr.set = ped[ped$SIRE==0 & ped$DAM==0,]$ID
   tbAinv = data.frame(ID1=curr.set, ID2=curr.set, ai=1)
   ped2 = ped[!ped$ID %in% curr.set,]
   while(nrow(ped2) > 0)
   {
      curr.set = ped2[!ped2$SIRE %in% ped2$ID & !ped2$DAM %in% ped2$ID,]
      for(i in 1:nrow(curr.set))
      {
         if(curr.set[i,]$SIRE!=0 & curr.set[i,]$DAM!=0)
         {
            Fs = inbr[which(unique(sort(ped$ID))==curr.set[i,]$SIRE)]
            Fd = inbr[which(unique(sort(ped$ID))==curr.set[i,]$DAM) ]
            x = 1/(2 - Fs - Fd)
            tbAinv[tbAinv$ID1==curr.set[i,]$SIRE & tbAinv$ID2==curr.set[i,]$SIRE,]$ai =
            tbAinv[tbAinv$ID1==curr.set[i,]$SIRE & tbAinv$ID2==curr.set[i,]$SIRE,]$ai+x
            tbAinv[tbAinv$ID1==curr.set[i,]$DAM  & tbAinv$ID2==curr.set[i,]$DAM, ]$ai =
            tbAinv[tbAinv$ID1==curr.set[i,]$DAM  & tbAinv$ID2==curr.set[i,]$DAM, ]$ai+x
            tmp = tbAinv[(tbAinv$ID1==curr.set[i,]$SIRE & tbAinv$ID2==curr.set[i,]$DAM ) |
                         (tbAinv$ID1==curr.set[i,]$DAM  & tbAinv$ID2==curr.set[i,]$SIRE),]
            if(nrow(tmp) > 0)
            {
               tbAinv[tbAinv$ID1==tmp$ID1 & tbAinv$ID2==tmp$ID2,]$ai =
               tbAinv[tbAinv$ID1==tmp$ID1 & tbAinv$ID2==tmp$ID2,]$ai+x
            } else {
               tbAinv = rbind(tbAinv, c(curr.set[i,]$SIRE, curr.set[i,]$DAM, x))
            }
            tbAinv = rbind(tbAinv, c(curr.set[i,]$ID, curr.set[i,]$SIRE, -2*x))
            tbAinv = rbind(tbAinv, c(curr.set[i,]$ID, curr.set[i,]$DAM,  -2*x))
            tbAinv = rbind(tbAinv, c(curr.set[i,]$ID, curr.set[i,]$ID,    4*x))
         } else {
            Fp = inbr[which(unique(sort(ped$ID))==curr.set[i,2:3][curr.set[i,2:3]!=0])]
            x = 1/(3 - Fp)
            tbAinv[tbAinv$ID1==curr.set[i,2:3][curr.set[i,2:3]!=0] & tbAinv$ID2==curr.set[i,2:3][curr.set[i,2:3]!=0],]$ai =
            tbAinv[tbAinv$ID1==curr.set[i,2:3][curr.set[i,2:3]!=0] & tbAinv$ID2==curr.set[i,2:3][curr.set[i,2:3]!=0],]$ai+x
            tbAinv = rbind(tbAinv, c(curr.set[i,]$ID, curr.set[i,2:3][curr.set[i,2:3]!=0], -2*x))
            tbAinv = rbind(tbAinv, c(curr.set[i,]$ID, curr.set[i,]$ID, 4*x))
         }
      }
      ped2 = ped2[!ped2$ID %in% curr.set$ID,]
   }
   tbAinv = tbAinv[order(tbAinv$ID1, tbAinv$ID2),]
   return(tbAinv)
}
