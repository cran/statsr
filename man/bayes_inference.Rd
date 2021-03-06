% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bayes_inference.R
\name{bayes_inference}
\alias{bayes_inference}
\title{Bayesian hypothesis tests and credible intervals}
\usage{
bayes_inference(
  y,
  x = NULL,
  data,
  type = c("ci", "ht"),
  statistic = c("mean", "proportion"),
  method = c("theoretical", "simulation"),
  success = NULL,
  null = NULL,
  cred_level = 0.95,
  alternative = c("twosided", "less", "greater"),
  hypothesis_prior = c(H1 = 0.5, H2 = 0.5),
  prior_family = "JZS",
  n_0 = 1,
  mu_0 = null,
  s_0 = 0,
  v_0 = -1,
  rscale = 1,
  beta_prior = NULL,
  beta_prior1 = NULL,
  beta_prior2 = NULL,
  nsim = 10000,
  verbose = TRUE,
  show_summ = verbose,
  show_res = verbose,
  show_plot = verbose
)
}
\arguments{
\item{y}{Response variable, can be numerical or categorical}

\item{x}{Explanatory variable, categorical (optional)}

\item{data}{Name of data frame that y and x are in}

\item{type}{of inference; "ci" (credible interval) or "ht" (hypothesis test)}

\item{statistic}{population parameter to estimate: mean or proportion}

\item{method}{of inference; "theoretical" (quantile based) or "simulation"}

\item{success}{which level of the categorical variable to call "success", i.e. do inference on}

\item{null}{null value for the hypothesis test}

\item{cred_level}{confidence level, value between 0 and 1}

\item{alternative}{direction of the alternative hypothesis; "less","greater", or "twosided"}

\item{hypothesis_prior}{discrete prior for H1 and H2, default is the uniform prior: c(H1=0.5,H2=0.5)}

\item{prior_family}{character string representing default priors for inference or testing ("JSZ", "JUI","ref"). 
See notes for details.}

\item{n_0}{n_0 is the prior sample size in the Normal prior for the mean}

\item{mu_0}{the prior mean in one sample mean problems or the prior difference 
in two sample problems.  For hypothesis testing, this is all the null value
if null is not supplied.}

\item{s_0}{the prior standard deviation of the data for the conjugate Gamma prior on 1/sigma^2}

\item{v_0}{prior degrees of freedom for conjugate Gamma prior on 1/sigma^2}

\item{rscale}{is the scaling parameter in the Cauchy prior:  1/n_0 ~ Gamma(1/2, rscale^2/2)
leads to mu_0  having a Cauchy(0, rscale^2*sigma^2) prior distribution for prior_family="JZS".}

\item{beta_prior, beta_prior1, beta_prior2}{beta priors for p (or p_1 and p_2) for one or two proportion inference}

\item{nsim}{number of Monte Carlo draws; default is 10,000}

\item{verbose}{whether output should be verbose or not, default is TRUE}

\item{show_summ}{print summary stats, set to verbose by default}

\item{show_res}{print results, set to verbose by default}

\item{show_plot}{print inference plot, set to verbose by default}
}
\value{
Results of inference task performed.
}
\description{
Bayesian hypothesis tests and credible intervals
}
\note{
For inference and testing for normal means several default options are available.
 "JZS"  corresponds to using the Jeffreys reference prior on sigma^2, p(sigma^2) = 1/sigma^2, 
 and the Zellner-Siow Cauchy prior on the standardized effect size mu/sigma or ( mu_1 - mu_2)/sigma
  with a location of mu_0 and scale  rscale.  The "JUI" option also uses the
  Jeffreys reference prior on sigma^2, but the Unit Information prior on the
 standardized effect, N(mu_0, 1).  The option "ref" uses the improper uniform prior  on 
 the standardized effect and the Jeffreys reference prior on  sigma^2.  The latter 
 cannot be used for hypothesis testing due to the ill-determination of Bayes
 factors.  Finally "NG" corresponds to the conjugate Normal-Gamma prior.
}
\examples{

# inference for the mean from a single normal population using
# Jeffreys Reference prior, p(mu, sigma^2) = 1/sigma^2

library(BayesFactor)
data(tapwater)

# Calculate 95\% CI using quantiles from Student t derived from ref prior
bayes_inference(tthm, data=tapwater,
                statistic="mean", 
                type="ci", prior_family="ref",
                method="theoretical")
\donttest{ 
# Calculate 95\% CI using simulation from Student t using an informative mean and ref
# prior for sigma^2

bayes_inference(tthm, data=tapwater,
                statistic="mean", mu_0=9.8,
                type="ci",  prior_family="JUI",
                method="theo")

# Calculate 95\% CI using simulation  with the 
# Cauchy prior on mu and reference prior on sigma^2


bayes_inference(tthm, data=tapwater,
                statistic="mean", mu_0 = 9.8, rscale=sqrt(2)/2,
                type="ci", prior_family="JZS",
                method="simulation")

                
# Bayesian t-test mu = 0 with ZJS prior  
bayes_inference(tthm, data=tapwater,
                statistic="mean",
                type="ht", alternative="twosided", null=80,
                prior_family="JZS",
                method="sim")
                
               
# Bayesian t-test for two means 

data(chickwts)
chickwts = chickwts[chickwts$feed \%in\% c("horsebean","linseed"),]
# Drop unused factor levels
chickwts$feed = factor(chickwts$feed)                
bayes_inference(y=weight, x=feed, data=chickwts,
                statistic="mean", mu_0 = 0, alt="twosided",
                type="ht", prior_family="JZS",
                method="simulation")               
}
}
\references{
\url{https://statswithr.github.io/book/}
}
