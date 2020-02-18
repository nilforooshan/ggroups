#' @title Matrix \strong{Q}
#'
#' @description Creates the genetic group contribution matrix.
#'
#' @param ped2 : The output \code{data.frame} from \code{gghead} (for more details: \code{?gghead})
#'
#' @return \strong{Q} \code{matrix}
#'
#' @examples
#' ped = data.frame(ID=c(3,4,6,5), SIRE=c(1,3,4,1), DAM=c(2,2,5,2))
#' ped2 = gghead(ped)
#' qmat(ped2)
#'
#' @export
qmat = function(ped2) {
   colnames(ped2) = c("ID", "SIRE", "DAM")
   Ngg = nrow(ped2[ped2$SIRE==0 & ped2$DAM==0,])
   message(paste("Found", Ngg, "genetic groups"))
   Q = buildA(ped2)[-Ngg:-1, 1:Ngg]
   return(Q)
}
