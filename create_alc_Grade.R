# created at 17.12.2017
# @author: Zilan

setwd('C:/HY-Data/ZILAN/documents/meterials about course/Introduction to open data science/IODS-Final/Data')
library(readr)
mat <- read.table('student-mat.csv', sep = ';', header = T)
por <- read.table('student-por.csv', sep = ";", header = T)
str(mat)
dim(mat)
str(por)
dim(por)
library(dplyr)
#  common columns to use as identifiers
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")
mat_por <- inner_join(mat, por, by = join_by, suffix = c(".mat", ".por"))
colnames(mat_por)
str(mat_por)
dim(mat_por)
alc <- select(mat_por, one_of(join_by))
notjoined_columns <- colnames(mat)[!colnames(mat) %in% join_by]
for(column_name in notjoined_columns) {
  # select two columns from 'mat_por' with the same original name
  two_columns <- select(mat_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}
glimpse(alc)
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
alc <- mutate(alc, Grade = (G1 + G2 + G3) / 3) 

alc <- mutate(alc, high_use = alc_use > 2)
glimpse(alc)
str(alc)
write.table(alc, file = 'alc.txt', row.names = F, sep = ',')
colnames(alc)
select_columns <- c('sex', 'age', 'Medu', 'Fedu', 'traveltime', 'studytime', 'failures', 'famrel', 'freetime', 'goout',  'health', 'absences','alc_use', 'Grade')
alc_Grade <- select(alc, one_of(select_columns))
write.table(alc_Grade, file = 'alc_Grade.txt', row.names = F, sep = ',')
