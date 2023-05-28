
## load packages

library(blavaan, quietly=TRUE)
library(lavaan, quietly=TRUE)
library(brms, quietly=TRUE)
library(bayesplot, quietly=TRUE)
library(semPlot, quietly=TRUE)


## Convergence and efficiency

model <- '
  # latent variable definitions
     ind60 =~ x1 + x2 + x3
     dem60 =~ y1 + y2 + y3 + y4
     dem65 =~ y5 + y6 + y7 + y8

  # regressions
    dem60 ~ ind60
    dem65 ~ ind60 + dem60

  # residual correlations
    y1 ~~ y5
    y2 ~~ y4 + y6
    y3 ~~ y7
    y4 ~~ y8
    y6 ~~ y8
'

ff2 <- bsem(model, data=PoliticalDemocracy, std.lv=T)

plot(ff2, pars = 12:14)

max(blavInspect(ff2, "psrf"))

min(blavInspect(ff2, "neff"))



## prior predictive checks


priors <- dpriors(nu="normal(3,2)",
                  lambda="normal(0.4, 2)",
                  beta="normal(0.4, 2)",
                  theta="gamma(1,1)[sd]")

model <- '
  # latent variable definitions
     ind60 =~ x1 + x2 + x3
     dem60 =~ a*y1 + b*y2 + c*y3 + d*y4
     dem65 =~ a*y5 + b*y6 + c*y7 + d*y8

  # regressions
    dem60 ~ ind60
    dem65 ~ ind60 + dem60

  # residual correlations
    y1 ~~ y5
    y2 ~~ y4 + y6
    y3 ~~ y7
    y4 ~~ y8
    y6 ~~ y8
'

fit_wi <- bsem(model, data=PoliticalDemocracy, std.lv=T,
               meanstructure=T, test = "none",
               dp=priors, prisamp = T)

## factor loadings
plot(fit_wi, pars=1:11, plot.type = "dens")
## factor regressions
plot(fit_wi, pars=12:14, plot.type = "dens")
## residual variances
plot(fit_wi, pars=15:31, plot.type = "dens")
## item intercepts
plot(fit_wi, pars=32:42, plot.type = "dens")



dpriors()

fit_df <- bsem(model, data=PoliticalDemocracy, std.lv=T,
               meanstructure=T, test = "none",
               prisamp = T)

## factor loadings
plot(fit_df, pars=1:11, plot.type = "dens")
## factor regressions
plot(fit_df, pars=12:14, plot.type = "dens")
## residual variances
plot(fit_df, pars=15:31, plot.type = "dens")
## item intercepts
plot(fit_df, pars=32:42, plot.type = "dens")




mod1 <- '
  # latent variable definitions
     ind60 =~ x1 + x2 + x3
     dem60 =~ y1 + y2 + y3 + y4
     dem65 =~ y5 + y6 + y7 + y8'
f1 <- cfa(mod1, data=PoliticalDemocracy, std.lv=T)

semPaths(f1, what="path",
         style="lisrel",
         layout = "tree2",
         edge.color = "black",esize=1)


mod2 <- '
  # latent variable definitions
     ind60 =~ x1 + x2 + x3
     dem60 =~ y1 + y2 + y3 + y4 + y5
     dem65 =~ y5 + y6 + y7 + y8 + y4

  # residual correlations
    y1 ~~ y5
    x1 ~~ y2

'
f2 <- cfa(mod2, data=PoliticalDemocracy, std.lv=T)

semPaths(f2, what="path",
         style="lisrel",
         layout = "tree2",
         edge.color = "black",esize=1)


## Basic measurement model (default priors)

mod1 <- '
  # latent variable definitions
     ind60 =~ x1 + x2 + x3
     dem60 =~ y1 + y2 + y3 + y4
     dem65 =~ y5 + y6 + y7 + y8'

f1 <- bcfa(mod1, data=PoliticalDemocracy, 
           meanstructure=T, std.lv=T,
           burnin=1000, sample=1000, n.chains=3)


max(blavInspect(f1, "psrf"))

min(blavInspect(f1, "neff"))

summary(f1, rsquare=T)

## Basic measurement model (weakly informative priors)

priors <- dpriors(nu="normal(3,2)",
                  lambda="normal(1, 3)",
                  theta="gamma(1,1)[sd]")

mod1 <- '
  # latent variable definitions
     ind60 =~ x1 + x2 + x3
     dem60 =~ y1 + y2 + y3 + y4
     dem65 =~ y5 + y6 + y7 + y8'

f2 <- bcfa(mod1, data=PoliticalDemocracy, 
           meanstructure=T, std.lv=T, dp=priors,
           burnin=1000, sample=1000, n.chains=3)


max(blavInspect(f2, "psrf"))

min(blavInspect(f2, "neff"))

summary(f2, rsquare=T)


## Cross time residuals

mod3 <- '
  # latent variable definitions
     ind60 =~ x1 + x2 + x3
     dem60 =~ y1 + y2 + y3 + y4
     dem65 =~ y5 + y6 + y7 + y8

  # residual correlations
    y1 ~~ y5
    y2 ~~ y6
    y3 ~~ y7
    y4 ~~ y8
'

f3 <- bcfa(mod3, data=PoliticalDemocracy, 
           meanstructure=T, std.lv=T, dp=priors,
           burnin=1000, sample=1000, n.chains=3)

max(blavInspect(f3, "psrf"))

min(blavInspect(f3, "neff"))

summary(f3, standardized=T, rsquare=T)


## Cross time factor loadings

