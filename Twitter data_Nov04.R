
#Apply for a developer account on Twitter
#Apply for a new webpage to have a webpage address
#WRite application for api_key that sort of information
# In order to not showing the key, and token numbers
# everything has been replaced with empty space
api_key<-''
api_secret<-''
access_token<-'I' 
access_secret<-'' 

# Download package twitteR, and get tweets from Toronto area
# by setting the latitude and altitude , with a 60km radius
# also set the time frame (PS: not used in this version yet)
# tweets9<-searchTwitter('#',n=18000,lang = 'en',since='2019-09-15',until = '2019-10-15',geocode = '43.6532,-79.3832,60km')


# below are examples to get tweets that has hashtags #Toronto
# Though it does not guarantee the tweets were generated from
# Toronto, but this the downloaded tweets were used for testing
# before going for real test with tweets generated from Toronto 

library(twitteR)
setup_twitter_oauth(api_key,api_secret,access_token,access_secret)
tweets<-searchTwitter('#toronto',n=10,lang='en',since='2019-01-01')
tweets1<-searchTwitter('#toronto',n=1000,lang='en',since='2019-01-01')
head(tweets1)


# make the tweets into data frame and turn into csv
df1<-twListToDF(tweets)
df2<-twListToDF(tweets1)
write.csv(df1,file='D:/The Chang School/Project CKME146/tweet1.csv',row.names = F)
write.csv(df2,file='D:/The Chang School/Project CKME146/tweet2.csv',row.names = F)


# create a smaller dataframe with only 150 column of twitter text
# from the original dataframe 2
testDF<-data.frame(df2$text[1:150])
# Check the testing dataframe
str(testDF)
# the column name is df2.text.1.150, so change the column name into "text"
colnames(testDF)<-"text"
#Check the testing frame again
str(testDF)
# This time, we change the column from factor into strings
testDF$text<-as.character(testDF$text)
# Check the column name and class of the column
str(testDF)
# Check number of rows, there are 150 rows in this dataframe
nrow(testDF)

# install packages for tidytext
##install.packages("tidytext")

#Tokenize the text columns in test dataframe
#PS: THis removes the punctuation
#PS2: The output has 1.1, 1.2, ...it means this word is 
#     the first word in column 1, second word in column 1
#PS3: also,make it into a new data frame
#ps4: set to_lower =F to retain the upper case word
library(tidytext)
library(dplyr)
testDF2<-testDF %>%
  unnest_tokens(word, text, to_lower = "F")
#check the row numbers of new dataframe/ ANS:2907
nrow(testDF2)
# Check the type of the column/ ANS: col name:word, CHR type
str(testDF2)

# To learn the most frequent words in testDF2
testDF2 %>%
  count(word, sort = TRUE) 
# the most common word is "RT"(freq=97), then "Toronto" (freq=95)
# stop word needs to be applied

data(stop_words)

testDF3 <- testDF2 %>%
  anti_join(stop_words)
str(testDF3)
testDF3 %>%
  count(word, sort = TRUE)
# Now with the new dataframe, I have RT (freq=97),
# Toronto (freq=95) and https (freq=92)
# top the three most common word in the frame. I need to remove them

testDF4<-testDF3 %>%
  count(word, sort = TRUE) %>%
    filter(n<92)
testDF4
# by checking the list, I realize it's very difficult to see which
# topics people are talking about. I know NFL is definitely one of the
# popular topics in these 150 tweets
# maybe I should make all words lower cases?

#Test 1: check if I have all the words 
# in lower cases will have different results
testDF2_1<-testDF %>%
  unnest_tokens(word, text)
testDF4_1 <- testDF2_1 %>%
  anti_join(stop_words) %>%
  count(word, sort = TRUE) 
# now I have keywords of toronto (freq=106)
# rt(freq=97) and https(freq=92),t.co(freq=91),
# amp(freq=19) I think I am going to remove them

testDF4_2 <-testDF4_1 %>%
              filter(n<19)
# Now I have NFL (I convert nfl back to NFL) as my top one 
# on the list
# "Canada" with freq=15, 11 "fired", 11 "congrats",11 "jasonair'
# 11 "nialofficial", 11 "virginradioto"...
# I have a lot of options
# if I want to do cluster according to topics
#....It seems I need to check if this unigram 
# really tells any story, because what is "fired"?
# and what people are "congratulating"?
# Given that those hashtags were removed but the word followed
# are retained, I am not sure I need to do tokenize unigram
# by retaining the hashtags

# moving on to TF-IDF

