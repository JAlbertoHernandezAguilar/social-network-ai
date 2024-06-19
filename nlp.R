# Analisis Sentimental usando el diccionario:
#library(rtweet)
library(dplyr)
library(tidytext)

#download.file("https://raw.githubusercontent.com/jboscomendoza/rpubs/master/sentimientos_afinn/lexico_afinn.en.es.csv",
#              "lexico_afinn.en.es.csv")


afinn <- read.csv("lexico_afinn.en.es.csv", stringsAsFactors = F, fileEncoding = "latin1") %>%
  tbl_df()
head(afinn)



rt <- read.csv("Clausura2024.csv", stringsAsFactors = F, fileEncoding = "latin1") %>%
  tbl_df()
head(rt,20)



tuits_afinn <-
  #rt %>%
  unnest_tokens(rt, input = "Mensaje", output = "Palabra") %>%
  mutate(Palabra=tolower(Palabra)) %>%
  inner_join(afinn, ., by = "Palabra",relationship ='many-to-many')

tmls_flw <-
  tuits_afinn %>%
  select(Palabra, Puntuacion)

head(tmls_flw)

tmls_flw$Sentimiento<- ifelse(tmls_flw$Puntuacion>2,"Muy Positivo",0)
tmls_flw$Sentimiento<- ifelse(tmls_flw$Puntuacion>0 & tmls_flw$Puntuacion<3,"Positivo",tmls_flw$Sentimiento)
tmls_flw$Sentimiento<- ifelse(tmls_flw$Puntuacion<0 & tmls_flw$Puntuacion>-3,"Negativo",tmls_flw$Sentimiento)
tmls_flw$Sentimiento<- ifelse(tmls_flw$Puntuacion< -2,"Muy Negativo",tmls_flw$Sentimiento)
head(tmls_flw)

# Conseguimos la participaci?n de cada categia de sentimiento
DatosTabla<-tmls_flw %>%
  group_by(Sentimiento) %>%
  summarise(Numero=n()) %>%
  mutate(Porcentaje=(Numero/sum(.$Numero))*100) %>%
  select(Sentimiento,Porcentaje)
head(DatosTabla)

library(echarts4r)

Plot1<- DatosTabla %>%
  e_charts(Sentimiento) %>%
  e_pie(Porcentaje) %>%
  e_tooltip() %>%
  e_title(" ")
Plot1


# Analizando informacion de usuarios
#rt <- search_tweets("Equipo Pachuca", n = 2000, include_rts = FALSE,token = twitter_token, lang ="es")
DataUsers<- users_data(rt)
names(DataUsers)

Descripcion<- rt %>%
  select(Mensaje) %>%
  distinct()
head(Descripcion)

#Eliminar las descripciones vac?as
Descripcion<-Descripcion %>%
  filter(Mensaje!="")

# Estamos encontrando la frecuencia de uso de cada una de las palabras
Palabras<- Descripcion %>%
  unnest_tokens( input= "Mensaje", output = "Palabra") %>%
  inner_join(afinn, ., by = "Palabra") %>%
  group_by(Palabra) %>%
  summarise(Numero=n()) %>%
  select(Palabra, Numero) %>%
  filter(Palabra!="no")
Palabras

#Hacemos una nube
library(wordcloud2)
wordcloud2(Palabras)
#wordcloud2(Palabras,
           color = ifelse(Palabras[, 2] >= 5, 'red', 'skyblue')

Fuentes<- rt %>%
  select(in_reply_to_screen_name, source) %>%
  distinct() %>%
  group_by(source) %>%
  summarise(Numero=n()) %>%
  arrange(-Numero)
head(Fuentes, 10)

Fuentes %>%
  filter(Numero>=5) %>%
  arrange(Numero) %>%
  e_charts(source) %>%
  e_bar(Numero) %>%
  e_flip_coords() %>%
  e_tooltip()


