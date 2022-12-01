# Kristiina Suominen
# 26.11.2022
# The data originates from the United Nations Development Programme
# Original data from: http://hdr.undp.org/en/content/human-development-index-hdi

library(tidyverse)

# Read in the “Human development” and “Gender inequality” data sets
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gi <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

# Meta file: https://hdr.undp.org/data-center/human-development-index#/indicies/HDI
# Technical notes: https://hdr.undp.org/system/files/documents//technical-notes-calculating-human-development-indices.pdf

# Structure and dimensions of "Human development" and summaries of variables
str(hd)
dim(hd)
summary(hd)
# The dataset has 195 observations of 8 variables

# Structure and dimensions of "Gender inequality" and summaries of variables
str(gi)
dim(gi)
summary(gi)
# The dataset has 195 observations of 10 variables

# Renaming variables
names(hd) <- c("HDI.Rank", "Country", "HDI", "Life.Exp", "Edu.Exp", "Edu.Mean", "GNI", "GNI.Minus.Rank")
names(gi) <- c("GII.Rank", "Country", "GII", "Mat.Mor", 
               "Ado.Birth", "Parli.F", "Edu2.F", "Edu2.M", 
               "Labo.F", "Labo.M")

# Create new variables in gi
gi <- mutate(gi, Edu2.FM = Edu2.F / Edu2.M, Labo.FM = Labo.F / Labo.M)

# Join datasets and write to file
human <- inner_join(hd, gi, by = "Country")
dim(human)
# The new dataset has 195 observations of 19 variables
write.csv(human, "./data/human.csv", row.names = FALSE)


# Data wrangling continues (assignment 5)
# Kristiina Suominen
# 26.11.2022

# Load the data
human <- read_csv("./data/human.csv")
dim(human)
str(human)

# The data originates from the United Nations Development Programme
# Original data from: http://hdr.undp.org/en/content/human-development-index-hdi
# Meta file: https://hdr.undp.org/data-center/human-development-index#/indicies/HDI
# Technical notes: https://hdr.undp.org/system/files/documents//technical-notes-calculating-human-development-indices.pdf
# The dataset contains 195 observations of 19 variables

# Variable abbreviations explained:
  # "Country" = Country name
  # "GNI" = Gross National Income per capita
  # "Life.Exp" = Life expectancy at birth
  # "Edu.Exp" = Expected years of schooling 
  # "Mat.Mor" = Maternal mortality ratio
  # "Ado.Birth" = Adolescent birth rate
  # "Parli.F" = Percetange of female representatives in parliament
  # "Edu2.F" = Proportion of females with at least secondary education
  # "Edu2.M" = Proportion of males with at least secondary education
  # "Labo.F" = Proportion of females in the labour force
  # "Labo.M" " Proportion of males in the labour force
  # "Edu2.FM" = Edu2.F / Edu2.M
  # "Labo.FM" = Labo2.F / Labo2.M

# Transform the Gross National Income (GNI) variable to numeric
human$GNI <- gsub(",","",human$GNI) %>% as.numeric

# Exclude unneeded variables
keep <- c("Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")
human <- dplyr::select(human, one_of(keep))

# Remove all rows with missing values
human <- filter(human, complete.cases(human))

# Remove observations which relate to regions instead of countries
human$Country
# It would seem that the last 7 observations have regions instead of countries
n_until <- nrow(human) - 7
human <- human[1:n_until, ]

# Define the row names by the country names
rownames(human) <- human$Country

# Remove the Country column
human <- dplyr::select(human, -Country)
dim(human)
# There are now 155 observations of 8 variables

# Write to file
write.csv(human, "./data/human.csv", row.names = TRUE)
