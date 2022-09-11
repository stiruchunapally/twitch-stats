#CHANGE LOCATION OF DIRECTORY TO WHERE twitchdata-update.csv IS ON YOUR LOCAL MACHINE
twitchData = read.csv('C:\\Sreekar\\School\\STAT 355 Homeworks\\twitchdata-update.csv')
summary(twitchData)
attach(twitchData)

#PART 1

#Function to trim outliers from columns
trim <- function(x){
  x[(x > quantile(x, 0.25)-1.5*IQR(x)) & (x < quantile(x, 0.75)+1.5*IQR(x))]
}

#Print summary data of entire dataset
summary(twitchData)

#Watch Time
hist(Watch.time.Minutes., breaks = length(Watch.time.Minutes.)/20,
     main = "Watch Time in Minutes", xlab = "Minutes")
boxplot(Watch.time.Minutes., main = "Boxplot of Watch Time", ylab = "Minutes")

hist(trim(Watch.time.Minutes.), breaks = length(trim(Watch.time.Minutes.))/20, 
     main = "Watch Time in Minutes W/O Outliers", xlab = "Minutes")
boxplot(trim(Watch.time.Minutes.), main = "Boxplot of Watch Time W/O Outliers", ylab = "Minutes")

#Stream Time
hist(Stream.time.minutes., breaks = length(Stream.time.minutes.)/20, 
     main = "Stream Time in Minutes", xlab = "Minutes")
boxplot(Stream.time.minutes., main = "Boxplot of Stream Time", ylab = "Minutes")

hist(trim(Stream.time.minutes.), breaks = length(trim(Stream.time.minutes.))/20, 
     main = "Stream Time in Minutes W/O Outliers", xlab = "Minutes")
boxplot(trim(Stream.time.minutes.), main = "Boxplot of Stream Time W/O Outliers", ylab = "Minutes")

#Peak Viewers
hist(Peak.viewers, breaks = length(Peak.viewers)/20, 
     main = "Count of Peak Viewers", xlab = "Viewers")
boxplot(Peak.viewers, main = "Boxplot of Peak Viewers", ylab = "Count")

hist(trim(Peak.viewers), breaks = length(trim(Peak.viewers))/20, 
     main = "Count of Peak Viewers W/O Outliers", xlab = "Viewers")
boxplot(trim(Peak.viewers), main = "Boxplot of Peak Viewers W/O Outliers", ylab = "Count")

#Average Viewers
hist(Average.viewers, breaks = length(Average.viewers)/20, 
     main = "Count of Average Viewers", xlab = "Viewers")
boxplot(Average.viewers, main = "Boxplot of Average Viewers", ylab = "Count")

hist(trim(Average.viewers), breaks = length(trim(Average.viewers))/20, 
     main = "Count of Average Viewers W/O Outliers", xlab = "Viewers")
boxplot(trim(Average.viewers), main = "Boxplot of Average Viewers W/O Outliers", ylab = "Count")

#Followers
hist(Followers, breaks = length(Followers)/20, 
     main = "Count of Followers", xlab = "Followers")
boxplot(Followers, main = "Boxplot of Followers", ylab = "Count")

hist(trim(Followers), breaks = length(trim(Followers))/20, 
     main = "Count of Followers W/O Outliers", xlab = "Followers")
boxplot(trim(Followers), main = "Boxplot of Followers W/O Outliers", ylab = "Count")

#Followers Gained
hist(Followers.gained, breaks = length(Followers.gained)/20, 
     main = "Number of Followers Gained", xlab = "Followers Gained")
boxplot(Followers.gained, main = "Boxplot of Followers Gained", ylab = "Count")

hist(trim(Followers.gained), breaks = length(trim(Followers.gained))/20, 
     main = "Number of Followers Gained W/O Outliers", xlab = "Followers Gained")
boxplot(trim(Followers.gained), main = "Boxplot of Followers Gained W/O Outliers", ylab = "Count")

#Views Gained
hist(Views.gained, breaks = length(Views.gained)/20, 
     main = "Number of Views Gained", xlab = "Views Gained")
boxplot(Views.gained, main = "Boxplot of Views Gained", ylab = "Count")

hist(trim(Views.gained), breaks = length(trim(Views.gained))/20, 
     main = "Number of Views Gained W/O Outliers", xlab = "Views Gained")
boxplot(trim(Views.gained), main = "Boxplot of Views Gained W/O Outliers", ylab = "Count")

#Partnered
colors = rainbow(2)
partneredData = table(twitchData$Partnered)
barplot(partneredData, col = colors, main = "Partnership status", names.arg = c("Not Partnered", "Partnered"))

partneredData
prop.table(partneredData)

#Mature
matureData = table(twitchData$Mature)
barplot(matureData, col = colors, main = "Maturity Rating", names.arg = c("Family Friendly", "18+"))

matureData
prop.table(matureData)

#Language
languageData = table(twitchData$Language)
barplot(languageData, las=2, col = heat.colors(length(languageData)), main = "Language Spoken")

languageData
prop.table(languageData)



# PART 2

#1
#Find 1st and 3rd quantiles and interquartile range in order to filter original dataset by outliers in Views Gained
Q1 = quantile(twitchData$Views.gained, .25)
Q3 = quantile(twitchData$Views.gained, .75)
IQR = IQR(twitchData$Views.gained)
noOutliersViews = subset(twitchData, twitchData$Views.gained> (Q1 - 1.5*IQR) & twitchData$Views.gained< (Q3 + 1.5*IQR))

boxplot(noOutliersViews$Views.gained~noOutliersViews$Mature, 
        xlab = "Maturity", ylab = "Views Gained", names = c("Family Friendly", "18+"))

#Perform ANOVA
anova = aov(noOutliersViews$Views.gained~as.factor(noOutliersViews$Mature))
summary(anova)

#Find QQnorm plot and line to compare to normal data
qqnorm(anova$residuals)
qqline(anova$residuals)

#2
#Split dataset without outliers into family friendly streamers and mature streamers
sub18 = subset(twitchData, twitchData$Mature == "True")
subFamily = subset(twitchData, twitchData$Mature == "False")

#Perform one sided unpaired t-test
t.test(subFamily$Views.gained, sub18$Views.gained, alternative = 'greater')

#3
#Find 1st and 3rd quantiles and interquartile range in order to filter original dataset by outliers in Followers
Q1 = quantile(twitchData$Followers, .25)
Q3 = quantile(twitchData$Followers, .75)
IQR = IQR(twitchData$Followers)
noOutliersFollowers = subset(twitchData, twitchData$Followers> (Q1 - 1.5*IQR) & twitchData$Followers< (Q3 + 1.5*IQR))

#Split dataset without outliers into streamers that stream in Chinese and streamers that stream in Korean
subChinese = subset(noOutliersFollowers, noOutliersFollowers$Language == "Chinese")
subKorean = subset(noOutliersFollowers, noOutliersFollowers$Language == "Korean")

boxplot(subKorean$Followers, subChinese$Followers, names = c("Korean", "Chinese"), ylab="Follower Count")

#Perform one sided unpaired t-test
t.test(subKorean$Followers, subChinese$Followers, alternative = 'greater')