mod4 <- '
  # latent variable definitions
     ind60 =~ x1 + x2 + x3
     dem60 =~ a*y1 + b*y2 + c*y3 + d*y4
     dem65 =~ a*y5 + b*y6 + c*y7 + d*y8

  # residual correlations
    y1 ~~ y5
    y2 ~~ y6
    y3 ~~ y7
    y4 ~~ y8
'

f4 <- bcfa(mod4, data=PoliticalDemocracy, 
           meanstructure=T, std.lv=T, dp=priors,
           burnin=1000, sample=1000, n.chains=3)

max(blavInspect(f4, "psrf"))

min(blavInspect(f4, "neff"))

summary(f4, standardized=T, rsquare=T)



## Model fit

HS.model_null <- '
x1 ~~ x1 
x2 ~~ x2 
x3 ~~ x3
y1 ~~ y1
y2 ~~ y2
y3 ~~ y3
y4 ~~ y4
y5 ~~ y5
y6 ~~ y6
y7 ~~ y7
y8 ~~ y8'

fit_null <- bcfa(HS.model_null, 
                 data=PoliticalDemocracy,
                 meanstructure=T)

max(blavInspect(fit_null, "psrf"))

min(blavInspect(fit_null, "neff"))


## Bayesian fit indices

## Basic measurement model (no loadings constraints or residual correlations)

fits_all <- blavFitIndices(f1, baseline.model = fit_null)
summary(fits_all, central.tendency = c("mean","median"), prob = .90)


dist_fits <- data.frame(fits_all@indices)
mcmc_pairs(dist_fits, pars = c("BRMSEA","BGammaHat","BCFI"),
           diag_fun = "hist")

## Model with cross time parameters

fits_all4 <- blavFitIndices(f4, baseline.model = fit_null)
summary(fits_all4, central.tendency = c("mean","median"), prob = .90)

dist_fits4 <- data.frame(fits_all4@indices)
mcmc_pairs(dist_fits4, pars = c("BRMSEA","BGammaHat","BCFI"),
           diag_fun = "hist")

## Model comparison 

## Default priors vs weakly informative priors
bc12 <- blavCompare(f1, f2)
abs(bc12$diff_loo[1] / bc12$diff_loo[2])

## Should we keep the residual correlations?

bc23 <- blavCompare(f2, f3)
abs(bc23$diff_loo[1] / bc23$diff_loo[2])

## Should we keep the equality constraints in factor loadings?

bc34 <- blavCompare(f3, f4)
abs(bc34$diff_loo[1] / bc34$diff_loo[2])



## Should we keep the factor correlations?

mod5 <- '
  # latent variable definitions
     ind60 =~ x1 + x2 + x3
     dem60 =~ a*y1 + b*y2 + c*y3 + d*y4
     dem65 =~ a*y5 + b*y6 + c*y7 + d*y8
     
     ind60 ~~ 0*dem60 + 0*dem65
     dem60 ~~ 0*dem65

  # residual correlations
    y1 ~~ y5
    y2 ~~ y6
    y3 ~~ y7
    y4 ~~ y8
'

f5 <- bcfa(mod5, data=PoliticalDemocracy, 
           meanstructure=T, std.lv=T, dp=priors,
           burnin=1000, sample=1000, n.chains=3)

bc45 <- blavCompare(f4, f5)
abs(bc45$diff_loo[1] / bc45$diff_loo[2])

## Latent Regressions

priors <- dpriors(nu="normal(3,2)",
                  lambda="normal(1, 3)",
                  beta="normal(0.4, 2)",
                  theta="gamma(1,1)[sd]")

mod6 <- '
  # latent variable definitions
     ind60 =~ x1 + x2 + x3
     dem60 =~ a*y1 + b*y2 + c*y3 + d*y4
     dem65 =~ a*y5 + b*y6 + c*y7 + d*y8

  # regressions
    dem60 ~ ind60
    dem65 ~ ind60 + dem60

  # residual correlations
    y1 ~~ y5
    y2 ~~ y6
    y3 ~~ y7
    y4 ~~ y8
'

f6 <- bsem(mod6, data=PoliticalDemocracy, 
           meanstructure=T, std.lv=T, dp=priors,
           burnin=1000, sample=1000, n.chains=3)

max(blavInspect(f6, "psrf"))
min(blavInspect(f6,"neff"))

summary(f6, standardize=T, rsquare=T)

## Constrain regressions with priors

mod7 <- '
  # latent variable definitions
     ind60 =~ x1 + x2 + x3
     dem60 =~ a*y1 + b*y2 + c*y3 + d*y4
     dem65 =~ a*y5 + b*y6 + c*y7 + d*y8

  # regressions
    dem60 ~ ind60
    dem65 ~ prior("normal(0,.08)")*ind60 + dem60

  # residual correlations
    y1 ~~ y5
    y2 ~~ y6
    y3 ~~ y7
    y4 ~~ y8
'

f7 <- bsem(mod7, data=PoliticalDemocracy, 
           meanstructure=T, std.lv=T, dp=priors,
           burnin=1000, sample=1000, n.chains=3)

summary(f7, standardize=T, rsquare=T)


bc67 <- blavCompare(f6, f7)
abs(bc67$diff_loo[1] / bc67$diff_loo[2])



## Probability of direction 

mc_out <- as.matrix(blavInspect(f6, "mcmc"))
dim(mc_out)
colnames(mc_out)


pt <- partable(f6)[,c("lhs","op","rhs","pxnames")]
pt

pt[pt$op=="~",]


hypothesis(mc_out, "bet_sign[2] > 0", alpha = 0.05)

hypothesis(mc_out, "bet_sign[1] > 0", alpha = 0.05)

hypothesis(mc_out, "bet_sign[1] - bet_sign[2] > 0", alpha = 0.05)

hypothesis(mc_out, "bet_sign[2] > .1", alpha = 0.05)