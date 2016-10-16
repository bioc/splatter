#' Lun2 simulation
#'
#' Simulate single-cell RNA-seq count data using the method described in Lun
#' and Marioni "Overcoming confounding plate effects in differential expression
#' analyses of single-cell RNA-seq data".
#'
#' @param params Lun2Params object containing simulation parameters.
#' @param zinb logical. Whether to use a zero-inflated model.
#' @param verbose logical. Whether to print progress messages
#' @param ... any additional parameter settings to override what is provided in
#'        \code{params}.
#'
#' @details
#' The Lun2 simulation uses a negative-binomial distribution where the means and
#' dispersions have been sampled from a real dataset
#' (using \code{\link{lun2Estimate}}). The other core feature of the Lun2
#' simulation is the addition of plate effects. Differential expression can be
#' added between two groups of plates (an "ingroup" and all other plates).
#' Library size factors are also applied and optionally a zero-inflated
#' negative-binomial can be used.
#'
#' @return SCESet containing simulated counts.
#'
#' @references
#' Lun ATL, Marioni JC. Overcoming confounding plate effects in differential
#' expression analyses of single-cell RNA-seq data. bioRxiv (2016).
#'
#' Paper: \url{dx.doi.org/10.1101/073973}
#'
#' Code: \url{https://github.com/MarioniLab/PlateEffects2016}
#'
#' @examples
#' sim <- lun2Simulate()
#' @export
#' @importFrom scater newSCESet
lun2Simulate <- function(params = newLun2Params(), zinb = FALSE,
                         verbose = TRUE, ...) {

    checkmate::assertClass(params, "Lun2Params")
    params <- setParams(params, ...)

    # Set random seed
    seed <- getParam(params, "seed")
    set.seed(seed)

    if (verbose) {message("Getting parameters...")}
    nGenes <- getParam(params, "nGenes")
    nCells <- getParam(params, "nCells")
    nPlates <- getParam(params, "nPlates")
    cell.plates <- getParam(params, "cell.plates")
    plate.var <- getParam(params, "plate.var") / getParam(params, "plate.mod")
    lib.sizes <- getParam(params, "cell.libSizes")
    lib.mod <- getParam(params, "cell.libMod")
    # Select gene parameters depending on model
    if (!zinb) {
        gene.means <- getParam(params, "gene.means")
        gene.disps <- getParam(params, "gene.disps")
    } else {
        gene.means <- getParam(params, "gene.ziMeans")
        gene.disps <- getParam(params, "gene.ziDisps")
        gene.ziProps <- getParam(params, "gene.ziProps")
    }
    de.nGenes <- getParam(params, "de.nGenes")

    # Set up objects to store intermediate values
    cell.names <- paste0("Cell", 1:nCells)
    gene.names <- paste0("Gene", 1:nGenes)

    features <- new("AnnotatedDataFrame",
                    data = data.frame(Gene = gene.names, GeneMean = gene.means,
                                      GeneDisp = gene.disps))
    phenos <- new("AnnotatedDataFrame",
                  data = data.frame(Cell = cell.names, Plate = cell.plates))

    if (zinb) {
        features$GeneZeroProp <- gene.ziProps
    }

    if (verbose) {message("Simulating plate means...")}
    plate.facs <- matrix(exp(rnorm(nGenes * nPlates, mean = -plate.var / 2,
                                   sd = sqrt(plate.var))),
                         nrow = nGenes, ncol = nPlates)
    base.plate.means <- gene.means * plate.facs

    if (de.nGenes > 0) {
        title <- "BaseGeneMeanPlate"
    } else {
        title <- "GeneMeanPlate"
    }
    for (idx in 1:nPlates) {
        features[[paste0("PlateFacPlate", idx)]] <- plate.facs[, idx]
        features[[paste0(title, idx)]] <- base.plate.means[, idx]
    }

    plate.means <- base.plate.means

    if (de.nGenes > 0) {
        if (verbose) {message("Simulating differential expression...")}
        plate.ingroup <- getParam(params, "plate.ingroup")
        de.fc <- sqrt(getParam(params, "de.fc"))

        ingroup <- match(plate.ingroup, levels(cell.plates))
        de.chosen <- sample(nGenes, de.nGenes)
        de.isUp <- rep(c(TRUE, FALSE), length.out = de.nGenes)

        de.facs <- rep(1, nGenes)
        de.facs[de.chosen[de.isUp]] <- de.fc
        de.facs[de.chosen[!de.isUp]] <- 1 / de.fc

        plate.means[, ingroup] <- plate.means[, ingroup] * de.facs
        plate.means[, -ingroup] <- plate.means[, -ingroup] * (1 / de.facs)

        phenos$Ingroup <- cell.plates %in% plate.ingroup
        features$DEFacIngroup <- de.facs
        features$DEFacOutgroup <- 1 / de.facs
        for (idx in 1:nPlates) {
            features[[paste0("GeneMeanPlate", idx)]] <- plate.means[, idx]
        }
    }

    if (verbose) {message("Simulating libray size factors...")}
    lib.facs <- lib.sizes / mean(lib.sizes)
    lib.facs <- sample(lib.facs, nCells, replace = TRUE) * lib.mod
    phenos$LibSizeFac <- lib.facs

    if (verbose) {message("Simulating cell means...")}
    cell.means <- plate.means[, as.integer(cell.plates)]
    cell.means <- t(t(cell.means) * lib.facs)

    if (verbose) {message("Simulating counts...")}
    true.counts <- matrix(rnbinom(nCells * nGenes, mu = cell.means,
                                  size = 1 / gene.disps),
                          ncol = nCells, nrow = nGenes)
    counts <- true.counts

    if (zinb) {
        if (verbose) {message("Simulating zero inflation...")}
        is.zero <- matrix(rbinom(nCells * nGenes, 1, gene.ziProps),
                          ncol = nCells, nrow = nGenes) == 1
        counts[is.zero] <- 0
    }

    if (verbose) {message("Creating final SCESet...")}

    rownames(phenos) <- cell.names
    rownames(features) <- gene.names
    rownames(counts) <- gene.names
    colnames(counts) <- cell.names
    sim <- newSCESet(countData = counts, phenoData = phenos,
                     featureData = features)

    rownames(cell.means) <- gene.names
    colnames(cell.means) <- cell.names
    assayData(sim)$CellMeans <- cell.means

    rownames(true.counts) <- gene.names
    colnames(true.counts) <- cell.names
    assayData(sim)$TrueCounts <- true.counts

    if (zinb) {
        rownames(is.zero) <- gene.names
        colnames(is.zero) <- cell.names
        assayData(sim)$ZeroInflation <- is.zero
    }

    if (verbose) {message("Done!")}

    return(sim)
}