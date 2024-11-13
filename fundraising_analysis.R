FundRaising <- read.csv("Fundraising Raw Data.csv", header = T)
# Question 1:
listMissingColumns <- colnames(FundRaising)[ apply(FundRaising, 2, anyNA)]
print(listMissingColumns)

#Question 2;

meanMissing <- apply(FundRaising[,colnames(FundRaising) %in% listMissingColumns], 
                     2, mean, na.rm =  TRUE)
print(meanMissing)

medianMissing <- apply(FundRaising[,colnames(FundRaising) %in% listMissingColumns], 
                       2, median, na.rm =  TRUE)
print(medianMissing)

# Importing library
# install.packages('dplyr')
library(dplyr)

newDataFrame <- FundRaising %>% mutate(
 HV_1 = ifelse(is.na(HV_1), meanMissing[1], HV_1),
  Icmed1 = ifelse(is.na(Icmed1), meanMissing[2], Icmed1),
 Icavg1 = ifelse(is.na(Icavg1),medianMissing[3],Icavg1))

newDataFrame

#Question 3:
#Identifying outliers
identify_outliers <-function (column){
  qnt <- quantile(column, probs=c(.25, .75), na.rm = T)
  H <- 1.5 * IQR(column, na.rm = T)
  LL <- qnt[1] - H
  UL <- qnt[2] + H
  out <- subset(newDataFrame, column < LL | column > UL)
  inl <- subset(newDataFrame, column > LL & column < UL )
  return (out)
}
outliers_HV_1<-identify_outliers(newDataFrame$HV_1)
print(outliers_HV_1)
outliers_Icmed1<-identify_outliers(newDataFrame$Icmed1)
print(outliers_Icmed1)
outliers_Icavg1<-identify_outliers(newDataFrame$Icavg1)
print(outliers_Icavg1)

# Box Plot
boxplot(newDataFrame$HV_1, newDataFrame$Icmed1, newDataFrame$Icavg1,
        names = c("HV_1","Icmed1","Icavg1"),
        col = c("green",'yellow',"red"),
        ylab = "Values",
        main = "Boxplot of HV_1, Icmed1, Icavg1"
)

# Finding outliers
boxplot.stats(newDataFrame$HV_1)$out
boxplot.stats(newDataFrame$Icmed1)$out
boxplot.stats(newDataFrame$Icavg1)$out

#Question 4:
#  Replacing outlier by  Q1-1.5*IQR or Q3+1.5*IQR
capOutlier  <- function(x){
  qnt <- quantile(x, probs=c(.25, .75), na.rm = T)
  H <- 1.5 * IQR(x, na.rm = T)
  x[x < (qnt[1] - H)] <-  (qnt[1] - H)
  x[x > (qnt[2] + H)] <- (qnt[2] + H) 
  return(x)
}
newDataFrame$HV_1=capOutlier(newDataFrame$HV_1)
newDataFrame$Icmed1=capOutlier(newDataFrame$Icmed1)
newDataFrame$Icavg1=capOutlier(newDataFrame$Icavg1)
newDataFrame

#Question 5:
correlation_matrix <- cor(newDataFrame)
print(correlation_matrix)

# Create a heatmap of the correlation coefficients
install.packages("corrplot")
library(corrplot)
corrplot(correlation_matrix, method = "color",type="lower",tl.col = "black",tl.srt = 45)

# There is a strong positive correlation (0.959) between "Icmed1" and "Icavg1", indicating
# that as the value of "Icmed1" increases, the value of "Icavg1" tends to increase as well. 
# These both measure similar aspect of dataset, which is Income, the high correlation suggests that the distribution of incomes within that category is relatively consistent. 
# If the median and average are closely aligned, it usually indicates that there are not many extreme outliers affecting the average.
# 
# There is a strong positive correlation (0.864) between "AVGGIFT" and "LASTGIFT", indicating
# that as the value of "AVGGIFT" increases, the value of "LASTGIFT" tends to increase as well.
# This may suggest that individuals with higher average gift values also tend to have higher recent gift values.
# 
# A strong negative correlation (-0.729) between "IC15" and "Icmed1", indicating that as the
# value of "IC15" increase, the value of "Icmed1" tends to decrease.
# 
# From the heatmap, we can see that correlation all being less than 0.5 indicate weak to moderate 
# relationships between the output variables (TARGET_D) and the input variables, suggesting that
# individual features may not have a strong direct impact or that the relationship could be non-linear.

#Question 6:
str(newDataFrame)
# Continuous variables: Rand, HV_1, Icmed_1, Icavg_1, RAMNTALL, LASTGIFT, AVGGIFT
# Discrete variables: The rest

library(ggplot2)

# Create a histogram for the discrete variable
ggplot(newDataFrame, aes(x = totalmonths)) +
  geom_histogram(binwidth = 1, fill = "lightblue", color = "black") +
  geom_vline(aes(xintercept = mean(TARGET_D)), color = "red", linetype = "dashed", size = 1) +
  labs(title = "Histogram of Discrete Variable with Average Target_D",
       x = "Discrete Variable",
       y = "Count") +
  theme_minimal()

ggplot(newDataFrame, aes(x = WEALTH)) +
  geom_histogram(binwidth = 1, fill = "lightblue", color = "black") +
  geom_vline(aes(xintercept = mean(TARGET_D)), color = "red", linetype = "dashed", size = 1) +
  labs(title = "Histogram of Discrete Variable with Average Target_D",
       x = "Discrete Variable",
       y = "Count") +
  theme_minimal()

# Create a scatter plot for the continuous variable
ggplot(newDataFrame, aes(x = AVGGIFT, y = TARGET_D)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", color = "blue") +  # Add a regression line
  labs(title = "Scatter Plot of Continuous Variable vs. Target_D",
       x = "Continuous Variable",
       y = "Target_D") +
  theme_minimal()

ggplot(newDataFrame, aes(x = Icmed1, y = TARGET_D)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", color = "blue") +  # Add a regression line
  labs(title = "Scatter Plot of Continuous Variable vs. Target_D",
       x = "Continuous Variable",
       y = "Target_D") +
  theme_minimal()

#PARTB
#Question1
#Question2:
set.seed(1234)
partdata <- sample(2, nrow(newDataFrame),replace=TRUE,prob=c(0.5,0.5))
training <- newDataFrame[partdata==1,]
test <- newDataFrame[partdata==2,]

View(training)
View(test) 

#Question 3. Perform Linear Regression using lm function

#Read the column name of response variable into 'y'
y <- colnames(training)[24];

#Read the column names of all the input variables into 'a'
a <- colnames(training);

#Remove the response variable i.e. last column of Medv from 'a' and put it into 'x'
x<- a[-c(1,2,24)]

#Build the model using linear regression 'lm' function
mymodel <- as.formula(paste(y, paste(x, collapse="+"), sep="~"))
fit <- lm(mymodel, data=training)
summary(fit) 

#Question4. Predict the test data using the model
test.pred <- predict.lm(fit,newdata=test,se.fit = TRUE)
test_with_prediction <- cbind(test,test.pred$fit)
write.csv(test_with_prediction,file = "test_with_prediction.csv")

#Question5
#Question6,7: Excel