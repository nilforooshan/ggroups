#' @title Relationship matrix \strong{A} in a tabular format
#'
#' @description Creates the pedigree-based additive genetic relationship \code{data.frame}.
#'
#' @param ped : \code{data.frame} with integer columns corresponding to ID, SIRE, DAM. Missing value is 0.
#'
#' @return Genetic relationship \code{data.frame}
#'
#' @examples
#' ped = data.frame(ID=1:6, SIRE=c(0,0,1,3,1,4), DAM=c(0,0,2,2,2,5))
#' tabA(ped)
#'
#' @export
tabA = function(ped) {
   colnames(ped) = c("ID", "SIRE", "DAM")
   curr.set = ped[ped$SIRE==0 & ped$DAM==0,]$ID
   tbA = data.frame(ID1=curr.set, ID2=curr.set, a=1)
   ped = ped[!ped$ID %in% curr.set,]
   gen = 1
   while(nrow(ped) > 0)
   {
      curr.set = ped[!ped$SIRE %in% ped$ID & !ped$DAM %in% ped$ID,]
      for(i in 1:nrow(curr.set))
      {
         tmp = tbA[tbA$ID1 %in% curr.set[i,2:3] | tbA$ID2 %in% curr.set[i,2:3],]
         tmp$a = tmp$a/2
         tmp = rbind(tmp, c(rep(curr.set[i,]$ID, 2), 1))
         tmp2 = tmp[(tmp$ID1==curr.set[i,]$SIRE & tmp$ID2==curr.set[i,]$DAM) |
                    (tmp$ID1==curr.set[i,]$DAM & tmp$ID2==curr.set[i,]$SIRE),]
         if(nrow(tmp2) > 0)
         {
            tmp[nrow(tmp),]$a = tmp2$a + 1
            tmp = rbind(tmp, c(tmp2$ID2, tmp2$ID1, tmp2$a))
         }
         tmp[tmp$ID1 %in% curr.set[i,2:3],]$ID1 = curr.set[i,]$ID
         if(nrow(tmp[tmp$ID1!=curr.set[i,]$ID,]) > 0) tmp[tmp$ID1!=curr.set[i,]$ID,]$ID2 = curr.set[i,]$ID
         tmp[tmp$ID1 > tmp$ID2, 1:2] = tmp[tmp$ID1 > tmp$ID2, 2:1]
         tmp = aggregate(.~ID1+ID2, data=tmp, sum)
         tbA = rbind(tbA, tmp)
      }
      ped = ped[!ped$ID %in% curr.set$ID,]
      gen = gen + 1
   }
   tbA = tbA[order(tbA$ID1, tbA$ID2),]
   message(paste("Found", gen, "generations"))
   return(tbA)
}
