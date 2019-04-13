#' @title Tabular to matrix
#'
#' @description Converts tabular data to matrix data.
#'
#' @param tab : \code{data.frame} with 2 integer (IDs) and 1 numeric (values) columns.
#'
#' @return mat : \code{matrix}
#'
#' @examples
#' ped = data.frame(ID=1:6, SIRE=c(0,0,1,3,1,4), DAM=c(0,0,2,2,2,5))
#' tab2mat(tabA(ped))
#'
#' @export
tab2mat = function(tab) {
   colnames(tab) = c("ID1", "ID2", "val")
   theset = unique(sort(tab$ID1))
   mat = matrix(0, nrow=length(theset), ncol=length(theset))
   rownames(mat) = paste0('r', theset)
   colnames(mat) = paste0('c', theset)
   for(i in theset) mat[paste0('r', i), paste0('c', tab[tab$ID1==i,]$ID2)] = tab[tab$ID1==i,]$val
   mat = mat + t(mat)
   diag(mat) = diag(mat)/2
   return(mat)
}
