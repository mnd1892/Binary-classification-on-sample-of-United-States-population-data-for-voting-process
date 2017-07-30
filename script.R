#import data into data fame format
testdata <- as.data.frame(read.csv("house-votes.txt",header = F))

#replace missing values with NA
testdata[testdata=="?"] <- NA

#check structure of data
str(testdata)

#check for mean values in data
summary(testdata)

#load all necessary libraries
library(mice)

library(gmodels)

library(e1071)

library(irr)

library(caret)

library(ipred)

library("C50")

library(adabag)

#count number of labels in class attribute
table(testdata$V1)

#check for methods available in mice package
methods(mice)

#impute the data
data_imputed <- mice(testdata, m=3, maxit = 5, method = 'polyreg', seed = 500)

mice(data=testdata, m=3, maxit = 5, method = 'polyreg', seed = 500)

#load imputed data 
clean_data <- complete(data_imputed,1)

#create train data and test data for naivebayes
traindata <- clean_data[1:200,]

testdata <- clean_data[201:435,]

#fetch labels for train and test data
trainlabels = traindata$V1

testlabels <- testdata$V1

#create naive bayes classifier
test_classifier <- naiveBayes(traindata,trainlabels)

#predict values for naive bayes
test_prediction <- predict(test_classifier,testdata)

#calculate accuracy for naive bayes
CrossTable(test_prediction,testlabels,prop.chisq = FALSE, prop.t = FALSE,dnn = c('predicted', 'actual'))

#set seed size 
set.seed(123)

#create training data from random values
train_sample<-sample(435,200)

votes_train <- clean_data[train_sample,]

#create test data with excluding those random values
votes_test <- clean_data[-train_sample,]

#create decision tree model for train data
votes_model <- C5.0(votes_train[-1],votes_train$V1)

#predcit values for decision tree 
votes_predict <- predict(votes_model,votes_test)

#generate labels from test data
votes_test_label <- as.factor(votes_test$V1)

#Get accuracy for naive bayes
CrossTable(votes_predict,votes_test_label,prop.chisq = FALSE, prop.t = FALSE,dnn = c('predicted', 'actual'))

#perform cross fold validation with 10 folds

folds <- createFolds(clean_data$V1, k = 10)

#compute validation for decision tree

cv_results_decisiontree <- lapply(folds, function(x) {
     votes_train <- clean_data[-x, ]
     votes_test <- clean_data[x, ]
     votes_model <- C5.0(V1 ~ ., data = votes_train)
     votes_pred <- predict(votes_model, votes_test)
     votes_actual <- votes_test$V1
     kappa <- kappa2(data.frame(votes_actual,votes_pred))$value
     return(kappa)
     })

#compute validation for naive bayes

cv_results_naivebayes <- lapply(folds, function(x) {
     votes_train <- clean_data[-x, ]
     votes_test <- clean_data[x, ]
     train_labels <- votes_train$V1
     votes_model <- naiveBayes(votes_train,train_labels)
     votes_pred <- predict(votes_model, votes_test)
     votes_actual <- votes_test$V1
     kappa <- kappa2(data.frame(votes_actual,votes_pred))$value
     return(kappa)
     })



#check different tunning parameters for caret package
modelLookup("C5.0")
modelLookup("NB")

#build simple automated tunning parameter tuned model for decision tree 
votes_tunned <- train(V1 ~ ., data = clean_data, method = "C5.0")

votes_tunned$finalModel

plot(votes_tunned)

prediction_votes <- predict(votes_tunned,clean_data)

tuned_test_label <- as.factor(clean_data$V1)

table(prediction_votes,tuned_test_label)

head(predict(votes_tunned,clean_data, type = "prob"))

#build customized automated parameter tuned model for Decision Tree

ctrl <- trainControl(method = "cv", number = 10, selectionFunction="oneSE")

grid <- expand.grid(.model = "tree", .trials = c(1,5,10,15,20,25,30,35), .winnow = "FALSE")

set.seed(1)

model_decision_tree <- train(V1 ~ ., data = clean_data, method = "C5.0", metric = "Kappa", trControl = ctrl, tuneGrid = grid)

model_decision_tree


#build simple automated parameter tuned model for naive bayes 

votes_tunned <- train(V1 ~ ., data = clean_data, method = "nb")

votes_tunned$finalModel

plot(votes_tunned)

prediction_votes <- predict(votes_tunned,clean_data)

table(prediction_votes,tuned_test_label)

head(predict(votes_tunned,clean_data, type = "prob"))

#build customized automated parameter tuned model for naive bayes 

ctrl <- trainControl(method="oneSE", number=10, repeats=3)

model_decision_tree <- train(V1~., data=clean_data, trControl=ctrl, method="nb")

model_decision_tree


#implement ensemble learning method

#use bagging method for decision tree

set.seed(1)

votesbag <- bagging(V1 ~ ., data = clean_data, nbagg = 25)

votes_pred <- predict(votesbag, clean_data)

table(votes_pred,tuned_test_label)

#customized bagging using caret package

ctrl <- trainControl(method = "cv", number = 10)

train(V1 ~ ., data = clean_data, method = "treebag", trControl = ctrl)

#using ensemble learning techqiue boosting

votes_adaboost <- boosting(V1 ~ ., data = clean_data)

predict_votes_adaboost <- predict(votes_adaboost, clean_data)

predict_votes_adaboost$confusion

set.seed(1)

adaboost_votes_cv <- boosting.cv(V1 ~ ., data = clean_data)

adaboost_votes_cv$confusion






