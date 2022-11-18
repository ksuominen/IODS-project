#Kristiina Suominen
#18.11.2022
#Dataset approaching student achievement in secondary education in two Portuguese schools
#Data and more information about the dataset: https://archive.ics.uci.edu/ml/datasets/Student+Performance

#web address for math class data
url_math <- paste(url, "student-mat.csv", sep = "/")

#read the math class questionnaire data into memory
math <- read.table(url_math, sep = ";" , header = TRUE)

#web address for Portuguese class data
url_por <- paste(url, "student-por.csv", sep = "/")

#read the Portuguese class questionnaire data into memory
por <- read.table(url_por, sep = ";", header = TRUE)

#structure and dimensions of math class data
dim(math)
str(math)
#The dataset is a dataframe with 395 observations (rows) of  33 variables

#structure and dimensions of Portuguese class data
dim(por)
str(por)
#The dataset is a dataframe with 649 observations (rows) of  33 variables

library(dplyr)

#the columns that vary in the two data sets
free_cols <- c("failures", "paid", "absences", "G1", "G2", "G3")

#the rest of the columns are common identifiers used for joining the data sets
join_cols <- setdiff(colnames(por), free_cols)

#joining the two data sets by the selected identifiers
math_por <- inner_join(math, por, by = join_cols, suffix=c(".math", ".por"))

# create a new data frame with only the joined columns
alc <- select(math_por, all_of(join_cols))

#structure and dimensions of joined data
dim(alc)
str(alc)
#The dataset is a dataframe with 370 observations (rows) of  33 variables

# for every column name not used for joining...
for(col_name in free_cols) {
  # select two columns from 'math_por' with the same original name
  two_cols <- select(math_por, starts_with(col_name))
  # select the first column vector of those two columns
  first_col <- select(two_cols, 1)[[1]]
  
  # then, enter the if-else structure!
  # if that first column vector is numeric...
  if(is.numeric(first_col)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[col_name] <- round(rowMeans(two_cols))
  } else { # else (if the first column vector was not numeric)...
    # add the first column vector to the alc data frame
    alc[col_name] <- first_col
  }
}

#define a new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

#define a new logical column 'high_use'
alc <- mutate(alc, high_use = alc_use > 2)

#glimpse at the new combined data
glimpse(alc)

library(tidyverse)
#saving the new dataset
write.csv(alc, "./data/alc.csv", row.names = FALSE)

#check that everything works
alc <- read.csv("./data/alc.csv")
head(alc)
