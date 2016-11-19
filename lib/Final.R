rm(list=ls())
setwd()
getwd()
biocLite("rhdf5")
library(rhdf5)
library(matrixStats)
library(lsa)
library(MASS)
source("http://bioconductor.org/biocLite.R")

####list files 
file_list<- list.files(path="./TestSongFile100", pattern=".h5", recursive=T)
orfile_list<- list.files(path="./Project4_data/data", pattern=".h5", recursive=T)
#### Correct the order of the files
split <- strsplit(file_list, "testsong") 
split <- as.numeric(sapply(split, function(x) x <- sub(".h5", "", x[2])))
file_order <- file_list[order(split)]
## Song Id
tt<- read.table("./Project4_data/common_id.txt")

## read all h5 files
orfeat<- vector("list", length(orfile_list))
for (i in 1:length(orfile_list)){
  orfilename<- sprintf("./Project4_data/data/%s", orfile_list[i])
  print(orfilename)
  orfeat[[i]]<-h5read(orfilename, "/analysis")
}

feat<- vector("list", length(file_list))
for (i in 1:length(file_list)){
  filename<- sprintf("./TestSongFile100/%s", file_order[i])
  print(filename)
  feat[[i]]<-h5read(filename, "/analysis")
}


#lyr data
load("./Project4_data/lyr.rdata")

#####original data feature extraction
orfeatures<- matrix(data=NA, nrow=length(orfeat), ncol=22)
system.time(for (i in 1:length(orfeat)){
  orfeatures[i,]<- c(
    mean(orfeat[[i]]$segments_loudness_max),
    max(orfeat[[i]]$segments_loudness_max),
    min(orfeat[[i]]$segments_loudness_max),
    sd(orfeat[[i]]$segments_loudness_max),
    mean(orfeat[[i]]$tatums_confidence),
    max(orfeat[[i]]$tatums_confidence),
    median(orfeat[[i]]$tatums_confidence),
    mean(orfeat[[i]]$bars_start),
    max(orfeat[[i]]$bars_start),
    min(orfeat[[i]]$bars_start),
    median(orfeat[[i]]$bars_start),
    mean(orfeat[[i]]$segments_pitches),
    median(orfeat[[i]]$segments_pitches),
    mean(orfeat[[i]]$segments_timbre),
    max(orfeat[[i]]$segments_timbre),
    min(orfeat[[i]]$segments_timbre),
    sd(orfeat[[i]]$segments_timbre),
    mean(orfeat[[i]]$sections_start),
    max(orfeat[[i]]$sections_start),
    median(orfeat[[i]]$sections_start),
    mean(orfeat[[i]]$beats_confidence),
    median(orfeat[[i]]$beats_confidence)
  )
})

##### test data feature extraction
features<- matrix(data=NA, nrow=length(feat), ncol=22)
system.time(for (i in 1:length(feat)){
  features[i,]<- c(
    mean(feat[[i]]$segments_loudness_max),
    max(feat[[i]]$segments_loudness_max),
    min(feat[[i]]$segments_loudness_max),
    sd(feat[[i]]$segments_loudness_max),
    mean(feat[[i]]$tatums_confidence),
    max(feat[[i]]$tatums_confidence),
    median(feat[[i]]$tatums_confidence),
    mean(feat[[i]]$bars_start),
    max(feat[[i]]$bars_start),
    min(feat[[i]]$bars_start),
    median(feat[[i]]$bars_start),
    mean(feat[[i]]$segments_pitches),
    median(feat[[i]]$segments_pitches),
    mean(feat[[i]]$segments_timbre),
    max(feat[[i]]$segments_timbre),
    min(feat[[i]]$segments_timbre),
    sd(feat[[i]]$segments_timbre),
    mean(feat[[i]]$sections_start),
    max(feat[[i]]$sections_start),
    median(feat[[i]]$sections_start),
    mean(feat[[i]]$beats_confidence),
    median(feat[[i]]$beats_confidence)
  )
})
ordata_feature<- cbind(orfile_list, orfeatures)
data_feature<- cbind(file_order, features)

##### Switch song column as row names
cordata_feature<- ordata_feature[,-1]
rownames(cordata_feature)<- ordata_feature[,1]
cdata_feature<- data_feature[,-1]
rownames(cdata_feature)<- data_feature[,1]

##### clean NA and -inf
for(i in 1:ncol(cdata_feature)){
  cdata_feature[is.infinite(cdata_feature[,i]),i]<- max(replace(cdata_feature[,i], is.infinite(data_feature[,i]), NA), na.rm=TRUE)
  cdata_feature[is.na(cdata_feature[,i]), i] <- mean(cdata_feature[,i], na.rm = TRUE)
}

##### split dataset
#set.seed(100)
#cinTraining <- createDataPartition(cdata_feature[,2], p = 0.8, list = FALSE)
#ctraining <- cdata_feature[cinTraining,]
#ctesting  <- cdata_feature[-cinTraining,]

training<- orfeatures
testing<- features

##### similarity test
similarity<- cosine(cbind(t(ctraining), t(ctesting)))
cut<-similarity[1:(dim(ctraining)[1]),(dim(ctraining)[1]+1):(dim(ctraining)[1]+dim(ctesting)[1])]

similarity<- cosine(cbind(t(training), t(testing)))
cut<-similarity[1:(dim(training)[1]),(dim(training)[1]+1):(dim(training)[1]+dim(testing)[1])]

##### rank the words
cdf<- lyr[,-1]
rownames(cdf)<- lyr[,1]
df1<- lyr[, -(2:3), drop=FALSE]
df<- df1[, -(4:28), drop=FALSE]
rownames(df)<- df[,1]
df<- df[,-1]
rank_list<- vector("list", ncol(cut))
for(i in 1:ncol(cut)){
  rank_list[[i]]<- which.max(cut[,i])
}

##### max rank (not used for the final product)
rank_words<- matrix(data=NA, nrow= ncol(cut), ncol= ncol(df))
for(i in 1:ncol(cut)){
  rank_words[i,]<-rank(-df[rank_list[[i]],], ties.method = c("average"))
}
final_rank<- cbind(file_order, rank_words)
write.csv(final_rank, file="Submission.csv")

##### rank based on 30 most similar features
rank_feature.20<- matrix(data=NA, nrow= ncol(cut), ncol= ncol(df))
system.time(for (i in 1:dim(cut)[2]){
  lab_row<-which(cut[,i]%in%sort(cut[,i],decreasing=T)[1:20])
  rank_feature.20[i,]<-rank(-colMeans(df[lab_row,])) 
})
final_rank.20<- cbind(file_order, rank_feature.20)
write.csv(final_rank.20, file="Submission_hc2850.csv")
