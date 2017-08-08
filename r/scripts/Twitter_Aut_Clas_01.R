library(twitteR)
library(stringr)
library(readr)

api_key <- "YzvurdALnzCmbOs5qo4AF1E7L"
api_secret <- "6YvOK12vapz2X1HcxaghgFyW5utf2nwYTLXJNZOGUoH8Mcc1Dn"
access_token <- "861630364925566976-T5iZdAVl6oU1XMoC7qUi1svWbOToHW9"
access_token_secret <- "71KrpXpvhbCy6bmBuaOTBcJYeDgCKP3mcdDNYvjISnY3d"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)



###########################################
###########################################
###########################################
#   Descargando set para catalogación automática #######
#                                                #######
########################################################
## CARGANDO ARCHIVOS DE FRECUENCIA #######

print("selecciona tu objective file")
freq_objetive <- file.choose()#read.csv("~/freq_objetive.csv")
freq_objetive$X<- NULL
print("selecciona tu others file")
freq_others <- file.choose()#read.csv("~/freq_others.csv")
freq_others$X<-NULL

# GET DATE #
Día <- Sys.Date()
Dia_menos <- Día -1

# Tamaño de muiestra para categorización
no.of.tweets <- 100

#Cadena de búsqueda
string_to_search <- "america"
#Obtención de un set de N tweets
searched_tweets <- searchTwitter(string_to_search, n=no.of.tweets,lan="es",since=as.character(Dia_menos),until=as.character(Día))
#Se generan data frames
tweets_set <-twListToDF(searched_tweets)

#Limpieza de texto
tweets_set$text <- gsub("https:.+?[[:space:]]"," ",tweets_set$text)
tweets_set$text <- gsub("https:.+?$"," ",tweets_set$text)
tweets_set$text <- gsub("https"," ",tweets_set$text)
tweets_set$text <- gsub("á","a",tweets_set$text)
tweets_set$text <- gsub("é","e",tweets_set$text)
tweets_set$text <- gsub("í","i",tweets_set$text)
tweets_set$text <- gsub("ó","o",tweets_set$text)
tweets_set$text <- gsub("ú","u",tweets_set$text)
tweets_set$text <- gsub("ñ","n",tweets_set$text)
tweets_set$text <- sapply(tweets_set$text,function(row) iconv(row, "latin1", "ASCII", sub=""))
tweets_set$text <- gsub("[[:punct:]]|\\n"," ",tweets_set$text)
tweets_set$text <- gsub("\\s\\s+"," ",tweets_set$text)
tweets_set$text <- str_to_lower(tweets_set$text)


write.table(tweets_set,"C:/Users/MIGUEL/Documents/Sublime/python/R/r/output/bank_tweet.txt")

#Contar número de registros en set para prueba
registros_test <- nrow(tweets_set)
#Generación de una matriz de 4xNrows (Cascarón para tabla de tweets clasificados)
cat_new_tweet <- matrix(NA, nrow=registros_test,ncol=4)
#Genera tabal con número de palabras por texto (Considera paralabas alfanuméricas)
words_in_text <- sapply(gregexpr("[[:alnum:]]+", tweets_set$text), function(x) sum(x > 0))
#Generaciónd e un verctor multidimencional para obtener las palabras de un tweet
vector_word=strsplit(tweets_set$text, " ")


#Cliclo for para la generación de una tabla con clasificación de nuevos tweets
for(j in 1:registros_test)
{
  #Se crea una matriz de 3x(número de palabras contenidas en el j tweet) (Cascarón)
  carga_prob <- matrix(NA, nrow=words_in_text[j],ncol=3)
  #Ciclo for para el llenado de matriz que asigna probabilidades a las palabras del tweet j
  for (i in 1:words_in_text[j])
  {
    #Se asigna la palabra i del tweet j para su búsqueda en frecuencias
    Variable_1 <- vector_word[[j]][i]
    #Se obtiene la longitud de la plabra
    largo<-str_length(Variable_1)
    #Se realiza la búsqueda de la palabra en tabla de frecuencia de temática de interés
    prob_word <- freq_objetive[freq_objetive$WORD==Variable_1,colnames(freq_objetive)=="ln_prob"]
    #Se calcula la probabilidad por defecto para palabras no econtradas 1/Total de palabras
    default_prob <- log(1/freq_objetive[1,colnames(freq_objetive)=="total_word"])
    #Se realiza la asignación de probabilidad 0 a las palabras con longitud menor a 3 y se asgina probabilidad con respecto a su búsqueda para el resto
    prob_final<-ifelse(largo<3,0,ifelse(!identical(prob_word,numeric(0)),prob_word,default_prob))
    #Se realiza la búsqueda de la palabra en tabla de frecuencia de otros temas
    prob_word_2 <- freq_others[freq_others$WORD==Variable_1,colnames(freq_others)=="ln_prob"]
    #Se calcula la probabilidad por defecto para palabras no econtradas 1/Total de palabras
    default_prob_2 <- log(1/freq_objetive[1,colnames(freq_objetive)=="total_word"])
    #Se realiza la asignación de probabilidad 0 a las palabras con longitud menor a 3 y se asgina probabilidad con respecto a su búsqueda para el resto
    prob_final_2<-ifelse(largo<3,0,ifelse(!identical(prob_word_2,numeric(0)),prob_word_2,default_prob_2))
    #Se cargan probabilidades para clasificación en matriz
    carga_prob[i,] <- c(Variable_1,as.numeric(prob_final),as.numeric(prob_final_2))
  }
  #De matriz con carga probabilisticas se realiza un volcado de matriz a data frame
  df_n=as.data.frame.vector(carga_prob[,1])
  df_n$prob_1=(as.numeric(carga_prob[,2]))
  df_n$prob_2=(as.numeric(carga_prob[,3]))
  #Se obtiene la probabilidad del tweet completo prob1 <- interés prob2 <- otros temas
  prob1<-sum(df_n$prob_1)
  prob2<-sum(df_n$prob_2)
  #Se realiza la comparación de probabilidades para determinar la categoría del tweet
  flag<-ifelse(prob1>prob2,1,0)
  #Se carga matriz con tweets y sus categorías
  cat_new_tweet[j,]<-c(tweets_set$text[j],as.numeric(prob1),as.numeric(prob2),as.numeric(flag))
}
#Generación de archivo output
write.csv(cat_new_tweet,file="C:/Users/MIGUEL/Documents/Sublime/python/R/r/output/Output_Test_Twitter.csv")
