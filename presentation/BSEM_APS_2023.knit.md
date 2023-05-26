---
title: "BSEM with blavaan"
author: "Mauricio Garnier-Villarreal"
institute: "Vrije Universiteit Amsterdam"
date: "May 26 2023"
format:
  revealjs: 
    theme: sky
    logo: VU_social_avatar_blauw.png
execute: 
  cache: true    
bibliography:
  - refs.bib  
---

::: {.cell hash='BSEM_APS_2023_cache/revealjs/unnamed-chunk-1_32c53a6ad5921f58ade6dddde63aeab4'}

:::


## Topics


- Introduction to Bayesian probability
- Evaluation of MCMC convergence and efficiency
- Priors: selection and relevance
- Prior predictive simulation
- BCFA: basic measurement model
- Model fit evaluation
- BSEM: basic latent regression
- Probability of direction
- What to report


# Introduction to Bayesian probability {.smaller}

## Bayesian Data Analysis

- Probability to describe uncertainty.
- Extends discrete logic (true/false) to continuous plausibility.
- Computationally difficult (MCMC). Wasn't practical to use.
- Based on Pierre-Simon Laplace and Thomas Bayes. Older than frequentist.
- Used to be controversial (still?? maybe depends of the field??) .

## Bayesian Data Analysis

- Frequentist view.
  - Probability is just limiting frequency.
  - Uncertainty arises from sampling variation.

- Bayesian view (more general).
  - Probability is part of the models.
  - Uncertainty is due to how much we don't know: How much the model doesn't know.
  
## Logic example

- WLWWWLWLW

![World](world.png)


## Design the model

- What generates the data?
- For WLWWWLWLW.

  - Some true proportion of water p
  - Toss globe, probability $p$ of observing $W$, $1-p$ of
  - Independent tosses.
 
- Probability statement.   

![World](world.png)

## Condition on the data

- Condition the model on the data.
- Update the prior with the data $\rightarrow$ posterior.
- The information is updated at each step, model is informed by the model characteristics and data.

## Starting flat 

![Flat](fig1.png)

## Update

- Observe = W

![Update](fig2.png)

## WLWWWLWLW
    
![Update](fig3.png)


## Condition on data

- Tosses are independent: order of data is irrelevant.
- Every posterior is a prior for next observation.
- Every prior is a posterior of some other inference.

## Evaluate the model

- Bayesian inference: logical answer to a question.
- Answers are in form of distributions.
- You guide the model.
  - Was there a problem.
  - Makes sense.
  - Sensitivity.

## Bayesian Model

- Assume:
  - Likelihood. 
  - Parameters.
  - Priors.
- Produce: Posterior.

## Likelihood

- $Pr(data|assumptions)$
  - Probability of observations conditional on assumptions/model.
  - Mathematical form of how the data happens.
- In frequentist: $Pr(data|Ho)$
  - Probability of the data if the null hypothesis is true.
- In the globe example: binomial probability:
  - Probability of getting a 1 in a toss: coin, globe, etc.    

## Parameters

- Parameters that define the probability function of the likelihood.
- What parameters define the distribution that you specify for the data.
- Depends of the likelihood function:
  - Normal: mean, sd.
  - Binomial: $p$

## Prior


- Original believe/knowledge/information for the parameters.
- Define as distribution.
- You always know “something”.
  - Globe example: uniform
  
![prior](prior.png)

## Prior

- $P(\theta)$ is the prior distribution represents some prior belief or information (without seeing data) about the distribution of $\theta$ .
- By specifying a density function we expect $\theta$ to follow, we can then estimate the form of the posterior for parameters.

## Posterior and Bayes Rule/Theorem {.smaller}

- Bayesian estimate is a posterior distribution over parameters $Pr(parameters|data)$.
- We can solve for the posterior distribution $Pr(\theta|y)$, represents the probability for our parameter($s$) of interest ($\theta$), given data ($y$)
  
   
$$ 
p(\theta|y) = \frac{p(\theta,y)}{p(y)} = \frac{p(y|\theta)p(\theta)}{p(y)}
$$
    
$$
p(\theta|y) \propto p(y|\theta)p(\theta)
$$
    
## Posterior

- We describe the distribution: point estimate, sd, intervals, etc.
- Posterior quantifies the uncertainty about $\theta$, conditional on data.
- You decide how you describe it, what is meaningful for your research question.


## p-value
  

- $Pr(y|\theta) = P(y > Y|H_{0})$.
- Probability of the data coming from a population where the Null Hypothesis is TRUE.
- Probability of observing data ($y$) past a threshold ($Y$), given a null hypothesis is true.
- Major problems: 1) people misinterpret this ALL the time, 2) it is not the inference you really want.


## The tyranny of the $p$-value

- People frequently confuse $Pr(y > Y|H_{0})$ with $Pr(H0|y > Y)$. If the probability of the data, given the null is true, is small, the probability that the null is true, given the data, must be small, too, right?!RIGHT?! Sadly NO.
- With the Bayes rule, we know they are only equal if the marginal probability of H0 being true is equal to the marginal probability of data being greater than or equal to the threshold.
  - There is no reason to think that is the case.

## Frequentists vs. Bayesians

