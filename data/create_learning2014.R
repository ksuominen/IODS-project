#Kristiina Suominen
#2.11.2022
#Data from international survey of Approaches to Learning
#Data: http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt
#Information about the dataset: https://www.mv.helsinki.fi/home/kvehkala/JYTmooc/JYTOPKYS3-meta.txt

#read the data
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

dim(lrn14)
#The dataset has 183 rows and 60 columns

str(lrn14)
#The dataset is a dataframe with 183 observations of  60 variables

library(dplyr)
#creating combination variables stra, deep and surf and scaling them by taking the mean
lrn14$attitude <- lrn14$Attitude / 10
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
lrn14$deep <- rowMeans(lrn14[, deep_questions])
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
lrn14$surf <- rowMeans(lrn14[, surface_questions])
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
lrn14$stra <- rowMeans(lrn14[, strategic_questions])

#Scaling Attitude back to the original scale of the questions, by dividing it with the number of questions.
lrn14$attitude <- lrn14$Attitude / 10

#keeping only selected columns
keep_columns <- c("gender","Age","attitude", "deep", "stra", "surf", "Points")
learning2014 <- select(lrn14, one_of(keep_columns))
                       
colnames(learning2014)[2] <- "age"
colnames(learning2014)[7] <- "points"

#excluding observations where exam point variable is zero
learning2014 <- filter(learning2014, points > 0)

str(learning2014)
#The dataset now has 166 observations and 7 variables

write.csv(learning2014, "./data/learning2014.csv", row.names = FALSE)
