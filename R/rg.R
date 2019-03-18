#' @title Genetic relationship coefficient
#'
#' @description Calculate genetic relationship coefficient between two individuals.
#'
#' @param ped : \code{data.frame} with integer columns corresponding to ID, SIRE, DAM. Missing value is 0.
#'
#' @param id1 : Numeric ID of an individual
#'
#' @param id2 : Numeric ID of an individual
#'
#' @return rG : Genetic relationship coefficient between the two individuals
#'
#' @examples
#' ped = data.frame(ID=1:7, SIRE=c(0,0,1,1,3,1,5), DAM=c(0,0,0,2,4,4,6))
#' rg(ped, 5, 6)
#'
#' @export
rg = function(ped, id1, id2) {
   colnames(ped) = c("ID","SIRE","DAM")
   A = buildA(pruneped(ped, c(id1, id2), mode="strict"))
   rG = A[which(rownames(A)==id1), which(rownames(A)==id2)]
   return(rG)
}
