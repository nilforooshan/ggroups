#' @title Inbreeding coefficients
#'
#' @description Calculates inbreeding coefficients for all animals in the pedigree.
#'
#' @param ped : \code{data.frame} with integer columns corresponding to ID, SIRE, DAM. Missing value is 0.
#'
#' @return Vector of inbreeding coefficients
#'
#' @examples
#' ped = data.frame(ID=1:7, SIRE=c(0,0,1,1,3,1,5), DAM=c(0,0,0,2,4,4,6))
#' inbreed(ped)
#'
#' @export
inbreed  <- function(ped) {
    message("Estimating inbreeding coefficients based on Meuwissen and Luo (1992)")
    N = nrow(ped)
    if(ped[1,1]!=1) stop("The first ID is not equal to 1.")
    if(any(ped[,1] - c(0,ped[-N,1])!=1)) stop("IDs are not sequential.")
    F = L = POINT = rep(0, N)
    D = rep(1, N)
    ped$P1 = apply(ped[,2:3], 1, FUN=max)
    ped$P2 = apply(ped[,2:3], 1, FUN=min)
    for(I in 1:N)
    {
        P1 = ped$P1[I]
        P2 = ped$P2[I]
        if(P2==0) {
            if(P1 > 0) D[I] = (3-F[P1])/4
            F[I] = 0
        } else if(P1==ped$P1[I-1] & P2==ped$P2[I-1]) {
            D[I] = D[I-1]
            F[I] = F[I-1]
        } else {
            D[I] = (2-F[P1]-F[P2])/4
            FI = -1
            L[I] = 1
            J = I
            while(J!=0)
            {
                K = J
                R = L[K]/2
                KS = ped$P1[K]
                KD = ped$P2[K]
                if(KS > 0) {
                    while(POINT[K] > KS) K = POINT[K]
                    L[KS] = L[KS] + R
                    if(KS!=POINT[K]) {
                        POINT[KS] = POINT[K]
                        POINT[K] = KS
                    }
                    if(KD > 0) {
                        while(POINT[K] > KD) K = POINT[K]
                        L[KD] = L[KD] + R
                        if(KD!=POINT[K]) {
                            POINT[KD] = POINT[K]
                            POINT[K] = KD
                        }
                    }
                }
                FI = FI + L[J]^2*D[J]
                L[J] = 0
                K = J
                J = POINT[J]
                POINT[K] = 0
            }
            F[I] = FI
        }
    }
    return(F)
}
