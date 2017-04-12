
## Packages

library("methods")
library("EpiModelHPC")
library("EpiModelHIV")

## Parameters

fsimno <- 1013.1
load("nwstats.rda")

nodemix.m <- c(st$stats.m[1] - st$stats.m[2] - st$stats.m[3],
               st$stats.m[2], st$stats.m[3])
nodemix.p <- c(st$stats.p[1] - st$stats.p[2] - st$stats.p[3],
               st$stats.p[2], st$stats.p[3])
nodemix.i <- c(st$stats.i[1] - st$stats.i[2] - st$stats.i[3],
               st$stats.i[2], st$stats.i[3])

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
					
					disc.outset.main.B.prob = 0.685,
					disc.outset.main.W.prob = 0.889,
					disc.outset.pers.B.prob = 0.527,
					disc.outset.pers.W.prob = 0.828,
					disc.inst.B.prob = 0.445,
					disc.inst.W.prob = 0.691,
					
					circ.B.prob = (0.874 + 0.918)/2,
					circ.W.prob = (0.874 + 0.918)/2,
					
					ccr5.B.prob = (c(0, 0.034) + c(0.021, 0.176))/2,
					ccr5.W.prob = (c(0, 0.034) + c(0.021, 0.176))/2,
					
					base.ai.main.BB.rate = 1.19 / 7,
					base.ai.main.BW.rate = 1.79 / 7,
					base.ai.main.WW.rate = 1.56 / 7,
					base.ai.pers.BB.rate = 0.75 / 7,
					base.ai.pers.BW.rate = 1.13 / 7,
					base.ai.pers.WW.rate = 0.98 / 7,
					
					cond.main.BB.prob = 0.38,
					cond.main.BW.prob = 0.10,
					cond.main.WW.prob = 0.15,
					cond.pers.BB.prob = 0.39,
					cond.pers.BW.prob = 0.11,
					cond.pers.WW.prob = 0.16,
					cond.inst.BB.prob = 0.49,
					cond.inst.BW.prob = 0.15,
					cond.inst.WW.prob = 0.22,
					
					vv.iev.BB.prob = 0.42,
					vv.iev.BW.prob = 0.56,
					vv.iev.WW.prob = 0.49
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
