# libraries
library(readxl)
library(dplyr)
library(xts)

# suppressing the warnings
options(warn = -1)

# setting the working directory
setwd("/Users/yuriisemenov/Documents/GitHub/RRcourse2023_project/Data")

# creating a vector with the names of the row files
data <- c("CPI", "DSPI", "HPI", "IR", "POP", "UNRATE", "CONF_2", "GDP")

# loading the data
for (i in data) {
  filename <- paste0(i, ".xls")  
  file_path <- paste0("/Users/yuriisemenov/Documents/GitHub/RRcourse2023_project/Data/Raw_data/",
                      filename) 
  assign(i, read_excel(file_path))  
}

file_path
# checking the structure of the data
data_2 <- list(CPI = CPI, DSPI = DSPI, HPI = HPI, IR = IR, POP = POP,
               UNRATE = UNRATE, CONF_2 = CONF_2)

for (i in names(data_2)) {
  x = str(data_2[[i]])
  print(paste(i, as.character(x)))
}

## standardization of the data

# list to loop through
data_3 <- list(CPI = CPI, DSPI = DSPI, HPI = HPI, IR = IR, POP = POP,
               UNRATE = UNRATE)

# steps for the loops:
# convert to data frame
# standardize the column names as "Date" + "name of the variable"
# convert to the xts object
# aggregate to quarter basis

for (name in names(data_3)) {
  df <- as.data.frame(data_3[[name]])
  names(df) <- c("Date", name)
  df_xts <- xts(df[,2], order.by=df$Date)
  df_q <- to.quarterly(df_xts)[, 4]
  assign(paste0(name, "_q"), df_q)
}


# as CONF and GDP are downloaded with the quarterly frequency -> do adjustment
# outside the the main loop
# confidence
CONF_2 <- CONF_2[2]
CONF_2 <- data.frame(CONF_2)
# producing a vector that has all numeric values for CONF_2
CONF_2 <- as.numeric(unlist(CONF_2))
# GDP
GDP <- GDP[2]
GDP <- data.frame(GDP)
# producing a vector that has all numeric values for GDP_2
GDP <- as.numeric(unlist(GDP))

# creating the final dataset with all variables
dataset <- merge(CPI_q, DSPI_q, GDP, HPI_q, IR_q, POP_q, UNRATE_q, CONF_2)
names(dataset) <- c("CPI", "DSPI", "GDP", "HPI", "IR", "POP", "UNRATE", "CONF")

# removing unnecessary objects  
rm(CPI, DSPI, GDP, HPI, IR, POP, UNRATE,CONF_2, data_2, data_3, df, df_q, df_xts, CPI_q, 
   DSPI_q, HPI_q, IR_q, POP_q, UNRATE_q, data, file_path, file_name, 
   i, name,x, filename)

# saving the preparing data file as an R object
save(dataset, file = "dataset")
print("dataset is created. You can proceed with the analysis")

