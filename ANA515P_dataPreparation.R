# Data Preparation for Mental Health in Tech Survey.
# ANA515P_SP2025
# Harshil Patel

# Install necessary packages if not already installed
if (!require(tidyverse)) install.packages("tidyverse")
if (!require(lubridate)) install.packages("lubridate")
if (!require(ggplot2)) install.packages("ggplot2")
if (!require(readxl)) install.packages("readxl")

# Load libraries
library(tidyverse)
library(lubridate)
library(ggplot2)
library(readxl)

# Set working directory
setwd("C:/Users/harsh/Downloads/ANA515p")

# Load the two sheets from the Excel file
sheet1 <- read_excel("survey.xlsx", sheet = 1)
sheet2 <- read_excel("survey.xlsx", sheet = 2)

# Standardize the Timestamp column in sheet1
sheet1 <- sheet1 %>%
  mutate(Timestamp = tryCatch({
    # Converting from Excel serial date (numeric) to datetime
    as.POSIXct(as.numeric(Timestamp) * 86400, origin = "1899-12-30", tz = "UTC")
  }, warning = function(w) NA_POSIXct_, error = function(e) NA_POSIXct_))

# Not modifying sheet2's Timestamp column (sheet2$Timestamp is already in POSIXct format from read_excel)

# Combine the two sheets using bind_rows after the Timestamps are standardized
mental_health_combined <- bind_rows(sheet1, sheet2)

# Clean the data
# Replace Timestamps before 2014 with NA (assuming survey data starts in 2014)
mental_health_combined <- mental_health_combined %>%
  mutate(Timestamp = if_else(year(Timestamp) < 2014, NA_POSIXct_, Timestamp))

# Clean Age
# Check for unrealistic ages (e.g., negative, 0, extremely large values)
summary(mental_health_combined$Age)
# Decision: Set ages < 15 or > 100 to NA as they are likely errors
mental_health_combined <- mental_health_combined %>%
  mutate(Age = ifelse(Age < 15 | Age > 100 | Age == 0, NA, Age))

# Clean Gender
# Standardize Gender entries
mental_health_combined <- mental_health_combined %>%
  mutate(Gender = case_when(
    str_detect(tolower(Gender), "male|m|cis male|man") ~ "Male",
    str_detect(tolower(Gender), "female|f|woman|cis female") ~ "Female",
    str_detect(tolower(Gender), "trans|non-binary|agender|genderqueer|other|unsure|all|p") ~ "Other",
    TRUE ~ NA_character_
  ))

# Check for missing values
colSums(is.na(mental_health_combined))

# Categorical variables, replace empty strings with NA
mental_health_combined <- mental_health_combined %>%
  mutate(across(where(is.character), ~ ifelse(. == "" | . == " ", NA, .)))

# Numerical variables like Age, leave NAs as is for now (can impute later if needed)
# Standardize 'no_employees'
mental_health_combined <- mental_health_combined %>%
  mutate(no_employees = case_when(
    str_detect(no_employees, "26-100") ~ "26-100",
    str_detect(no_employees, "100-500") ~ "100-500",
    str_detect(no_employees, "500-1000") ~ "500-1000",
    str_detect(no_employees, "More than 1000") ~ "More than 1000",
    TRUE ~ NA_character_
  ))

# Remove unnecessary columns (e.g., comments) for analysis
mental_health_combined <- mental_health_combined %>%
  select(-comments)

# Visualization 1: Histogram of Age
ggplot(mental_health_combined, aes(x = Age)) +
  geom_histogram(binwidth = 5, fill = "lightblue", color = "black") +
  labs(title = "Histogram of Age Distribution", x = "Age", y = "Count") +
  theme_minimal()

# Visualization 2: Boxplot of Age by Gender
ggplot(mental_health_combined, aes(x = Gender, y = Age)) +
  geom_boxplot(fill = "lightgreen") +
  labs(title = "Boxplot of Age by Gender", x = "Gender", y = "Age") +
  theme_minimal()

# Save the cleaned dataset
write.csv(mental_health_combined, "mental_health_data_cleaned.csv", row.names = FALSE)

# Summary of cleaned data
str(mental_health_combined)
summary(mental_health_combined)