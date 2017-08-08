require(readr)#Librería para la carga de archivos en DF
require(stringr)#Librería para funciones de tratamiento de String
require(gtools) # if problems calling require, install.packages("gtools", dependencies = T)
require(qdap) # qualitative data analysis package (it masks %>%)
require(tm) # framework for text mining; it loads NLP package
#Tomando anrchivo con ejemplos previamente catalogados
freq_objetive <- file.choose()#read.csv("~/TweetAme500.csv")
freq_objetive$X<- NULL
#Flitro tweets de interés y de otros temas
print("aqui")
objetive_topic_set<- input_twets[input_twets$flag==1,1]
print("aqui2")
others_topic_set <- input_twets[input_twets$flag==0,1]
#Generar un corpus con los set de interés y otros temas
#corpus_objetive <- Corpus(VectorSource(objetive_topic_set$text))
#corpus_others <- Corpus(VectorSource(others_topic_set$text))
#Separa palabras por frecuencia
#tdm_objetive <- TermDocumentMatrix(corpus_america)
#Genera tablas de frecuencia por palabra por temática
freq_objetive <- freq_terms(text.var = objetive_topic_set$text, top=Inf) # find the N most frequent words
freq_others <- freq_terms(text.var = others_topic_set$text, top=Inf) # find the N most frequent words
#Obtengo lista de palabras clave para tweets de interés
tokens_objetive <- read_csv("C:/Users/luis_/Documents/R/Scripts/ObjetiveTopic.txt")
#Obtengo lista de palabras clave para tweets de otros temas
tokens_others <- read_csv("C:/Users/luis_/Documents/R/Scripts/OthersTopic.txt")
#Tomamos el máximo de frequencias
objective_max_f <- max(freq_objetive$FREQ)
others_max_f <- max(freq_others$FREQ)
#Agregando frecuencias a palabras clave de tema objetivo
for (i in tokens_objetive$text)
{
  a <- which(freq_objetive$WORD==i, arr.ind=TRUE)
  ifelse(identical(a,integer(0)),
         #print("agregacion")
         freq_objetive <- rbind(freq_objetive,c(i,objective_max_f+1))
         ,
         #print("asignacion")
         freq_objetive[a,2] <- objective_max_f + 1
         )
}
#Agregando frecuencias a palabras clave de otros temas
for (i in tokens_others$text)
{
  a <- which(freq_others$WORD==i, arr.ind=TRUE)
  ifelse(identical(a,integer(0)),
         #print("agregacion")
         freq_others <- rbind(freq_others,c(i,others_max_f+1))
         ,
         #print("asignacion")
         freq_others[a,2] <- objective_max_f + 1
  )
}
#Se suma una unidad para contemplar la existencia de palabras raras
freq_objetive$FREQ_1 <- as.numeric(freq_objetive$FREQ)+1
freq_others$FREQ_1 <- as.numeric(freq_others$FREQ)+1
#Se crea columna con palabras totales
freq_objetive$total_word <- sum(freq_objetive$FREQ_1)
freq_others$total_word <- sum(freq_others$FREQ_1)
#Se calculan probabilidades
freq_objetive$prob <- freq_objetive$FREQ_1/freq_objetive$total_word
freq_others$prob <- freq_others$FREQ_1/freq_others$total_word
#Logaritmo natural a probabilidades
freq_objetive$ln_prob <- log(freq_objetive$prob)
freq_others$ln_prob <- log(freq_others$prob)
#Creación de archivos de frecuencia
write.csv(freq_objetive,file="freq_objetive.csv")
write.csv(freq_others,file="freq_others.csv")



