
## Race equal scenario setup file

rm(list = ls())
suppressPackageStartupMessages(library(Mardham))


# Time unit for simulation, relative to 1 day
time.unit <- 7

# Population size by race
num.B <- 5000
num.W <- 5000

# mean/pers degree distributions matrices.
deg.mp.B <- deg.mp.W <-
  matrix(c(0.435, 0.184, 0.095, 0.233, 0.033, 0.020), byrow=2, nrow=2)

# Revised rates
mdeg.inst.B <- mdeg.inst.W <-
  matrix(c(0.008186, 0.012017, 0.013024, 0.008151, 0.008341, 0.008341), byrow = TRUE, nrow = 2)

# Quintile distribution of overall AI rates
qnts.B <- qnts.W <-
	 c(0, 0.000450, 0.005102, 0.009680, 0.032970)

# Proportion in same-race partnerships (main, casl, inst)
prop.hom.mpi.B <- prop.hom.mpi.W <-
  (c(0.9484, 0.9019, 0.9085) +
   c(0.9154, 0.8509, 0.8944))/2

# Mean age diffs (main, casl, inst)
sqrt.adiff.BB <- 
sqrt.adiff.BW <- 
sqrt.adiff.WW <- c(0.520, 0.632, 0.590)

# Mean durations of BB, BW, and WW partnerships
#durs.main <- sum(c(348, 372, 555)*nodemix.m)/sum(nodemix.m)
#durs.pers <- sum(c(131, 286, 144)*nodemix.p)/sum(nodemix.p)
durs.main <- c(348, 372, 555)
durs.pers <- c(131, 286, 144)

# Age-sex-specific mortality rates
ages <- 18:39
asmr.B <- c(rep(0, 17),
            1 - (1 - c(rep(0.00159, 7),
                rep(0.00225, 10),
                rep(0.00348, 5))) ^ (1/(365/time.unit)),
            1)

asmr.W <- c(rep(0, 17),
            1 - (1 - c(rep(0.00103, 7),
                rep(0.00133, 10),
                rep(0.00214, 5))) ^ (1/(365/time.unit)),
            1)

# asmr.B <- asmr.W <- (asmr.B + asmr.W)/2

# I, R, V role frequencies
role.B.prob <- role.W.prob <-
 	c(0.228, 0.228, 0.544)


# Create meanstats
st <- calc_nwstats.mard(
  time.unit = time.unit,
  num.B = num.B,
  num.W = num.W,
  deg.mp.B = deg.mp.B,
  deg.mp.W = deg.mp.W,
  mdeg.inst.B = mdeg.inst.B,
  mdeg.inst.W = mdeg.inst.W,
  qnts.B = qnts.B,
  qnts.W = qnts.W,
  prop.hom.mpi.B = prop.hom.mpi.B,
  prop.hom.mpi.W = prop.hom.mpi.W,
  balance = "mean",
  sqrt.adiff.BB = sqrt.adiff.BB,
  sqrt.adiff.WW = sqrt.adiff.WW,
  sqrt.adiff.BW = sqrt.adiff.BW,
  age.method = "homogeneous",
  dur.method = "heterogeneous",                                   ## Race diff
  diss.main = ~offset(edges) + offset(nodemix("race", base = 1)), ## Race diff
  diss.pers = ~offset(edges) + offset(nodemix("race", base = 1)), ## Race diff
  #dur.method = "homogeneous",                                      ## Race eq
  #diss.main = ~offset(edges),                                      ## Race eq
  #diss.pers = ~offset(edges),                                      ## Race eq
  durs.main = durs.main,
  durs.pers = durs.pers,
  ages = ages,
  asmr.B = asmr.B,
  asmr.W = asmr.W,
  role.B.prob = role.B.prob,
  role.W.prob = role.W.prob)

#save(st, file = "scenarios/rdiffhet/est/nwstats.rda")
#save(st, file = "/net/proj/camp/rdiffhet/est/nwstats.rda")
save(st, file="nwstats.rda")
rm(list = ls())
