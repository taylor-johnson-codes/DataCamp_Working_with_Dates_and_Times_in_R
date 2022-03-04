# ISO 8601 date format: YYYY-MM-DD (ordered from largest to smallest unit of time)
# R sees 2003-02-27 as subtracting integers
# R sees "2003-02-27" as a string
# need to put it in as.Date("2003-02-27") for R to recognize it as a date object

# The date R 3.0.0 was released
x <- "2013-04-03"

# Examine structure of x
str(x)

# Use as.Date() to interpret x as a date
x_date <- as.Date(x)

# Examine structure of x_date
str(x_date)

# Store April 10 2014 as a Date
april_10_2014 <- as.Date("2014-04-10")

# read_csv() in the readr package will recognize dates in a few common formats
# the anytime() function in the anytime package sole goal is to automatically parse strings as dates regardless of the format

# Load the readr package
library(readr)

# NOTE: the dataset isn't loaded here so the code for it won't work
# Use read_csv() to import rversions.csv
releases <- read_csv("rversions.csv")

# Examine the structure of the date column
str(releases$date)

# Load the anytime package
library(anytime)

# Various ways of writing Sep 10 2009
sep_10_2009 <- c("September 10 2009", "2009-09-10", "10 Sep 2009", "09-10-2009")

# Use anytime() to parse sep_10_2009
anytime(sep_10_2009)


library(ggplot2)

# Set the x axis to the date column
ggplot(releases, aes(x = date, y = type)) +
  geom_line(aes(group = 1, color = factor(major)))

# Limit the axis to between 2010-01-01 and 2014-01-01
ggplot(releases, aes(x = date, y = type)) +
  geom_line(aes(group = 1, color = factor(major))) +
  xlim(as.Date("2010-01-01"), as.Date("2014-01-01"))

# Specify breaks every ten years and labels with "%Y"
ggplot(releases, aes(x = date, y = type)) +
  geom_line(aes(group = 1, color = factor(major))) +
  scale_x_date(date_breaks = "10 years", date_labels = "%Y")


# behind the scenes, date objects are stored as days since 1970-01-01
# Sys.date() simply returns today's date

# Find the largest date
last_release_date <- max(releases$date)

# Filter row for last release
last_release <- filter(releases, date == last_release_date)

# Print last_release
last_release

# How long since last release?
Sys.Date() - last_release_date


# ISO 8601 time format: HH:MM:SS (ordered from largest to smallest unit of time)
# two built-in datetime objects in R:
# POSIXlt - list with named components
# POSIXct - seconds since 1970-01-01 00:00:00 (more common in data frames)
# as.POSIXct() expects strings to be in the format YYYY-MM-DD HH:MM:SS
# The only tricky thing is that times will be interpreted in local time based on your machine's set up
# You can check your timezone with Sys.timezone()
# If you want the time to be interpreted in a different timezone, you just set the tz argument of as.POSIXct()

# Use as.POSIXct to enter the datetime 
as.POSIXct("2010-10-01 12:12:00")

# Use as.POSIXct again but set the timezone to `"America/Los_Angeles"`
as.POSIXct("2010-10-01 12:12:00", tz = "America/Los_Angeles")

# Use read_csv to import rversions.csv
releases <- read_csv("rversions.csv")

# Examine structure of datetime column
str(releases$datetime)

# Import "cran-logs_2015-04-17.csv" with read_csv()
logs <- read_csv("cran-logs_2015-04-17.csv")

# Print logs
logs

# Store the release time as a POSIXct object
release_time <- as.POSIXct("2015-04-16 07:13:33", tz = "UTC")

# When is the first download of 3.2.0?
logs %>% 
  filter(datetime > release_time, r_version == "3.2.0")

# Examine histograms of downloads by version
ggplot(logs, aes(x = datetime)) +
  geom_histogram() +
  geom_vline(aes(xintercept = as.numeric(release_time)))+
  facet_wrap(~ r_version, ncol = 1)