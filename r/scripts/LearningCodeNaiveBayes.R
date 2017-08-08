library(stringr)
library(readr)
library(gtools)
library(qdap)
library(tm)

#Se leé el archivo que arroja la categorización automática y que ya ha sido supervisado
input_set <- read_csv("~/Output_Test_Twitter.csv")

#Se separa el archivo por temas de interés
objetive_topic<- input_set[input_set$V4==1,2]
others_topic <- input_set[input_set$V4==0,2]
#Se obtienen las frecuencias de palabras los temas de interés
freq_obj <- freq_terms(text.var = objetive_topic$V1, top=Inf) # find the N most frequent words
freq_oth <- freq_terms(text.var = others_topic$V1, top=Inf) # find the N most frequent words
#Se leén los archivos de frecuencia actuales
freq_objetive <- read.csv("~/freq_objetive.csv",stringsAsFactors=FALSE)
freq_others <- read.csv("~/freq_others.csv",stringsAsFactors=FALSE)
#Obtención de los registros de frecuencias actuales, sólo word y freq
freq_objetive_new <- freq_objetive[,2:3]
freq_others_new <- freq_others[,2:3]
#Se verifica la existencia de palabras en temas de interés, se adiciona la frecuencia para existentes y se agregan palabras nuevas
for (i in freq_obj$WORD)
{
  a <- which(freq_objetive_new$WORD==i, arr.ind=TRUE)
  ifelse(identical(a,integer(0)),
         #print("agregacion")
         freq_objetive_new <- rbind(freq_objetive_new,c(i,freq_obj$FREQ[freq_obj$WORD==i]))
         ,
         #print("asignacion")
         freq_objetive_new[a,2] <- (as.numeric(freq_objetive_new[a,2]) + freq_obj$FREQ[freq_obj$WORD==i])
  )
}
#Se verifica la existencia de palabras en otros temas, se adiciona la frecuencia para existentes y se agregan palabras nuevas
for (i in freq_oth$WORD)
{
  a <- which(freq_others_new$WORD==i, arr.ind=TRUE)
  ifelse(identical(a,integer(0)),
         #print("agregacion")
         freq_others_new <- rbind(freq_others_new,c(i,freq_oth$FREQ[freq_oth$WORD==i]))
         ,
         #print("asignacion")
         freq_others_new[a,2] <- (as.numeric(freq_others_new[a,2]) + freq_oth$FREQ[freq_oth$WORD==i])
  )
}

#Se suma una unidad para contemplar la existencia de palabras raras
freq_objetive_new$FREQ_1 <- as.numeric(freq_objetive_new$FREQ)+1
freq_others_new$FREQ_1 <- as.numeric(freq_others_new$FREQ)+1
#Se crea columna con palabras totales
freq_objetive_new$total_word <- sum(freq_objetive_new$FREQ_1)
freq_others_new$total_word <- sum(freq_others_new$FREQ_1)
#Se calculan probabilidades
freq_objetive_new$prob <- freq_objetive_new$FREQ_1/freq_objetive_new$total_word
freq_others_new$prob <- freq_others_new$FREQ_1/freq_others_new$total_word
#Logaritmo natural a probabilidades
freq_objetive_new$ln_prob <- log(freq_objetive_new$prob)
freq_others_new$ln_prob <- log(freq_others_new$prob)
#Creación de NUEVOS archivos de frecuencia
write.csv(freq_objetive_new,file="freq_objetive.csv")
write.csv(freq_others_new,file="freq_others.csv")

