# PracticalMachineLearning
This repository relates to my submission for a course project for the Practical Machine Learning Coursera course.  This readme is written with the requirements of the course submission in mind.

This project was written for submission as a course project for the Practical Machine Learning course on Coursera. The aim is to apply machine learning on accelerometer data in order to decide how a particular weight-lifting exercise was performed. The performance is classified in terms of five possible labels: A, B, C, D and E.

##Implementation

I used the caret and randomForest packages in R to run a random forest on the training data from the Human Activity Recognition Project of Groupware@LES (see Acknowledgements). In particular, I performed cross-validation by the use of the createDataPartition command of caret.

In order to speed up the training, I removed all columns of the training data where entries were either "NA" or empty strings. I also removed columns that contained information that should not be treated as predictors, such as, e.g., timestamps and user names.

remove data columns that where all entries are empty or NA
```
 NAs <- apply(exerciseData,2,function(x) {sum(is.na(x))})
 cleanData <- exerciseData[,which(NAs==0)]
```

remove data that is irrelevant, e.g., time stamps and user name, from training data
```
 irrelevantIndex = grep("timestamp|X|user_name|new_window", names(cleanData))
 cleanData <- cleanData[,-irrelevantIndex]
```

Once the training and test datasets had been processed in this way, I trained a random forest on the training data,
```
 modFit <- train(classe ~ ., method = "rf", data = cleanData)
```

Finally, I evaluated the predictions of the trained random forest model on the test data,

```
 preds = predict(modFit, cleanTest)
```

## Notes on Errors

In order to perform cross-validation, the script could be edited as follows. We want to split the data in "pml-training.csv" into training and testing data in different ways. This can be done by inserting the following commands on line 7,

 inFold <- createDataPartition(y=exerciseData$classe, p=0.75, list=FALSE)
 testData <- exerciseData[-inFold,]
 exerciseData <- exerciseData[inFold,]
and then remove lines 21-22 from the script, i.e., do not overwrite testData with the data in "pml-testing.csv" as in the original script. By varying the p-parameter and performing the calculation of preds as per the script, and comparing these to the actual values of the 'classe' variable I estimated a test error of approximately 100-96 = 4 %.

I picked the random forest method as it gives a relatively high accuracy on the training set (96% depending on the split into training/test) and also provided 100 % accuracy on the test data. As the training data set is huge in comparison to the test data set, one could expect the test data error to be low, but that it is lower than the actual training error is surprising and probably fluke.

## Acknowledgements

The test and training data were provided by Groupware@LES, see

Ugulino, W.; Cardador, D.; Vega, K.; Velloso, E.; Milidiu, R.; Fuks, H. Wearable Computing: Accelerometers' Data Classification of Body Postures and Movements. Proceedings of 21st Brazilian Symposium on Artificial Intelligence. Advances in Artificial Intelligence - SBIA 2012. In: Lecture Notes in Computer Science. , pp. 52-61. Curitiba, PR: Springer Berlin / Heidelberg, 2012. ISBN 978-3-642-34458-9. DOI: 10.1007/978-3-642-34459-6_6

I got some ideas from the discussion forum on Coursera and in particular from posts by Christian Grant.
