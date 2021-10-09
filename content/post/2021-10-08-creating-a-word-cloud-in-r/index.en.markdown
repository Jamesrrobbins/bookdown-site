---
title: Creating a word cloud in R
author: James Robbins
date: '2021-10-08'
slug: creating-a-word-cloud-in-r
categories:
  - R
  - programming
tags:
  - R
  - programming
subtitle: ''
summary: ''
authors: []
lastmod: '2021-10-08T16:09:00+01:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---

<script src="{{< blogdown/postref >}}index.en_files/htmlwidgets/htmlwidgets.js"></script>

<link href="{{< blogdown/postref >}}index.en_files/wordcloud2/wordcloud.css" rel="stylesheet" />

<script src="{{< blogdown/postref >}}index.en_files/wordcloud2/wordcloud2-all.js"></script>

<script src="{{< blogdown/postref >}}index.en_files/wordcloud2/hover.js"></script>

<script src="{{< blogdown/postref >}}index.en_files/wordcloud2-binding/wordcloud2.js"></script>

<script src="{{< blogdown/postref >}}index.en_files/htmlwidgets/htmlwidgets.js"></script>

<link href="{{< blogdown/postref >}}index.en_files/wordcloud2/wordcloud.css" rel="stylesheet" />

<script src="{{< blogdown/postref >}}index.en_files/wordcloud2/wordcloud2-all.js"></script>

<script src="{{< blogdown/postref >}}index.en_files/wordcloud2/hover.js"></script>

<script src="{{< blogdown/postref >}}index.en_files/wordcloud2-binding/wordcloud2.js"></script>

As part of a recent questionnaire (see https://www.jamesrobbins.org/post/calling-all-vessel-crews-and-managers-exploring-collisions-with-marine-wildlife-and-potential-solutions/), I was tasked with dealing with free text responses relating to challenges to conservation. To help get a sense of common words, I decided to create a word cloud using R. Thankfully Céline Van den Rul posted an excellent article on the subject, available here: https://towardsdatascience.com/create-a-word-cloud-with-r-bde3e7422e8a

In this post, I will share my approach using wordcloud2.

Lets start with some data. In reality, I’m pulling responses from a google sheet with local authorisation tokens and processing from there, but for this post we will use some dummy data.

First lets load our libraries.

``` r
suppressPackageStartupMessages({
 
library(wordcloud2) #For the word clouds
library(tm) #To get the text into manageable formats
library(tidyverse) #For helpful pipes
})
```

Now we will create some dummy data. Lets pretend we have a few responses from our questionnaire about the greatest challenges to stopping collisions between ships and animals at sea.

``` r
text <-  c("Education of water users",
                            "Knowing the risks",
                            "Lack of enforcement",
                            "Risks are uncertain",
                            "Difficult to identify issue at time",
                            "Sometimes knowledge is lacking",
                            "Enforcement",
                            "Education"
                            )
```

So we have our responses, but we need to get it into a format that is useable for word clouds, and remove characters that we don’t want (numbers, punctuation and extra spaces). We also want to ensure all of the words are in lower case, so that duplicate words are counted even if they are typed with capitals or not.

``` r
docs <- Corpus(VectorSource(text))
docs <- docs %>%
  tm_map(removeNumbers) %>%
  tm_map(removePunctuation) %>%
  tm_map(stripWhitespace)
docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs, removeWords, stopwords("english"))
dtm <- TermDocumentMatrix(docs) 
matrix <- as.matrix(dtm) 
words <- sort(rowSums(matrix),decreasing=TRUE) 
df <- data.frame(word = names(words),freq=words)
```

We now have some text which has been split up into individual words that are clean, and we have counted the number of occurrence of each word. Lets have a look.

``` r
head(df)
```

    ##                    word freq
    ## education     education    2
    ## risks             risks    2
    ## enforcement enforcement    2
    ## users             users    1
    ## water             water    1
    ## knowing         knowing    1

Brilliant. The last step is to make our wordcloud, using wordcloud2.

``` r
challenge_cloud <- wordcloud2(data=df, size=0.2, color='random-dark',backgroundColor="white", shape = 'circle')

challenge_cloud #Plot the wordcloud
```

<div id="htmlwidget-1" style="width:672px;height:480px;" class="wordcloud2 html-widget"></div>
<script type="application/json" data-for="htmlwidget-1">{"x":{"word":["education","risks","enforcement","users","water","knowing","lack","uncertain","difficult","identify","issue","time","knowledge","lacking","sometimes"],"freq":[2,2,2,1,1,1,1,1,1,1,1,1,1,1,1],"fontFamily":"Segoe UI","fontWeight":"bold","color":"random-dark","minSize":0,"weightFactor":18,"backgroundColor":"white","gridSize":0,"minRotation":-0.785398163397448,"maxRotation":0.785398163397448,"shuffle":true,"rotateRatio":0.4,"shape":"circle","ellipticity":0.65,"figBase64":null,"hover":null},"evals":[],"jsHooks":{"render":[{"code":"function(el,x){\n                        console.log(123);\n                        if(!iii){\n                          window.location.reload();\n                          iii = False;\n\n                        }\n  }","data":null}]}}</script>

We can play around with the colour scheme and aesthetics until we like it.

``` r
challenge_cloud2 <- wordcloud2(data=df, size=0.5, color='random-dark',backgroundColor="black", shape = 'circle')

challenge_cloud2 #Plot the wordcloud
```

<div id="htmlwidget-2" style="width:672px;height:480px;" class="wordcloud2 html-widget"></div>
<script type="application/json" data-for="htmlwidget-2">{"x":{"word":["education","risks","enforcement","users","water","knowing","lack","uncertain","difficult","identify","issue","time","knowledge","lacking","sometimes"],"freq":[2,2,2,1,1,1,1,1,1,1,1,1,1,1,1],"fontFamily":"Segoe UI","fontWeight":"bold","color":"random-dark","minSize":0,"weightFactor":45,"backgroundColor":"black","gridSize":0,"minRotation":-0.785398163397448,"maxRotation":0.785398163397448,"shuffle":true,"rotateRatio":0.4,"shape":"circle","ellipticity":0.65,"figBase64":null,"hover":null},"evals":[],"jsHooks":{"render":[{"code":"function(el,x){\n                        console.log(123);\n                        if(!iii){\n                          window.location.reload();\n                          iii = False;\n\n                        }\n  }","data":null}]}}</script>
