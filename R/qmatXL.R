#' @title Matrix \strong{Q} for large pedigrees (parallel processing)
#'
#' @description Creates the genetic group contribution matrix for large pedigrees, with parallel processing.
#'
#' @details
#' This function is the parallel version of \code{qmatL}. It requires \code{foreach} and \code{doParallel} packages.
#'
#' @param ped2 : The output \code{data.frame} from \code{gghead} (for more details: \code{?gghead})
#'
#' @param ncl : User defined number of nodes; if the number of nodes is greater than the number of genetic groups, the number genetic groups is considered as the number of nodes.
#'
#' @return Matrix \strong{Q}
#'
#' @examples
#' ped = data.frame(ID=c(3,4,6,5), SIRE=c(1,3,4,1), DAM=c(2,2,5,2))
#' ped2 = gghead(ped)
#' qmatXL(ped2, 2)
#'
if(getRversion() >= "2.15.1")  utils::globalVariables(c("i", "%dopar%", "foreach"))
#' @export
qmatXL = function(ped2, ncl) {
   if(ncl > 1)
   {
      if(requireNamespace("doParallel"))
      # doParallel is only required in this function.
      {
         library("doParallel")
         colnames(ped2) = c("ID", "SIRE", "DAM")
         Ngg = nrow(ped2[ped2$SIRE==0 & ped2$DAM==0,])
         if(ncl > Ngg) ncl = Ngg
         print(paste("Found", Ngg, "genetic groups"))
         ggID = ped2[1:Ngg,]$ID
         animID = ped2[(Ngg+1):nrow(ped2),]$ID
         cl = parallel::makeCluster(ncl)
         doParallel::registerDoParallel(cl)
         Q = foreach(i=ggID, .combine='cbind') %dopar%
         {
            Qc = matrix(0, nrow=nrow(ped2)-Ngg, dimnames=list(animID, i))
            # Function to Calculate the 1st row of A
            Arow1 = function(ped3) {
               ped3$rg = 0
               ped3[1,]$rg = 1
               for(i in 2:nrow(ped3))
               {
                  i_s = i_d = 0
                  if(ped3[i,]$SIRE > 0) i_s = ped3[ped3$ID==ped3[i,]$SIRE,]$rg
                  if(ped3[i,]$DAM  > 0) i_d = ped3[ped3$ID==ped3[i,]$DAM ,]$rg
                  ped3[i,]$rg = (i_s + i_d)/2
               }
               A.row1 = ped3[,c("ID","rg")]
               return(A.row1)
            }
            # Function to extract pedigree from an ancestor
            peddown = function(ped2, indv) {
               oldped = data.frame()
               newped = data.frame(ID=indv, SIRE=0, DAM=0)
               parents = indv
               while(nrow(oldped) < nrow(newped))
               {
                  oldped = newped
                  tmp = ped2[ped2$SIRE %in% parents | ped2$DAM %in% parents,]
                  newped = unique(rbind(newped, tmp))
                  parents = tmp$ID
               }
               newped[!newped$SIRE %in% newped$ID,]$SIRE = 0
               newped[!newped$DAM  %in% newped$ID,]$DAM  = 0
               newped = newped[order(newped$ID),]
               return(newped)
            }
            descendants = peddown(ped2, i)
            A.row1 = Arow1(descendants)[-1,]
            for(j in 1:nrow(A.row1)) Qc[as.character(A.row1[j,]$ID),] = A.row1[j,]$rg
            Qc
         }
         return(Q)
      } else {
         print("Package doParallel needed for this function to work. Please install it.")
      }
   } else {
      print("ERROR: Use qmatL() for ncl < 2.")
   }
}
