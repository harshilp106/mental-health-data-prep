# Mental Health Data Preparation Project
 
 ## Project Overview
 This project focuses on cleaning and preparing mental health survey data from two Excel sheets for further analysis. The dataset includes variables such as `Timestamp`, `Age`, `Gender`, and `no_employees`. The process involves standardizing timestamps, cleaning age values, categorizing gender, handling missing data, standardizing employee counts, and merging the sheets into a single dataset. Two visualizations are generated to explore the cleaned data: a histogram of ages and a boxplot of age by gender.
 
 ## Dataset Description
 The dataset comprises mental health survey responses collected in two Excel sheets:
 - **Sheet1**: Contains timestamps in Excel serial date format (e.g., numbers representing days since December 30, 1899).
 - **Sheet2**: Contains timestamps in a standard datetime format (POSIXct-compatible).
 
 Both sheets include columns like `Age`, `Gender`, `Country`, and `no_employees`, among others, though the exact column sets may differ slightly.
 
 ## Data Preparation Steps
 
 ### Timestamp Standardization
 - **Sheet1**: Timestamps were converted from Excel serial dates to POSIXct format using `as.POSIXct()` with the origin set to `"1899-12-30"`. This addressed warnings during loading (e.g., "Expecting numeric in A2 / R2C1: got a date") by correctly interpreting the serial dates.
 - **Invalid Timestamps**: Any timestamps before the year 2014 were set to `NA`, assuming the survey data collection began in 2014.
 
 ### Age Cleaning
 - Unrealistic age values were set to `NA`. This includes:
   - Ages less than 15 or greater than 100, as these are outside a plausible range for survey respondents.
   - Ages equal to 0, likely indicating data entry errors.
 
 ### Gender Standardization
 - The `Gender` column was cleaned and standardized into four categories:
   - `"Male"`: For entries matching patterns like "male", "m", "man".
   - `"Female"`: For entries matching patterns like "female", "f", "woman".
   - `"Other"`: For non-binary or other gender identities (e.g., "trans", "non-binary").
   - `NA`: For unrecognized or missing entries.
 - Pattern matching (e.g., using `str_detect()`) was applied to handle varied input formats.
 
 ### Handling Missing Values
 - Empty strings (`""`) in categorical columns were replaced with `NA` to ensure consistent representation of missing data.
 - `NA` values in numerical columns, such as `Age`, were retained as is, leaving them for potential imputation in future analysis.
 
 ### Standardizing no_employees
 - The `no_employees` column was categorized into predefined ranges:
   - `"26-100"`
   - `"100-500"`
   - `"500-1000"`
   - `"More than 1000"`
 - Values not matching these ranges were set to `NA`.
 
 ### Combining Data Sheets
 - After standardizing the `Timestamp` column in Sheet1 to match Sheet2’s POSIXct format, the two sheets were merged into a single dataset using `bind_rows()` from the `dplyr` package.
 
 ## Visualizations
 Two visualizations were created using the `ggplot2` package to explore the cleaned dataset:
 1. **Histogram of Age**
   - Displays the distribution of respondent ages with a bin width of 5 years, spanning an age range from 18 to 72 years.
   - The histogram reveals that the majority of respondents fall between 25 and 40 years old, with a noticeable peak in the 30-35 age bin, suggesting this is the most common age group in the survey.
   - The distribution exhibits a slight right skew, with a longer tail toward older ages, indicating fewer respondents above 50 years and a small presence of outliers in the higher age range (e.g., near 70).
   - This visualization provides a clear overview of the age demographics, highlighting the predominance of younger adults in the dataset, which may reflect the target population of the mental health survey.
   - `NA` values in the `Age` column were excluded from the plot to ensure the distribution reflects only valid data points.
     
 2. **Boxplot of Age by Gender**
   - Illustrates the distribution of ages across the standardized gender categories: `Male`, `Female`, and `Other`, enabling a comparison of age profiles between groups.
   - Key statistics:
     - **Median ages**: Approximately 32 years for `Male`, 30 years for `Female`, and 28 years for `Other`, indicating a slightly younger central tendency in the `Other` category.
     - **Interquartile ranges (IQR)**: 
       - `Male`: 27-36 years
       - `Female`: 25-35 years
       - `Other`: 24-32 years
     - These ranges show the middle 50% of ages and suggest moderate variability within each gender group.
   - The boxplot reveals that age distributions are fairly consistent across genders, though the `Other` category has a tighter spread and slightly younger respondents overall. Outliers are present, particularly in the `Male` and `Female` groups, with some respondents exceeding 60 years.
   - This visualization is valuable for identifying potential differences in age-related mental health patterns across gender identities, with the compact distribution in the `Other` category possibly reflecting a smaller sample size or a distinct demographic.
   - `NA` values in either the `Age` or `Gender` columns were excluded to ensure the accuracy of the plotted distributions.
 
 ## Repository Contents
 - **`ANA515P_dataPreparation.R`**: The R script that performs data loading, cleaning, merging, and visualization.
 - **`mental_health_data_cleaned.csv`**: The final cleaned and combined dataset, ready for analysis.
 - **`survey.xlsx`**: The original Excel workbook with two sheets containing mental health survey data.
 - **`README.md`**: This file, providing an overview and documentation of the project.
