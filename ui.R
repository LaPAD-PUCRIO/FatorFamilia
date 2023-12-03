


library(shiny)
library(shinysurveys)
library(readxl)
library(tidyverse)

library(readr)
dt_csv <- read_csv("dt.csv.csv")
View(dt_csv)

# Código para separar as páginas do questionário:
Teste <- dt_csv
nested_questions <- Teste %>% 
  group_by(question) %>% 
  nest() %>%
  ungroup()

nested_questions

multiQuestions <- nested_questions %>%
  mutate(page = c(
    rep(1, 8),
    rep(2, 1),
    rep(3, 10 ),
    rep(4, 9 ),
    rep(5, 9),
    rep(6, 10),
    rep(7, 1),
    rep(8, 7),
    rep(9, 1),
    rep(10, 10),
    rep(11, 1),
    rep(12,10))
    
  )

multiQuestions

multiQuestions <- multiQuestions %>%
  unnest(cols = data)

multiQuestions %>% 
  group_by(page, question) %>% 
  slice_head() %>%
  ungroup() %>%
  select(question, page)



ui <- shiny::fluidPage(
  shinysurveys::surveyOutput(df = multiQuestions,
                             survey_title = "Questionário do Laboratório de Pesquisa em Álcool e Outras Drogas (LaPAD)",
                             survey_description = "serão 4 questionários,
                             sendo respectivamente de: (estigma, ansiedade, saúde, autoestima")
  
  
)

server <- function(input, output, session) {
  shinysurveys::renderSurvey()
}

shiny::shinyApp(ui = ui, server=server)
