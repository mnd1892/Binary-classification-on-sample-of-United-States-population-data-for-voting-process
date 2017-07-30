step 1: Working with data
Since all the rows are comma seprated so i imported data with read.csv() command and kept header to false because
there are no headers so R by default converted all columns into seperate vecotrs.

Checked structure of data using str() function. Obsvered that data set contains 17 attributes and 435 instances.
Data set contains two class labels "Republican" and "Democrat" so we are goind two perform binary classification.
All other 17 attributes contains nominal quanities.
There are also missing values in data set with label '?'
I am going to use "Mice" package to impute data so i will replace all labels which contains '?' with 'NA'
After replacing all value i used summary() function to observe number of missing values each and every attributes contains.

step 2: Imputing missing values
To impute missing values I used mice package.
To see options available in mice package I used methods(mice) to check wether which functions are available.
I used polynomial regression out of those methods.
With method I had to select other four more parameters which are: m,maxit,seed and m where,
maxit is number of iterations.
Hence I set all of those values and got imputed dataset and named it as clean data. 

step 3:
I used classification algorithms: Decision Trees(C5.0) and Naive Bayes
I have used different techniques to extract train and test data.
In naive bayes I used top 200 rows as train data and other 235 as test data.
In decision tree I generated random 200 values between 1 to 435 and took other 235 as test data

I got accuracy for both algorithms like,
Naive Bayes:
             | actual 
   predicted |   democrat | republican |  Row Total | 
-------------|------------|------------|------------|
    democrat |        134 |          2 |        136 | 
             |      0.985 |      0.015 |      0.579 | 
             |      0.944 |      0.022 |            | 
-------------|------------|------------|------------|
  republican |          8 |         91 |         99 | 
             |      0.081 |      0.919 |      0.421 | 
             |      0.056 |      0.978 |            | 
-------------|------------|------------|------------|
Column Total |        142 |         93 |        235 | 
             |      0.604 |      0.396 |            | 
-------------|------------|------------|------------|

So from observing table i can say that in this case 10 instances are misclassified 

Decision Tree:

             | actual 
   predicted |   democrat | republican |  Row Total | 
-------------|------------|------------|------------|
    democrat |        131 |          1 |        132 | 
             |      0.992 |      0.008 |      0.562 | 
             |      0.916 |      0.011 |            | 
-------------|------------|------------|------------|
  republican |         12 |         91 |        103 | 
             |      0.117 |      0.883 |      0.438 | 
             |      0.084 |      0.989 |            | 
-------------|------------|------------|------------|
Column Total |        143 |         92 |        235 | 
             |      0.609 |      0.391 |            | 
-------------|------------|------------|------------|

By comparing decision trees and naive bayes it is clear that naive bayes is more efficient than decision tree.

step 5:
In steps mentioned above I have applied simple training and testing data to model. But there also some other methods
to check performance of model.
One of them is crossfold validation technique.
I have used number of 10 crossfod validations.
Working: It picks small chunk of data from data set as test data and builds training model on remaining data for count of ten it picks up ten.
different chunks and performs test.
output: Output has returned different kappa values which represents different accuracies for model. 

step 6: Building simple and customized tuning models for naive bayes and decision trees to check improvement in performances
There is one method available called ModelLookup to check tuning parameters of specific model.
I have used caret() package for parameter tuning process.
Automated parameter tunning

c5.0(Decision Tree)

                tuned_test_label
prediction_votes democrat republican
      democrat        263          2
      republican        4        166

Naive Bayes
                tuned_test_label
prediction_votes democrat republican
      democrat        254         11
      republican       13        157

Compared to previous tests. These methods work on the whole set of data because it uses cross fold validation technique. But from accuracies we can see that
tuned model will always perform better.

There are also different parameters available for customization of tuning process. I used some those parameters like control,expandGrid and kappa statistics.

step 7:
Ensemble learning:
This techniques works by combining outputs of multiple classifiers.I have used bagging method to use ensemble learning.
I have used ipred package to perform bagging operation
Accuracy of simple bagging method.

Ensemble learning bagging
            tuned_test_label
votes_pred   democrat republican
  democrat        266          0
  republican        1        168

As from above I can see that only one instance miss classified. I have used crossvalidation in this method so it can be considered as overfitted data.

               Observed Class
Predicted Class democrat republican
     democrat        266          0
     republican        1        168

By comparing both methods we can conclude that this methods can work way more better but there are chances of overfitting of data.
Confusion matrix for adaboost woth 10 fold cross validation
               Observed Class
Predicted Class democrat republican
     democrat        256          8
     republican       11        160
