# time zones
# Sys.timezone() displays timezone your computer is set to
# OlsonNames() lists the timezones R knows 
# force_tz() changes the timezone without changing the clock time
# with_tz() to view the same instant in a different time zone

library(lubridate)

# Game2: CAN vs NZL in Edmonton
game2 <- mdy_hm("June 11 2015 19:00")

# Game3: CHN vs NZL in Winnipeg
game3 <- mdy_hm("June 15 2015 18:30")

# Set the timezone to "America/Edmonton"
game2_local <- force_tz(game2, tzone = "America/Edmonton")
game2_local

# Set the timezone to "America/Winnipeg"
game3_local <- force_tz(game3, tzone = "America/Winnipeg")
game3_local

# How long does the team have to rest?
as.period(game2_local %--% game3_local)

# What time is game2_local in NZ?
with_tz(game2_local, tzone = "Pacific/Auckland")

# What time is game2_local in Corvallis, Oregon?
with_tz(game2_local, tzone = "America/Los_Angeles")

# What time is game3_local in NZ?
with_tz(game3_local, tzone = "Pacific/Auckland")


# NOTE: the dataset isn't loaded here so the code for it won't work
# Examine datetime and date_utc
head(akl_hourly$datetime)
head(akl_hourly$date_utc)

# Force datetime to Pacific/Auckland
akl_hourly <- akl_hourly %>%
  mutate(
    datetime = force_tz(datetime, tzone = "Pacific/Auckland"))

# Reexamine datetime
head(akl_hourly$datetime)

# Are datetime and date_utc the same moments
table(akl_hourly$datetime - akl_hourly$date_utc)


# times without dates

# NOTE: the dataset isn't loaded here so the code for it won't work
# Import auckland hourly data 
akl_hourly <- read_csv("akl_weather_hourly_2016.csv")

# Examine structure of time column
str(akl_hourly$time)

# Examine head of time column
head(akl_hourly$time)

# A plot using just time
library(ggplot2)
ggplot(akl_hourly, aes(x = time, y = temperature)) +
  geom_line(aes(group = make_date(year, month, mday)), alpha = 0.2)


# importing datetimes
# parse_date_time() can be slow; if dates are in a consistent format, these options are faster:
# fastPOSIXct() reads in times in YYYY-MM-DD HH:MM:SS TZ format - fasttime package
# fast_strptime(x, format = "%Y-%m-%d) match the format to the format your data is in - lubridate package

# exporting datetimes in human-readable format
# write_csv("your_file.csv") will write datetimes out in ISO 8601 format
# stamp() pass in an example of date formatting you want; e.g. stamp("Tue Oct 10 2017) - lubridate package

library(microbenchmark)  # To compare run times you'll use the microbenchmark() 
library(fasttime)

# NOTE: the dataset isn't loaded here so the code for it won't work
# Examine structure of dates
str(dates)

# Use fastPOSIXct() to parse dates
fastPOSIXct(dates) %>% str()

# Compare speed of fastPOSIXct() to ymd_hms()
microbenchmark(
  ymd_hms = ymd_hms(dates),
  fasttime = fastPOSIXct(dates),
  times = 20)

# Head of dates
head(dates)

# Parse dates with fast_strptime
fast_strptime(dates, format = "%Y-%m-%dT%H:%M:%SZ") %>% str()

# Comparse speed to ymd_hms() and fasttime
microbenchmark(
  ymd_hms = ymd_hms(dates),
  fasttime = fastPOSIXct(dates),
  fast_strptime = fast_strptime(dates, format = "%Y-%m-%dT%H:%M:%SZ"),
  times = 20)

# Create a stamp based on "Saturday, Jan 1, 2000"
date_stamp <- stamp("Saturday, Jan 1, 2000")

# Print date_stamp
date_stamp

# Call date_stamp on today()
date_stamp(today())

# Create and call a stamp based on "12/31/1999"
stamp("12/31/1999")(today())

# Use string finished for stamp()
stamp(finished)(today())  # finished isn't loaded here