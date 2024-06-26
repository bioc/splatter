\name{NEWS}
\title{News for Package \pkg{splatter}}

\section{Version 1.28.0, Bioconductor 3.19 Release (2024-05-01)}{
  \itemize{
    \item{
      Properly prevent output from \code{BASiCSEstimate()} and
      \code{scDDSimulate()} when \code{verbose = FALSE}
    }
    \item{
      Minor adjustments to tests to set \code{verbose = FALSE} and specify
      expected warnings
    }
    \item{
      Replace the package man page with an auto-generated page
    }
    \item{
      Add GitHub usernames and the Bioconductor package URL to description
    }
    \item{
      Add \code{@keywords internal} and \code{@noRd} to function docs where
      needed
    }
    \item{
      Modernise code by restyling using styler and fix other minor issues
      suggested by BiocCheck
    }
  }
}

\section{Version 1.26.0, Bioconductor 3.18 Release (2023-10-25)}{
  \itemize{
    \item{
      Fixed a bug in \code{splatSimPathDE()} where DE factors were not adjusted
      based on the path origin (\code{path.from} parameter). This affected paths
      where the path origin was not the simulation origin (i.e.
      \code{path.from != 0}), particularly when the path DE was minimal.
      With this fix paths should no longer drift towards the origin.
    }
  }
}

\section{Version 1.24.0, Bioconductor 3.17 Release (2023-04-26)}{
  \itemize{
    \item{
      Fixed bugs in \code{splatPopSimulate()} where conditional group
      assignments were incorrect when batch effects were applied
      (from Christina Azodi)
    }
    \item{
      Reduced core dependencies by importing scuttle rather than scater (scater
      is suggested) and making ggplot2 a suggested dependency.
    }
  }
}

\section{Version 1.22.0, Bioconductor 3.16 Release (2022-10-31)}{
  \itemize{
    \item{
      Fixed a bug in \code{BASiSSimulate()} when \code{spike.means} is resampled
    }
    \item{
      Fixed bugs in \code{splatPopSimulate()} with non-matching rownames and
      when sampling batches
    }
  }
}

\section{Version 1.20.0, Bioconductor 3.15 Release (2022-04-27)}{
  \itemize{
    \item{
      The splatPop simulation is now published
      doi.org/10.1186/s13059-021-02546-1!
    }
    \item{Improved initalisation of Params objects (from Wenjie Wang)}
    \item{
      Improved fitting of dropout in \code{splatEstimate()}
      \itemize{
        \item{
          Better initialisation of fitting as suggested by the InferCNV package
        }
        \item{Additional fallback method}
      }
    }
    \item{Bug fixes for the splat simulation}
    \item{
      Bug fixes for the the splatPop simulation (from Christina Azodi)
    }
  }
}

\section{Version 1.18.0, Bioconductor 3.14 Release (2021-10-27)}{
  \itemize{
    \item{
      Updates to the splatPop simulation (from Christina Azodi)
      \itemize{
        \item{
          Added functionality to simulate directly from empirical values
        }
        \item{
          Added eqtl.coreg parameter to splatPop
        }
        \item{
          Fixed a bug where too many cells were simulated in splatPop with
          multiple batches
        }
        \item{
          Fixed duplicate cell names in splatPopSimulate
        }
      }
    }
    \item{
      Improved checks for group.prob in SplatParams
    }
    \item{
      Automatically rescale group.prob during setting if it doesn't sum to 1
    }
  }
}

\section{Version 1.16.0, Bioconductor 3.13 Release (2021-05-20)}{
  \itemize{
    \item{
      Substantial updates to the splatPop simulation (from Christina Azodi)
      \itemize{
        \item{
          Added ability to simulate data with complex multiplexed sequencing
          designs
        }
        \item{
          Added simulation of “conditional” effects, where a subset of DE and
          eQTL effects are applied to only a subset of individuals (e.g. disease
          vs. healthy samples)
        }
        \item{
          Added the ability to simulate different numbers of cells for each
          sample, sampled from a gamma distribution.
        }
        \item{
          Updates to the splatPop vignette describing these changes
        }
      }
    }
    \item{
      Logical matrices should now be handled correctly when minimising output
      SingleCellExperiment objects
    }
    \item{
      Other minor fixes
    }
  }
}

