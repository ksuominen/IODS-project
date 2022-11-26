# Kristiina Suominen
# 26.11.2022
# The data originates from the United Nations Development Programme

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

# renaming variables
names(hd) <- c("HDI.Rank", "Country", "HDI", "Life.Exp", "Edu.Exp", "Edu.Mean", "GNI", "GNI.Minus.Rank")
names(gi) <- c("GII.Rank", "Country", "GII", "Mat.Mor", 
               "Ado.Birth", "Parli.F", "Edu2.F", "Edu2.M", 
               "Labo.F", "Labo.M")

# Create new variables in gi
gi <- mutate(gi, Edu2.FM = Edu2.F / Edu2.M, Labo.FM = Labo.F / Labo.M)

# join datasets and write to file
human <- inner_join(hd, gi, by = "Country")
dim(human)
# The new dataset has 195 observations of 19 variables

write.csv(human, "./data/human.csv", row.names = FALSE)

