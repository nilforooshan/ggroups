#' @title Create matrix \strong{Q}
#'
#' @description Creates the genetic group contribution matrix.
#'
#' @param ped2 : The output of \code{gghead}; for more details: \code{?gghead}
#'
#' @return Qmat : Matrix \strong{Q}
#'
#' @examples
#' ped = data.frame(ID=c(3,4,6,5), SIRE=c(1,3,4,1), DAM=c(2,2,5,2))
#' ped2 = gghead(ped)
#' qmat(ped2)
#'
#' @export
qmat = function(ped2) {
   Ngg = nrow(ped2[ped2$SIRE==0 & ped2$DAM==0,])
   pedobj = pedigreemm::pedigree(label=ped2$ID, sire=ped2$SIRE, dam=ped2$DAM)
   Qmat = pedigreemm::getA(pedobj)[-Ngg:-1, 1:Ngg]
   return(Qmat)
}
