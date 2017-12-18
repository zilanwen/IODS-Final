# created at 17.12.2017
# @author: Zilan

getwd()
setwd('D:/github/IODS-Final/Data')
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
alc <- dplyr::select(mat_por, one_of(join_by))
notjoined_columns <- colnames(mat)[!colnames(mat) %in% join_by]
for(column_name in notjoined_columns) {
  # select two columns from 'mat_por' with the same original name
  two_columns <- dplyr::select(mat_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- dplyr::select(two_columns, 1)[[1]]
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}
Alc <- mutate(alc, alc_use = (Dalc + Walc) / 2, high_use = alc_use > 2)
colnames(Alc)
# columns to keep
keep <- c("address", "famsize", "Pstatus", 'Mjob', 'Fjob', 'reason', 'guardian','high_use')
Alc_MCA <- dplyr::select(Alc, one_of(keep))

write.table(Alc_MCA, file = 'Alc_MCA.txt', row.names = F, sep = ',')
