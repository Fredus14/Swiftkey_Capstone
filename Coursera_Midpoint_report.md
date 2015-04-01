---
title: "Coursera_Capstone_Midpoint_report"
author: "Ben Apple"
date: "Wednesday, March 25, 2015"
output: html_document
---

```{r echo=FALSE, message=FALSE}
setwd("D:/RFiles/Capstone_Bapple")
suppressWarnings(require(tm)); suppressWarnings(require(SnowballC)); suppressWarnings(require(data.table)); suppressWarnings(require(ggplot2)); suppressWarnings(require(RWeka)); suppressWarnings(require(qdap)); suppressWarnings(require(scales)); suppressWarnings(require(gridExtra)); suppressWarnings(require(wordcloud)); suppressWarnings(require(reshape2))
source('./SwiftKey-Natural-Language-master/func/Task_1.5_Tokenization_func.R')
```

### Introduction
This report is a breif description of the data provided for the Coursera Capstone SwiftKey NLP project.

The goal of this project is to make use of NLP techniques to build an R environment. The environment will be trained by a sample of a larger data set thathas been developed from the raw text files  provided by Coursera. The finlae goal is to produce an application that recomends the next word in a user entered string of words. 

In this report, the steps taken to preparse the text such as preprocess of raw text, preliminary statistics/visualization analysis, plans for algorithm and applications are introduced in order to provide readers with an idea of the scope of the project.

##Initial Data
The initial data is received in the form of three raw text files commonly refered to as the corpora of the NLP project.  All three files are in english, the first corpus contains text from twitter, the second text from various blogs and the third from various news sources.  Some basic feedback and differences between the raw files can be seen in the following tables. In the remainder of this report we will refer to the files as the corpura or corpus.

Corpus  | Number of Entries|
--------|------------------|
Twitter |  2360148         |
Blogs   |  899288          |
News    |  1010242         |

Corpus  | Number of Words   |
--------|--------------------
Twitter | 30417180          |
Blogs   | 37592702          |
News    | 34626812          |

Corpus  | Average Words per Entry |
--------|-------------------------
Twitter | `r 30417180/2360148`    |
Blogs   | `r 37592702/899288`     |
News    | `r 34626812/1010242`    |

As you can see, there is quite a bit of difference between the three corpus.  The following plot compares the percentage of total words used in each corpus to the percentage of unique words in the corpus.  Then we will look at possible sample sizes that we can pull from the large corpus.

```{r, echo = FALSE, fig.width=8, fig.height=8}
exPlot <- read.csv("D:/RFiles/Capstone/Coursera-SwiftKey/final/en_US/exPlot.csv")
ggplot() + geom_line(data=exPlot, aes(x=newsP, y=newsC, color = "blue")) + geom_line(data=exPlot, aes(x=blogsP, y=blogsC, color="purple")) + geom_line(data=exPlot, aes(x=twitterP, y=twitterC, color="yellow")) + xlab("Percentage of Words in Corpus") + ylab("Percentage of Word Counts in Corpus") + ggtitle("Comparison of How Many Words are Required to Capture a Corpus") + scale_color_discrete(name="Corpus", labels=c("News", "Blogs", "Twitter"))
```

As can be seen from the plot, approximately 90% of the total words within each corpus can be expressed with only approximately 10% of the words in each corpus.  While there are some differences between each corpus, a relatively small number of words can be leveraged to express a majority of the language.  A small dictionary of words will allow us to use less memory in the implementation of the system.

### Preprocess
The preprocess for text mining mainly includes cleaning, tokenization and stemming. These steps are intended to clean the raw text documents provided and transfer the documents into a form which can easily be used for further analysis . To be more specific, the following issues in text documents will be resolved during preprocess:

- Capital/Lower case
- Numbers
- Punctuations
- Whitespace
- Profanity words
- Special notation/Noise like mistypes, UTF-16 encoded characters, foreign words, etc.


We can notice some differences in the langauge used between each corpus.  Looking at the plot below, we can get of an idea of the type of english used within each corpus.  For instance, if a document contains the word "said" it is very likely to be a news source.  Where as if a document includes "your", "me", or "my" it is unlikely to be a news source.  Keep in mind that the chart below is based on the top word counts and thus should only be used as a relative measure.

```{r, echo=FALSE, fig.width=10, fig.height=8}
twDFmelt2 <- read.csv("D:/RFiles/Capstone/Coursera-SwiftKey/final/en_US/twDFmelt2.csv")

ggplot(twDFmelt2, aes(x=words, y=value, fill=variable),  color = c("purple", "blue", "yellow")) + geom_histogram(stat="identity", position = "dodge") + xlab("Word") + ylab("Percentage of Total Usage") + scale_color_discrete(name = "Corpus", labels = c("Blogs", "News", "Twitter")) + ggtitle("Top Word Count")

```


A tokenization process has been constructed to resolve the above issues. The following is an output of applying this function to the corpus.
 
```{r echo=FALSE}
setwd('D:/RFiles/Capstone_Bapple')
en_US <- file.path('.','SwiftKey-Natural-language-master','Other','en_US_s')
en_US.document <- Corpus(DirSource(en_US, encoding="UTF-8"), 
                         readerControl = list(reader = readPlain,language = "en_US",load = TRUE))
docs <- en_US.document
trans <- c(F,T,T,T,F,F,T,T)
ChartoSpace <- c('/','\\|')
stopWords <- 'english'
ownStopWords <- c()
swearwords <- read.table('./SwiftKey-Natural-language-master/profanity filter/en', sep='\n')
names(swearwords)<-'swearwords'
filter <- rep('***', length(swearwords))
profanity <- data.frame(swearwords, target = filter)
profanity <- rbind(profanity, data.frame(swearwords = c("[^[:alpha:][:space:]']","â ","ã","ð"), target = c(" ","'","'","'")))
tokenized_docs <- tokenization(docs, trans, ChartoSpace, stopWords, ownStopWords, profanity)
```

