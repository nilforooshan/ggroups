#' @title Sire-maternal grandsire (S-MGS) pedigree
#'
#' @description Extract sire-maternal grandsire (S-MGS) pedigree from a sire-dam pedigree. Sire and MGS information is extracted for sires of phenotyped individuals.
#'
#' @param ped : \code{data.frame} with integer columns corresponding to ID, SIRE, DAM. Missing value is 0.
#'
#' @param pheno : Vector of phenotyped individuals
#'
#' @return S-MGS pedigree \code{data.frame}
#'
#' @examples
#' ped = data.frame(ID=1:10, SIRE=c(0,0,1,2,0,5,4,4,0,8), DAM=c(0,0,0,3,3,0,6,6,6,0))
#' smgsped(ped, 7:10)
#'
#' @export
smgsped <- function(ped, pheno) {
  colnames(ped) = c("ID","SIRE","DAM")
  if(!all(pheno %in% ped$ID)) stop("Found phenotyped individuals not available in the 1st column of the pedigree.")
  parentsNA = unique(c(unique(ped$SIRE), unique(ped$DAM)))
  parentsNA = parentsNA[!parentsNA %in% ped$ID & parentsNA > 0]
  if(length(parentsNA) > 0) stop("Found parents not available in the 1st column of the pedigree.")
  sireofphe = unique(ped[ped$ID %in% pheno,]$SIRE)
  sireofphe = sireofphe[sireofphe > 0]
  dams = unique(ped$DAM)
  dams = dams[dams > 0]
  # Extract MGS as
  ped = merge(ped, ped[ped$ID %in% dams, c("ID","SIRE")], by.x="DAM", by.y="ID", all.x=TRUE)
  ped = ped[,c("ID","SIRE.x","SIRE.y")]
  colnames(ped) = c("ID","SIRE","MGS")
  ped[is.na(ped)] = 0
  # ID limited to sires of phenotyped progeny
  newped = ped[ped$ID %in% sireofphe,]
  # Find parents missing in the ID column of the new pedigree
  parentsNA = unique(c(unique(newped$SIRE), unique(newped$MGS)))
  parentsNA = parentsNA[!parentsNA %in% newped$ID & parentsNA > 0]
  # While there are missing parents, append them to the pedigree.
  while(length(parentsNA) > 0)
  {
    newped = rbind(newped, ped[ped$ID %in% parentsNA,])
    parentsNA = unique(c(unique(newped$SIRE), unique(newped$MGS)))
    parentsNA = parentsNA[!parentsNA %in% newped$ID & parentsNA > 0]
  }
  newped = newped[order(newped$ID),]
  return(newped)
}
