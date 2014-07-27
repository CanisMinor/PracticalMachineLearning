library(caret)
library(randomForest)
library(e1071)


#read in training data
 exerciseData <- read.csv("pml-training.csv", na.strings=c("NA",""))

#remove data columns that where all entries are empty or NA
 NAs <- apply(exerciseData,2,function(x) {sum(is.na(x))})
 cleanData <- exerciseData[,which(NAs==0)]

#remove data that is irrelevant, e.g., time stamps and user name, from training data 
 irrelevantIndex = grep("timestamp|X|user_name|new_window", names(cleanData))
 cleanData <- cleanData[,-irrelevantIndex]

#train a random forest on processed training data set
 modFit <- train(classe ~ ., method = "rf", data = cleanData)

#read in test dataset
 testData = read.csv("pml-testing.csv", na.strings = c("NA",""))

#clean NA and empty columns from test dataset
 NATest <- apply(testData,2,function(x) {sum(is.na(x))})
 cleanTest <- testData[,which(NATest == 0)]

#evaluate predictions on the test dataset
 preds = predict(modFit, cleanTest)