Stemming is applied to the corpus post tokenization to remove common word endings for English words, such as "es", "ed" and "s". 

```{r echo=FALSE}
stem_docs <- tm_map(tokenized_docs, stemDocument, 'english') # SnowballStemmer
```

At this stage we have compltetd the basic cleaning/transformation steps for the raw text that make up our corpus. We will do some preliminary statistics analysis and data visualisation to corpus.

### Basic Statistics/Visualization
In this part, we will do some basic statistics analysis and data visualization on our corpus. 
In the sections above, we explored the total lines and number of words in each document. Now we convert our text corpus into a matrix based on different ngrams and figure out the frequency and correlation between different words. 

##### Terms frequency

```{r echo=FALSE, warning=FALSE, fig.width=9, fig.height=6}
setwd('D:/RFiles/Capstone_Bapple')
rm(list=ls(all=TRUE))
load('./SwiftKey-Natural-language-master/Other/wf_alltoken.RData')
ggplot(wf_alltoken,aes(x=word,y=freq)) + 
    geom_bar(stat='identity',color='grey60',fill='#56B4E9') + facet_wrap(~ngrams, scales = "free", ncol=1,nrow=4) + 
    xlab('Terms')+ylab('Frequency') + theme(legend.position='none', axis.title.x = element_text(size=3), axis.title.y = element_text(size=3), axis.text.x  = element_text(angle=45, hjust=1)) + 
    theme_bw() + geom_text(aes(label=format(freq,big.mark=",")),size=3 ,labels=comma,vjust=-0.2)
```
```{r echo=FALSE, warning=FALSE, fig.width=9, fig.height=3}
setwd('D:/RFiles/Capstone_Bapple')
rm(list=ls(all=TRUE));par(mfrow=c(1,4))
load('./SwiftKey-Natural-language-master/Other/freq_onetoken.RData')
load('./SwiftKey-Natural-language-master/Other/freq_bitoken.RData')
load('./SwiftKey-Natural-language-master/Other/freq_tritoken.RData')
load('./SwiftKey-Natural-language-master/Other/freq_quatrtoken.RData')
library(wordcloud)
set.seed(2000)
wordcloud(names(freq_onetoken), freq_onetoken, min.freq=40, colors=brewer.pal(6, 'Dark2'), rot.per=.2)
wordcloud(names(freq_bitoken), freq_bitoken, min.freq=15, colors=brewer.pal(6, 'Dark2'), rot.per=.2)
wordcloud(names(freq_tritoken), freq_tritoken, min.freq=4, colors=brewer.pal(6, 'Dark2'), rot.per=.2)
wordcloud(names(freq_quatrtoken), freq_quatrtoken, min.freq=3, colors=brewer.pal(6, 'Dark2'), rot.per=.2)
```

Okay Now we are going to have some fun with Word Coluds. The use of wordcloud diagrams give us some insight into the frequency of 1,2,3,4 grams terms while the below bar charts also display top frequent terms of our corpus in more traditional view. 

### More Frequency Analysis
#### Word frequency distribution
```{r echo=FALSE, warning=FALSE, fig.width=9, fig.height=3}
setwd('D:/RFiles/Capstone_Bapple')
rm(list=ls(all=TRUE))
load('SwiftKey-Natural-language-master/Other/wf_onetoken.RData')
load('SwiftKey-Natural-language-master/Other/wf_bitoken.RData')
load('SwiftKey-Natural-language-master/Other/wf_tritoken.RData')
load('SwiftKey-Natural-language-master/Other/wf_quatrtoken.RData')
par(mfcol = c(1,4))
hist(log10(table(wf_onetoken[,2])), xlab="", col = "#56B4E9", 
     ylab="Number of words", main = "1-gram")
hist(log10(table(wf_bitoken[,2])), xlab="Word frequency in corpus  (log10)", col = "#56B4E9", 
     ylab="", main = "2-grams")
hist(log10(table(wf_tritoken[,2])), xlab="", col = "#56B4E9", 
     ylab="", main = "3-grams")
hist(log10(table(wf_quatrtoken[,2])), xlab="", col = "#56B4E9", 
     ylab="", main = "4-grams")
load('SwiftKey-Natural-language-master/Other/sparcity_all.RData')
sparcity_all
rm(list=ls(all=TRUE))
```

We can see in the above plots and table how many words it would take to reach 50% and 90% coverage in our 1-4 grams models.<br>
For example, 124 words are needed to account for 50% of the entire Unigram corpora and 2783 words are needed to account for 90% of the entire Unigram corpora. These numbers are reflected in the one-word sample corpus.

### Finale Application
This report is intended to show that we have retrieved, explored, cleaned, and prepared the text for the actual goal of the capstone. This goal is to develop an application with user-friendly interface. Then release that application on a Shiny server. Considering shear size of the corpus the application must take the size and speed of model into account. 

The main functions that will be included in finale Shiny app:

- Detecting the nearest 1 to 3 words of users' typing and taking them as the inputs of model. 
- Return the predictions of model to the user interface.

