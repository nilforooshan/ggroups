#' @title Create matrix \strong{Q}
#'
#' @description Creates the genetic group contribution matrix.
#'
#' @param ped2 : The output of \code{gghead}; for more details: \code{?gghead}
#'
#' @return Qmat : Matrix \strong{Q}
#'
#' @examples
#' qmat(gghead(sampleped))
#'
#' @export
qmat = function(ped2) {
   Ngg = nrow(ped2[ped2$SIRE==0 & ped2$DAM==0,])
   pedobj = pedigreemm::pedigree(label=ped2$ID, sire=ped2$SIRE, dam=ped2$DAM)
   Qmat = pedigreemm::getA(pedobj)[-Ngg:-1, 1:Ngg]
   return(Qmat)
}
