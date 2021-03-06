% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/authenticate.R
\name{authenticate}
\alias{authenticate}
\title{authenticate}
\usage{
authenticate(req, res, is_authed_fun, ...)
}
\arguments{
\item{req}{plumber request object}

\item{res}{plumber response object}

\item{is_authed_fun}{function. Function to check whether API call is authenticated / authorized.
Use any of sealr's is_authed_* functions or your own custom function. See Details for requirements for custom functions.}

\item{...}{arguments to be passed down to the is_authed_fun function.}
}
\value{
either TRUE (invisibly from plumber::forward()) or a list containing
HTTP status, HTTP status code, and a message (see details).
}
\description{
\code{authenticate} takes one of the \code{is_authed_*} functions of sealr (or a custom function) as input.
If the request is authenticated / authorized, \code{authenticate} will forward the request to the next handler.
If the request is not authenticated / authorized, a 401 response will be returned to the caller.
Hence, \code{authenticate} should only be used in plumber filters as it calls \code{plumber::forward}.
}
\details{
Custom is_authed_fun functions should return a list with the following elements:
\itemize{
  \item is_authed: TRUE or FALSE. Result of the check of is_authed_fun.
  \item status: character. short description of HTTP status code
  \item code: integer. HTTP status code
  \item message: character. Longer description.
}

You can use the helper functions \code{\link{is_authed_return_list}} and \code{\link{is_authed_return_list_401}}
to generate those lists in your custom function.
}
\examples{
\dontrun{
 pr$filter("sealr-jwt-filter", function(req, res){
   sealr::authenticate(req = req, res = res, sealr::is_authed_jwt, secret = "averylongsupersecretsecret")
 })
}
\dontrun{
 # define your own function somewhere
 is_authed_custom <- function(req, res, a, b){
  # some logic with request parameters (in req) and function parameters (a, b)
  if(TRUE){ # implement this
    # is authed
    return(sealr::is_authed_return_list(TRUE))
  } else {
    # not authed :(
    return(sealr::is_authed_return_list_401())
  }
 }

 pr$filter("sealr-custom-filter", function(req, res){
  sealr::authenticate(req = req, res = res, sealr::is_authed_custom, a = 5, b = 4)
 })
}
}
\seealso{
\url{https://www.rplumber.io/docs/routing-and-input.html}
}
