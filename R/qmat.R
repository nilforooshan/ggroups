#' @title Create matrix \strong{Q}
#'
#' @description Creates the genetic group contribution matrix.
#'
#' @param ped : A \code{data.frame} with 3 integer columns corresponding to ID, SIRE, DAM
#'
#' @return Qmat : Matrix \strong{Q}
#'
#' @examples
#' ped = data.frame(ID=c(1:2,4:7), SIRE=c(0,0,1,4,1,5), DAM=c(0,0,2,2,2,6))
#' qmat(ped)
#'
#' @details
#' Individuals are sorted numerically, with parent IDs smaller than progeny ID. Only genetic groups should have unknown parents, denoted as 0.
#'
#' Consider this simple pedigree:
#'
#' \code{4 0 0}
#'
#' \code{5 4 0}
#'
#' \code{6 0 0}
#'
#' \code{7 5 6}
#'
#' First, unknown parents are replaced with the corresponding genetic groups.
#'
#' \code{4 1 2}
#'
#' \code{5 4 2}
#'
#' \code{6 1 2}
#'
#' \code{7 5 6}
#'
#' Then, rows corresponding to genetic groups are added to the head of the pedigree.
#'
#' \code{1 0 0}
#'
#' \code{2 0 0}
#'
#' \code{4 1 2}
#'
#' \code{5 4 2}
#'
#' \code{6 1 2}
#'
#' \code{7 5 6}
#'
#' This pedigree is used as a \code{data.frame}. See the example.
#'
#' @export
qmat = function(ped) {
   Ngg = nrow(ped[ped$SIRE==0 & ped$DAM==0,])
   NggRows = ped[1:Ngg,]
   if(Ngg==nrow(NggRows[NggRows$SIRE==0 & NggRows$DAM==0,]))
   {
      library(pedigreemm)
      pedobj = pedigree(label=ped$ID, sire=ped$SIRE, dam=ped$DAM)
      Qmat = getA(pedobj)[-Ngg:-1, 1:Ngg]
      return(Qmat)
   } else {
      print("pedigree missing only allowed for genetic groups!")
   }
}
