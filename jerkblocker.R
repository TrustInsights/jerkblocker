#############################################
# Simple Jerk Blocker by Trust Insights
# https://www.trustinsights.ai
#
# License Terms:
#
# This software is provided under the GNU Public License 3.0 with absolutely no warranty of any kind.
# See https://github.com/TrustInsights/jerkblocker/blob/master/LICENSE for full license details.

## INSTALL LIBRARIES

library(lubridate)
library(janitor)
library(stringi)
library(here)
library(tidyverse)

## SET BASIC VARIABLES

here <- here::here()
setwd(here)

Sys.setenv(TZ = "America/New_York")
today <- Sys.Date()
unixtime <- as.numeric(as.POSIXct(Sys.Date()))

#############################################
# FUNCTIONS
#############################################

quotemeta <- function(string) {
  ## removes all but alphanumerics
  str_replace_all(string, "(\\W)", "\\\\\\1")
}

#############################################
# START CODE HERE
#############################################

# Specify output files
output.file.block <- paste("blocklist-", unixtime, ".csv", sep = "")

## S1 is the first name and common variants

s1 <-
  c("this",
    "this.",
    "this_",
    "this-",
    "t",
    "t.",
    "t_",
    "t-",
    "")

## s2 is common last name variants

s2 <-
  c("guy",
    "guy.",
    "guy-",
    "guy_",
    "guy+")

## s3 is a number sequence
s3 <-
  seq(0, 2020)

## s4 are your common webmail domains

s4  <-
  c(
    "@hotmail.com",
    "@yahoo.com",
    "@gmail.com",
    "@aol.com",
    "@outlook.com",
    "@earthlink.net",
    "@mac.com",
    "@mail.ru"
  )

# permute
addf <-
  expand.grid(s1, s2, s3, s4)

# rename columns
final <-
  transmute(addf, paste0(addf$Var1, addf$Var2, addf$Var3, addf$Var4)) %>%
  rename(email = 1) %>%
  distinct()

# write to disk
write_csv(final, output.file.block)