- Frequentist
   “What is the likelihood of observing these data, given the parameter(s) of the model?”
Maximum likelihood methods basically work by iteratively finding values for q that maximize this function.

- Bayesian 
   “What is the distribution of the parameters, given the data?”
A Bayesian is interested in how the parameters can be inferred from the data, not how the data would have been inferred from the parameters.
   
## The “P” you really want to know

- We will not be rejecting any null hypotheses in here. We will make direct probabilistic inferences about the values of our parameters of interest. A Bayesian can always express the probability that (for example) a mean difference is greater than zero, if desired. But what’s almost certainly more interesting is the inference about how large the mean difference between the groups really is!


# Convergence and Efficiency Evaluation

## Terms
- Iterations: number to times we want the MCMC algorithm to run (estimate)
  - Burnin: number of iteration to use to calibrate the model find a stable solution
  - Sample: number of iterations to save after burnin, to build the posterior distributions
- Chains: number of times we estimate models N-iterations, with different starting values
- Thin: number of sample iterations to skip over (only recommended to save memory space)

## Convergence {.smaller}

- When Bayesian models estimated with Markov-Chain Monte Carlo (MCMC) sampler, the models dont stop when it has achieve some convergence criteria, it will run as long as you set it to, and then you need to evaluate the convergence and efficiency of the estimated posterior distributions. And only analyze the results if they are stable enough. 
- $\hat{R}$ is the convergence diagnostic, which compares the between- and within-chain estimates for model parameters and other univariate quantities of interest [@new_rhat]. 
- If chains have not mixed well (ie, the between- and within-chain estimates don't agree), $\hat{R}$ is larger than 1. We recommend running at least three chains by default and only using the sample if $\hat{R} < 1.05$ for all the parameters. 

## Convergence

- If all $\hat{R} < 1.05$ then we can establish that the MCMC chains have converged to a stable solution. If the model has not converged, you should increase the number of ```burnin``` iterations
- and/or change the model priors. As the model might have failed to converge due to needing more iterations or a model misspecification (such as bad priors)

## Convergence




::: {.cell hash='BSEM_APS_2023_cache/revealjs/unnamed-chunk-3_31fa71f1dee35c18681b207e952c02b4'}
::: {.cell-output-display}
![](BSEM_APS_2023_files/figure-revealjs/unnamed-chunk-3-1.png){width=960}
:::
:::


## Efficiency {.smaller}

- Effective sample size (ESS) measures sampling efficiency in the distribution (related e.g. to efficiency of mean and median estimates), and is well defined even if the chains do not have finite mean or variance [@new_rhat].
- ESS can be interpreted as the number of posterior draws that are completely independent of each other, with auto-correlations of 0
- ESS should be at least 100 (approximately) per Markov Chain in order to be reliable and indicate that estimates of respective posterior quantiles are reliable, e.g.: $ESS > 300$ with 3 chains for every parameter

# Priors: selection and relevance

## Priors

- $p(\theta)$ is the “prior distribution”
- Represents your knowledge and level of uncertainty
- Represented as probability distributions
- The inclusion of priors is a strength not a weakness.
- Bayesian inference can implement cumulative scientific progress with the inclusion of previous knowledge into the specification of the prior uncertainty

## Sample size
- Frequentist statistics are asymptotically correct
- Bayesian is estimate in function the know data
- Small samples have a better representation with Bayesian statistics.
- It does not mean is perfect, you are still limited by
your data

## Prior: advantages
- Include prior knowledge
- Account for uncertainty
- Allow us to set clear boundaries, meaningful for the theory
- Theory driven
- Heps stabilize models with smaller sample sizes

## Prior: disadvantages
- More decisions to make
- Can bias the results if they are strong in the wrong place
- Bad priors can make the model take longer to converge
- More effect with smaller sample sizes

## Priors

- Non informative (diffuse)
- Weakly informative
- Strongly informative

- The different types relate to the amount of
uncertainty
- The recommended standard one is weakly
informative
- Apologetic Bayesian prefer non informative

## Non informative Priors

- Intend to have large variances, implying large uncertainty
- Telling the model that you have no notion of where the parameters are located
- Try to be as similar as possible to ML, since in ML every parameter value is possible
- Even if the parameters are equal to ML, the inference is never the same
- $p(\theta) \sim N(0, 100000)$
- $p(\theta) \sim U(-10000, 10000)$

## Non informative Priors

- Even as they are called "non informative"
- It is believed that if the prior tells the model that many values are possible, then it is not providing information
- Actually, it is providing a lot of information, bad information, telling the model that outlier values are possible
- Better to called them "diffuse" for the lack of clarity and quality of the information

## Weakly informative Priors

- Represents a reasonable level of uncertainty
- It does not intend to drive the parameters/posterior
- Intends to set a reasonable parameter space (boundaries)
- Theory/data driven
- $p(\theta) \sim N(0, 10)$
- $p(\theta) \sim U(0, 100)$

## Strongly informative Priors

- Represents a low level of uncertainty
- Usually use to present specific hypothesis
- Not recommended for general use in parameters
- $p(\theta) \sim N(0, .05)$
- $p(\theta) \sim U(0, 1)$

## Resources


## References