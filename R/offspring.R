#' @title Descendants of an individual per generation
#'
#' @description Counts and collects progeny and phenotyped progeny of an individual in successive generations.
#'
#' @param ped : \code{data.frame} with columns corresponding to ID, SIRE, DAM. Missing value is 0.
#'
#' @param id : The ID of the individual, for which the descendants to be extracted.
#'
#' @param pheno : Vector of phenotyped individuals.
#'
#' @return prgn : \code{list} of progeny per generation.
#'
#' @return prgn.ph : \code{list} of phenotyped progeny per generation.
#'
#' @examples
#' ped = data.frame(V1 = 1:19,
#'    V2 = c(0,0,1,1,0,0,0,0,0,4,5,5,7,0,0,9,0,0,12),
#'    V3 = c(0,0,0,2,0,2,0,3,3,3,0,6,8,8,8,10,11,11,0))
#' pheno = 10:18
#' # Find progeny and phenotyped progeny of individual 1.
#' offspring(ped, 1, pheno)
#' # Find phenotyped progeny of individual 1, in the 2nd generation.
#' offspring(ped, 1, 10:18)$prgn.ph[[2]]
#' # If only interested in finding the progeny of individual 1:
#' offspring(ped, 1, c())$prgn
#'
#' @export
offspring = function(ped, id, pheno) {
   if(length(id)!=1) stop("The 2nd parameter (id) should be of length 1.")
   colnames(ped) = c("ID","SIRE","DAM")
   prgn = prgn.ph = list()
   parent = id
   gen = 0
   while(length(parent > 0))
   {
      progenies = ped[ped$SIRE %in% parent | ped$DAM %in% parent,]$ID
      if(length(progenies) > 0)
      {
         gen = gen + 1
         prgn[[gen]] = progenies
         prgn.ph[[gen]] = progenies[progenies %in% pheno]
      }
      parent = progenies
   }
   if(length(prgn) > 0)
   {
      for(i in 1:length(prgn)) message(paste("Generation", i, ":", length(prgn[[i]]), "progeny, of which", length(prgn.ph[[i]]), "recorded"))
   }
   return(list("prgn"=prgn, "prgn.ph"=prgn.ph))
}
