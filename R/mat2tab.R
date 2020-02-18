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
# mat2tab = function(mat) {
#   if(!identical(rownames(mat), colnames(mat))) stop("rownames and colnames of the matrix are not identical.")
#   if(!isSymmetric(mat)) stop("The matrix is not symmetric.")
#   ID1 = ID2 = c()
#   for(i in 1:nrow(mat))
#   {
#     ID1 = c(ID1, rownames(mat)[1:i])
#     ID2 = c(ID2, rep(colnames(mat)[i], i))
#   }
#   val = mat[upper.tri(mat, diag=TRUE)]
#   tab = data.frame(ID1, ID2, val)
#   tab = tab[tab$val!=0,]
#   return(tab)
# }
mat2tab = function(mat) {
  if(!identical(rownames(mat), colnames(mat))) stop("rownames and colnames of the matrix are not identical.")
  if(!isSymmetric(mat)) stop("The matrix is not symmetric.")
  n = nrow(mat)
  mat1 = matrix(rep(1:n, n), nrow=n)
  mat2 = t(mat1)
  id1 = mat1[upper.tri(mat1, diag=TRUE)]
  id2 = mat2[upper.tri(mat2, diag=TRUE)]
  tab = data.frame(id1=id1, id2=id2, val=mat[upper.tri(mat, diag=TRUE)])
  tab = tab[tab$val!=0,]
  index = data.frame(row=1:n, ID=rownames(mat))
  tab = merge(tab, index, by.x="id1", by.y="row")
  tab = subset(tab, select=-id1)
  tab = merge(tab, index, by.x="id2", by.y="row")[,c(3,4,2)]
  colnames(tab) = c("ID1","ID2","val")
  return(tab)
}