\section{Version 1.14.0, Bioconductor 3.12 Release (2020-10-28)}{
  \itemize{
    \item{Add the splatPop simulation. This is a extension to the splat
    simulation contributed by Christina Azodi and Davis McCarthy that adds
    population effects. It allows you to specify relatedness between individuals
    and generate cell-type specific eQTL effects.}
    \item{Add a batch.rmEffect parameter to the Splat simulation. This allows
    generation of a paired simulation without any batch effects.}
    \item{Add a new minimiseSCE function which can be used to remove unneeded
    information from simulation output (or any SingleCellExperiment)}
    \item{All simulations now return sparse assay matrices by default when they
    would be smaller than the equivalent dense matrix. This is controlled by a
    new sparsify argument.}
    \item{Users will now be automatically prompted to install packages if they
    try to use a simulation for which the suggested dependencies are not
    available}
  }
}

\section{Version 1.12.0, Bioconductor 3.11 Release (2020-04-20)}{
  \itemize{
    \item{Add checks for cycles in the Splat path.from parameter.}
    \item{Use alternative algorithm if fitting dropout fails in splatEstimate.}
    \item{Adjust paths example in vignette.}
    \item{Replace defunct functions in vignettes.}
    \item{Minor fixes for compatibility with updates to other packages.}
  }
}

\section{Version 1.10.0, Bioconductor 3.10 Release (2019-10-20)}{
  \itemize{
    \item{Add the (experimental) Kersplat simulation model. This model
    incorporates a gene network and other useful features.}
    \item{Refactor the summariseDiff function and add the KS statistic.}
    \item{Add variable gene correlation plot to compareSCEs and violins to
    other comparison plots.}
    \item{Check for counts assay when estimating from SingleCellExperiment
    objects.}
    \item{Fix where simpleSimulate stores parameters.}
    \item{Fix bugs where parameters were not being passed correctly in
    BASiCSEstimate and sparseDCEstimate.}
    \item{Replace the sc_example_counts dataset from scater with the mockSCE
    function.}
    \item{Tidy and improve estimation function examples and add checks for
    suggested packages.}
    \item{Various fixes for compatibility with updates to other
      packages.}
  }
}

\section{Version 1.8.0, Bioconductor 3.9 Release (2019-04-18)}{
  \itemize{
    \item{Add a Splat parameters vignette}
    \item{Rename the Splat path.length parameter to path.nSteps}
    \item{Fix a bug with parameter order in setParams}
    \item{Fix a bug where Splat groups were being simulated in alphanumeric
          order}
    \item{Protect against integer overflow in simulation functions}
  }
}

\section{Version 1.6.0, Bioconductor 3.8 Release (2018-10-29)}{
  \itemize{
    \item{Fix bug and improve normality testing in splatEstLib}
    \item{Fixes for compatibility with the latest version of BASiCS,
          BASiCSEstimate now uses the regression method}
    \item{Fix bug in getLNormFactors when reversing factors less than one}
    \item{Various updates to tests and documentation}
  }
}

\section{Version 1.3.5, Bioconductor 3.7 Release (2018-04-25)}{
  \itemize{
    \item{Move scater to Imports and add scater version}
    \item{Remove lingering references to SCESets}
    \item{Add option to use a normal distribution for library sizes in Splat
    simulations}
    \item{Allow Splat dropout parameters to be specified by experiment, batch,
    group or cell}
    \item{Add SparseDC simulation}
    \item{Rename params in metadata slot of simulation to Params for
    consistency}
    \item{Improve and colourise Params print output}
    \item{Improve test coverage}
    \item{Various other minor updates and bug fixes}
  }
}

\section{Version 1.1.8, Bioconductor 3.6 Release (2017-10-13)}{
  \itemize{
    \item{Now published in Genome Biology!}
    \item{Converted to the SingleCellExperiment object}
    \item{Added new simulations: BASiCS, mfa, PhenoPath, ZINB-WaVE}
    \item{Added batch effects to the Splat simulation. This required a change
          to the SplatParams object.}
    \item{Improved scDD estimation}
    \item{Added and improved comparison functions}
    \item{Improved default Splat parameters and estimation}
    \item{Improvements to the Lun2Params object}
    \item{Added addGeneLength function}
    \item{Updated simulation references}
    \item{Various other minor updates and bug fixes}
  }
}

\section{Version 0.99.16, Bioconductor 3.5 Release (2017-04-23)}{
  \itemize{
    \item{Splatter is a package for the simple simulation of single-cell
    RNA-seq data, including:}
    \item{Multiple simulation models}
    \item{Parameter estimation from real data}
    \item{Functions for comparing simulations and real datasets}
    \item{Simulation of complex groups and differentiation paths}
  }
}

\section{Version 0.99.0 (2016-12-05)}{
  \itemize{
    \item Package prepared for Bioconductor submission.
  }
}
