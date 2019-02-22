#' @title Inverse of the relationship matrix \strong{A} in a tubular format
#'
#' @description Creates the inverse of the pedigree-based additive genetic relationship matrix in a \code{data.frame}.
#'
#' @param ped : \code{data.frame} with integer columns corresponding to ID, SIRE, DAM. Missing value is 0.
#'
#' @param inb : Inbreeding coefficients in the order of animals in the relationship matrix. It can be derived from \code{buildA} or \code{tubularA}.
#'
#' @details
#' \code{inb = diag(buildA) - 1}, or
#'
#' \code{inb = tubA(ped); inb = inb[inb[,1]==inb[,2],]$a - 1}
#'
#' @return Inverse of the genetic relationship \code{data.frame}
#'
#' @examples
#' ped = data.frame(ID=1:6, SIRE=c(0,0,1,3,1,4), DAM=c(0,0,2,2,2,5))
#' inb = c(0, 0, 0, 0.25, 0, 0.25)
#' tubAinv(ped, inb)
#'
#' @export
tubAinv = function(ped, inb) {
   colnames(ped) = c("ID", "SIRE", "DAM")
   if(length(inb[inb < 0 | inb > 1])==0)
   {
      if(nrow(ped)==length(inb))
      {
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
                  Fs = inb[which(unique(sort(ped$ID))==curr.set[i,]$SIRE)]
                  Fd = inb[which(unique(sort(ped$ID))==curr.set[i,]$DAM) ]
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
                  Fp = inb[which(unique(sort(ped$ID))==curr.set[i,2:3][curr.set[i,2:3]!=0])]
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
      } else {
         print("Number of animals in the ped2igree does not match with the number of inbreeding values.")
      }
   } else {
      print("Inbreeding values should be between 0 and 1.")
   }
}
