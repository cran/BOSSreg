% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cv.boss.R
\name{cv.boss}
\alias{cv.boss}
\title{Cross-validation for Best Orthogonalized Subset Selection (BOSS) and Forward Stepwise Selection (FS).}
\usage{
cv.boss(
  x,
  y,
  maxstep = min(nrow(x) - intercept - 1, ncol(x)),
  intercept = TRUE,
  n.folds = 10,
  n.rep = 1,
  show.warning = TRUE,
  ...
)
}
\arguments{
\item{x}{A matrix of predictors, see \code{boss}.}

\item{y}{A vector of response variable, see \code{boss}.}

\item{maxstep}{Maximum number of steps performed. Default is \code{min(n-1,p)} if \code{intercept=FALSE},
and it is \code{min(n-2, p)} otherwise.}

\item{intercept}{Logical, whether to fit an intercept term. Default is TRUE.}

\item{n.folds}{The number of cross validation folds. Default is 10.}

\item{n.rep}{The number of replications of cross validation. Default is 1.}

\item{show.warning}{Whether to display a warning if CV is only performed for a subset of candidates.
e.g. when n<p and 10-fold. Default is TRUE.}

\item{...}{Arguments to \code{boss}, such as \code{hdf.ic.boss}.}
}
\value{
\itemize{
  \item boss: An object \code{boss} that fits on the full dataset.
  \item n.folds: The number of cross validation folds.
  \item cvm.fs: Mean OOS deviance for each candidate given by FS.
  \item cvm.boss: Mean OSS deviance for each candidate given by BOSS.
  \item i.min.fs: The index of minimum cvm.fs.
  \item i.min.boss: The index of minimum cvm.boss.
}
}
\description{
Cross-validation for Best Orthogonalized Subset Selection (BOSS) and Forward Stepwise Selection (FS).
}
\details{
This function fits BOSS and FS (\code{boss}) on the full dataset, and performs \code{n.folds}
  cross-validation. The cross-validation process can be repeated \code{n.rep} times to evaluate the
  out-of-sample (OOS) performance for the candidate subsets given by both methods.
}
\examples{
## Generate a trivial dataset, X has mean 0 and norm 1, y has mean 0
set.seed(11)
n = 20
p = 5
x = matrix(rnorm(n*p), nrow=n, ncol=p)
x = scale(x, center = colMeans(x))
x = scale(x, scale = sqrt(colSums(x^2)))
beta = c(1, 1, 0, 0, 0)
y = x\%*\%beta + scale(rnorm(20, sd=0.01), center = TRUE, scale = FALSE)

## Perform 10-fold CV without replication
boss_cv_result = cv.boss(x, y)
## Get the coefficient vector of BOSS that gives minimum CV OSS score (S3 method for cv.boss)
beta_boss_cv = coef(boss_cv_result)
# the above is equivalent to
boss_result = boss_cv_result$boss
beta_boss_cv = boss_result$beta_boss[, boss_cv_result$i.min.boss, drop=FALSE]
## Get the fitted values of BOSS-CV (S3 method for cv.boss)
mu_boss_cv = predict(boss_cv_result, newx=x)
# the above is equivalent to
mu_boss_cv = cbind(1,x) \%*\% beta_boss_cv

## Get the coefficient vector of FS that gives minimum CV OSS score (S3 method for cv.boss)
beta_fs_cv = coef(boss_cv_result, method='fs')
## Get the fitted values of FS-CV (S3 method for cv.boss)
mu_fs_cv = predict(boss_cv_result, newx=x, method='fs')
}
\references{
\itemize{
  \item Tian, S., Hurvich, C. and Simonoff, J. (2021), On the Use of Information Criteria
  for Subset Selection in Least Squares Regression. https://arxiv.org/abs/1911.10191
  \item BOSSreg Vignette https://github.com/sentian/BOSSreg/blob/master/r-package/vignettes/BOSSreg.pdf
}
}
\seealso{
\code{predict} and \code{coef} methods for \code{cv.boss} object, and the \code{boss} function
}
\author{
Sen Tian
}
