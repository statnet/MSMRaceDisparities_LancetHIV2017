
## Packages

library(methods)
library("EpiModelHPC")
library("EpiModelHIV")

## Parameters

fsimno <- 1016.1
load("nwstats.rda")

nodemix.m <- c(st$stats.m[1] - st$stats.m[2] - st$stats.m[3],
               st$stats.m[2], st$stats.m[3])
nodemix.p <- c(st$stats.p[1] - st$stats.p[2] - st$stats.p[3],
               st$stats.p[2], st$stats.p[3])
nodemix.i <- c((st$stats.i[21] - sum(st$stats.i[7:12]) + st$stats.i[1])/2,
               st$stats.i[1] - st$stats.i[21],
               (sum(st$stats.i[7:12]) - st$stats.i[1] + st$stats.i[21])/2
               )

param <- param.mard(nwstats = st, 
					acute.rr = 6.0, 
					vl.acute.rise.int = 45,
					vl.acute.fall.int = 45,
					
					last.neg.test.B.int = (301+315)/2,
					mean.test.B.int = (301+315)/2,
					last.neg.test.W.int = (301+315)/2,
					mean.test.W.int = (301+315)/2,
					
					tt.traj.B.prob = (c(0.077, 0.000, 0.356, 0.567) +
					                    c(0.052, 0.000, 0.331, 0.617))/2,
					tt.traj.W.prob = (c(0.077, 0.000, 0.356, 0.567) +
					                    c(0.052, 0.000, 0.331, 0.617))/2,
					
					tx.init.B.prob = (0.092 + 0.127)/2,
					tx.init.W.prob = (0.092 + 0.127)/2,
					tx.halt.B.prob = (0.0102 + 0.0071)/2,
					tx.halt.W.prob = (0.0102 + 0.0071)/2,
					tx.reinit.B.prob = (0.00066 + 0.00291)/2,
					tx.reinit.W.prob = (0.00066 + 0.00291)/2,
					
					disc.outset.main.B.prob = (0.685 + 0.889)/2,
					disc.outset.main.W.prob = (0.685 + 0.889)/2,
					disc.outset.pers.B.prob = (0.527 + 0.828)/2,
					disc.outset.pers.W.prob = (0.527 + 0.828)/2,
					disc.inst.B.prob = (0.445 + 0.691)/2,
					disc.inst.W.prob = (0.445 + 0.691)/2,
					
					circ.B.prob = 0.874,
					circ.W.prob = 0.918,
					
					ccr5.B.prob = (c(0, 0.034) + c(0.021, 0.176))/2,
					ccr5.W.prob = (c(0, 0.034) + c(0.021, 0.176))/2,
					
					base.ai.main.BB.rate = (sum(nodemix.m * c(1.19, 1.79, 1.56)) / sum(nodemix.m)) / 7,
					base.ai.main.BW.rate = (sum(nodemix.m * c(1.19, 1.79, 1.56)) / sum(nodemix.m)) / 7,
					base.ai.main.WW.rate = (sum(nodemix.m * c(1.19, 1.79, 1.56)) / sum(nodemix.m)) / 7,
					base.ai.pers.BB.rate = (sum(nodemix.p * c(0.75, 1.13, 0.98)) / sum(nodemix.p)) / 7,
					base.ai.pers.BW.rate = (sum(nodemix.p * c(0.75, 1.13, 0.98)) / sum(nodemix.p)) / 7,
					base.ai.pers.WW.rate = (sum(nodemix.p * c(0.75, 1.13, 0.98)) / sum(nodemix.p)) / 7,
					
					cond.main.BB.prob = sum(nodemix.m * c(0.38, 0.10, 0.15)) / sum(nodemix.m),
					cond.main.BW.prob = sum(nodemix.m * c(0.38, 0.10, 0.15)) / sum(nodemix.m),
					cond.main.WW.prob = sum(nodemix.m * c(0.38, 0.10, 0.15)) / sum(nodemix.m),
					cond.pers.BB.prob = sum(nodemix.p * c(0.39, 0.11, 0.16)) / sum(nodemix.p),
					cond.pers.BW.prob = sum(nodemix.p * c(0.39, 0.11, 0.16)) / sum(nodemix.p),
					cond.pers.WW.prob = sum(nodemix.p * c(0.39, 0.11, 0.16)) / sum(nodemix.p),
					cond.inst.BB.prob = sum(nodemix.i * c(0.49, 0.15, 0.22)) / sum(nodemix.i),
					cond.inst.BW.prob = sum(nodemix.i * c(0.49, 0.15, 0.22)) / sum(nodemix.i),
					cond.inst.WW.prob = sum(nodemix.i * c(0.49, 0.15, 0.22)) / sum(nodemix.i),
					
					vv.iev.BB.prob = sum(nodemix.m * c(0.42, 0.56, 0.49)) / sum(nodemix.m),
					vv.iev.BW.prob = sum(nodemix.m * c(0.42, 0.56, 0.49)) / sum(nodemix.m),
					vv.iev.WW.prob = sum(nodemix.m * c(0.42, 0.56, 0.49)) / sum(nodemix.m)
					
)

# needed but then not used for anything
init <- init.mard(nwstats = st, 
					prev.B = 0.05, prev.W = 0.05,
					init.prev.age.slope.B = 0.05 / 12,
					init.prev.age.slope.W = 0.05 / 12
)

control <- control.mard(simno = fsimno, nsteps = 52*300, 
                        start = 1,
                        #initialize.FUN = reinit.mard,
                        nsims = 16, ncores = 16,
                        save.int = 100,
                        save.network = FALSE,
                        save.other = NULL, 
                        verbose = TRUE, verbose.int = 100
                        )

## Simulation
netsim_hpc("fit.rda", param, init, control, 
           save.min = TRUE, save.max=F, compress = "xz")
