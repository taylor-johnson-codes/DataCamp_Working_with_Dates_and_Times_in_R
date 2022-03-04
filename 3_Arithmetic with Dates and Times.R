# difftime(time1, time2) is the same as time1 - time2
# difftime() takes an optional time unit argument to specify the time unit for the difference
# today() returns today's date as date object; now() returns date and time as POSIXct object

library(lubridate)

# The date of landing and moment of step
date_landing <- mdy("July 20, 1969")
moment_step <- mdy_hms("July 20, 1969, 02:56:15", tz = "UTC")

# How many days since the first man on the moon?
difftime(today(), date_landing, units = "days")

# How many seconds since the first man on the moon?
difftime(now(), moment_step, units = "secs")

# Three dates
mar_11 <- ymd_hms("2017-03-11 12:00:00", tz = "America/Los_Angeles")
mar_12 <- ymd_hms("2017-03-12 12:00:00", tz = "America/Los_Angeles")
mar_13 <- ymd_hms("2017-03-13 12:00:00", tz = "America/Los_Angeles")

# Difference between mar_13 and mar_12 in seconds
difftime(mar_13, mar_12, units = "secs")

# Difference between mar_12 and mar_11 in seconds
difftime(mar_12, mar_11, units = "secs")
# At 2am on Mar 12th 2017, Daylight Savings started in the Pacific timezone. 
# That means a whole hour of seconds gets skipped between noon on the 11th and noon on the 12th. 


# time spans in lubridate: period and duration
# period: matches human concept of a time span; e.g. datetime + period of one day = same time on the next date
# duration: fixed length of time in seconds, like how a stopwatch measures time; e.g. datetime + duration of one day = datetime + 86400 seconds
# period functions all end with "s"; for the period of one day: days() results in 1d 0H 0M 0S
# duration functions have a "d" in front of the period function name; for the duration of one day: ddays() e.g. ddays(2) returns "172800s (~2 days)"

# Add a period of one week to mon_2pm
mon_2pm <- dmy_hm("27 Aug 2018 14:00")
mon_2pm + weeks(1)

# Add a duration of 81 hours to tue_9am
tue_9am <- dmy_hm("28 Aug 2018 9:00")
tue_9am + hours(81)

# Subtract a period of five years from today()
today() - years(5)

# Subtract a duration of five years from today()
today() - dyears(5)


# Time of North American Eclipse 2017
eclipse_2017 <- ymd_hms("2017-08-21 18:26:40")

# Duration of 29 days, 12 hours, 44 mins and 3 secs
synodic <- ddays(29) + dhours(12) + dminutes(44) + dseconds(3)

# 223 synodic months
saros <- synodic * 223

# Add saros to eclipse_2017
saros + eclipse_2017


# Generating sequences of datetimes

# Add a period of 8 hours to today
today_8am <- today() + hours(8) 

# Sequence of two weeks from 1 to 26
every_two_weeks <- 1:26 * weeks(2)

# Create datetime for every two weeks for a year
today_8am + every_two_weeks


# There are alternative addition and subtraction operators: %m+% and %m-% that have different behavior.
# Rather than returning an NA for a non-existent date, they roll back to the last existing date. 

# A sequence of 1 to 12 periods of 1 month
month_seq <- 1:12 * months(1)

# NOTE: jan_31 isn't loaded here so the code for it won't work
# Add 1 to 12 months to jan_31
jan_31 + month_seq

# Replace + with %m+%
jan_31 %m+% month_seq

# Replace + with %m-%
jan_31 %m-% month_seq


# You can create an interval by using the operator %--% with two datetimes.
# For example ymd("2001-01-01") %--% ymd("2001-12-31") creates an interval for the year of 2001.
# Once you have an interval you can find out certain properties like its start, end and length with int_start(), int_end() and int_length() respectively.

# NOTE: the dataset isn't loaded here so the code for it won't work (the reigns of kings and queens of Britain)
# Print monarchs
monarchs

# Create an interval for reign
monarchs <- monarchs %>%
  mutate(reign = from %--% to) 

# Find the length of reign, and arrange
monarchs %>%
  mutate(length = int_length(reign)) %>% 
  arrange(desc(length)) %>%
  select(name, length, dominion)


# The operator %within% tests if the datetime (or interval) on the left hand side is within the interval of the right hand side.

# NOTE: the dataset isn't loaded here so the code for it won't work (data set describing appearances of Halley's comet)
# Print halleys
halleys

# New column for interval from start to end date
halleys <- halleys %>% 
  mutate(visible = start_date %--% end_date)

# The visitation of 1066
halleys_1066 <- halleys[14, ] 

# Monarchs in power on perihelion date
monarchs %>% 
  filter(halleys_1066$perihelion_date %within% reign) %>%
  select(name, from, to, dominion)

# Monarchs whose reign overlaps visible time
monarchs %>% 
  filter(int_overlaps(halleys_1066$visible, reign)) %>%
  select(name, from, to, dominion)

# New columns for duration and period
monarchs <- monarchs %>%
  mutate(
    duration = as.duration(reign),
    period = as.period(reign)) 

# Examine results    
monarchs %>%
  select(name, duration, period)