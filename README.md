# Project: Words 4 Music

### [Project Description](doc/Project4_desc.md)

![image](http://cdn.newsapi.com.au/image/v1/f7131c018870330120dbe4b73bb7695c?width=650)

Term: Fall 2016

### Project Goal
+ For each song, we provide recommendations for the lyrics in a way that how likely the lyrics would be in the song. 

### Approach & Methodology
+ The basic approach that I had for this project was finding similarities of the features and since features are the primary factors that determine the characteristics of each song, selecting the features that are relevant was important. I plotted the features to check how they are characterized and to determine which features to use. I mostly extracted their mean, standard deviation, max, and min. 

+ Then, I used the method of recommendation of similarities implying that those features that have high similarities are more likely to share the lyrics. The professor shared the article about recommendations based on similarities and it gave an idea that I could cluster a few similar features and based on these similarities, I could identify their songs and rank the lyrics. Using the training and test dataset from the original 2350 songs, I could check how it relatively performed well by changing the number of songs for grouping. I chose to find 20 highest similarities and ranked the average of their lyrics for each 100 song.





+ [Data link](https://courseworks2.columbia.edu/courses/11849/files/folder/Project_Files?preview=763391)-(**courseworks login required**)
+ [Data description](doc/readme.html)
+ Contributor's name:
+ Projec title: Lorem ipsum dolor sit amet
+ Project summary: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
	
Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file.
