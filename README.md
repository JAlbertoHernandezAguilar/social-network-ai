# social-network-ai
AI techniques applied to analyze social networks

The program is written in R and allows to analyse tweets downloaded from X. The nlp.R programm has been tested in RStudio 2023.12.1+402 "Ocean Storm" Release (4da58325ffcff29d157d9264087d4b1ab27f7204, 2024-01-28) for windows, this program generates two graphs:

1) A pie graph grouping very possitive sentiments, possitive sentiments, neggative sentiments, and very negative sentiments.
2) A tag-cloud with frequent words founded in tweets, the size of the words is proportional to its frequency.

Instructions:

0. Install Rstudio
1. Download nlp.R program
2. Install packages
3. Download example.csv file containing tweets (messages) in working directory. To preserve privacy of users, names and extra information has been deleted.
4. Run the programm
5. Graphs will be shown, first a pie of sentiments, and later the tag cloud.
6. You can change the name of the .csv file to analyse different tweets.

Note: Tweets Downloading can be done using the api of twitter and your credentials.

