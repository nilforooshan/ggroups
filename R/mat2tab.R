#' @title Matrix to tabular
#'
#' @description Converts matrix data to tabular data.
#'
#' @param mat : \code{matrix}
#'
#' @return tab : \code{data.frame} with 2 integer (IDs) and 1 numeric (values) columns.
#'
#' @examples
#' ped = data.frame(ID=1:6, SIRE=c(0,0,1,3,1,4), DAM=c(0,0,2,2,2,5))
#' mat2tab(buildA(ped))
#'
#' @export
mat2tab = function(mat) {
   if(isSymmetric(mat)==FALSE) stop("The matrix is not symmetric.")
   ID1 = ID2 = c()
   for(i in 1:nrow(mat))
   {
      ID1 = c(ID1, rownames(mat)[1:i])
      ID2 = c(ID2, rep(colnames(mat)[i], i))
   }
   val = mat[upper.tri(mat, diag=TRUE)]
   tab = data.frame(ID1, ID2, val)
   tab = tab[tab$val!=0,]
   return(tab)
}
