#Kristiina Suominen
#10.12.2022

library(dplyr)
library(tidyr)

# Create BPRS dataset
# Read the BPRS data
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep =" ", header = T)

# Check the column names
names(BPRS)
# Treatment, Subject, Weeks 0-8

# Look at the structure of dataset
str(BPRS)
# 40 observations of 11 variables, all are in integer format

# Print out summaries of the variables
summary(BPRS)

# Factor variables treatment and subject
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

# Glimpse the data
glimpse(BPRS)

# Convert to long form
BPRSL <-  pivot_longer(BPRS, cols = -c(treatment, subject),
                       names_to = "weeks", values_to = "bprs") %>%
  arrange(weeks) #order by weeks variable

# Extract the week number
BPRSL <-  BPRSL %>% 
  mutate(week = as.integer(substr(weeks,5, 5)))

# Take a glimpse at the BPRSL data
glimpse(BPRSL)

# Check the long form dataset more closely
names(BPRSL)
str(BPRSL)
head(BPRSL)
summary(BPRSL)

# Write dataset to file
write.table(BPRSL, "./data/BPRSL.txt")


# Create RATS dataset
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE, sep = '\t')

# Check the column names
names(RATS)
# ID, Group, Weight on day 1, 8, 15, 22, 29, 36, 43, 44, 50, 57, 64

# Look at the structure of dataset
str(RATS)
# 16 observations of 13 variables, all are in integer format

# Print out summaries of the variables
summary(RATS)

# Factor variables ID and Group
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

# Glimpse the data
glimpse(RATS)

# Convert data to long form
RATSL <- pivot_longer(RATS, cols = -c(ID, Group), 
                      names_to = "WD",
                      values_to = "Weight") %>% 
  mutate(Time = as.integer(substr(WD,3,4))) %>%
  arrange(Time)

# Glimpse the data
glimpse(RATSL)

# Check the long form dataset more closely
names(RATSL)
str(RATSL)
head(RATSL)
summary(RATSL)

# Write dataset to file
write.table(RATSL, "./data/RATSL.txt")
