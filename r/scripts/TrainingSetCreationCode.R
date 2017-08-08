library(stringr)#Librería para funciones de tratamiento de String
library(gtools) # if problems calling library, install.packages("gtools", dependencies = T)
library(qdap) # qualitative data analysis package (it masks %>%)
library(tm) # framework for text mining; it loads NLP package
library(twitteR)
api_key <- "YzvurdALnzCmbOs5qo4AF1E7L"
api_secret <- "6YvOK12vapz2X1HcxaghgFyW5utf2nwYTLXJNZOGUoH8Mcc1Dn"
access_token <- "861630364925566976-T5iZdAVl6oU1XMoC7qUi1svWbOToHW9"
access_token_secret <- "71KrpXpvhbCy6bmBuaOTBcJYeDgCKP3mcdDNYvjISnY3d"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)
#Se obtienen los N tweets de una cuenta de twitter en especifico
tweets_training_set <- userTimeline("ClubAmerica", n=1000)
#Creación de data frame con tweets
df_training <- twListToDF(tweets_training_set)
#Obtención de lista de Hashtags
hashtags_list <- str_extract_all(df_training$text, "#\\w+")
#Creación de vector 1
v1 <- c("")
#Ciclo de agregación de hastags a vector 1
for(i in 1:length(hashtags_list)) 
{
  for (j in 1:length(hashtags_list[[i]][]))
  {
    v1 <- append(v1,hashtags_list[[i]][j],after=length(v1))
  }
}
#Eliminación de simbolo # de vector de hashtags
v2 <- gsub("#","",v1)
#Se obtienen los 15 hastags más frecuentes de la cuenta en cuestion
hash_freq <- freq_terms (text.var=v2,top=15)
#Se descargarán n tweets de cada hastag
#número de tweets
num_tweets <- 200
#Se crea una lista de para el almacenamiento de tweets
list_twitter <- list()
#Ciclo for que realiza la descarga de los n tweets que hacen referencia a los hastag más frecuentes
for (i in hash_freq$WORD){
  if(nchar(i) > 5){   #valida la longitud del #hashtag
    hashtags_tweets <-paste("#",i,sep="")
    print(hashtags_tweets)
    list_twitter_temp<-searchTwitter( hashtags_tweets, n=num_tweets,lang='es')
    dat <- twListToDF(list_twitter_temp)
    dat$i <- i
    list_twitter[[i]] <- dat
  }
}
#Se genera data frame con los tweets descargados
big_data <- do.call(rbind, list_twitter)
###
##    summary(big_data$i)
##    distinct(big_data$i)
##    unique(big_data$i)
###
write.csv(big_data,file="archivo_prueba_hash.csv")
