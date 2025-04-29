# ---- app.R ----

library(shiny)
library(tidyverse)
library(plotly)
library(shinythemes)
library(shinyjs)

# Carregar o dataset e o modelo
modelo <- read_rds("modelos/modelo_geral.rds")
dados <- read.csv2("datas/dados_limpos.csv")

# Fonte das funções
source("R/funcoes.R")

# ---- UI ----
ui <- fluidPage(
  
  theme = shinythemes::shinytheme("cyborg"),
  
  titlePanel(
    div("Calculadora de Gasto Calórico 🔥", style = "text-align: center; color: white")
  ),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("peso", "Informe seu peso (kg):", value = 70, min = 30, max = 200),
      selectInput("atividade_macro", "Escolha o tipo de atividade:", 
                  choices = unique(dados$atividade_micro)),
      uiOutput("atividade_especifica_ui"),
      numericInput("duracao", "Duração do exercício (minutos):", value = 60, min = 1, max = 300),
      actionButton("calcular", "Calcular Calorias 🔥"),
      br(), br(),
      selectInput("intensidade", "Recomendações de atividades por intensidade:", 
                  choices = c("leve", "moderado", "intenso")),
      actionButton("recomendar", "Recomendar Atividades 🎯")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Previsão de Calorias",
                 h3("Resultado da Previsão:", style = "color: white"),
                 verbatimTextOutput("resultado"),
                 h3("Visualização da Relação Peso x Calorias:", style = "color: white"),
                 plotOutput("grafico_calorias")
        ),
        tabPanel("Recomendações",
                 h3("Atividades Recomendadas:", style = "color: white"),
                 dataTableOutput("tabela_recomendacoes")
        )
      )
    )
  )
)

# ---- SERVER ----
server <- function(input, output, session) {
  
  # Atualizar atividades específicas
  output$atividade_especifica_ui <- renderUI({
    req(input$atividade_macro)
    
    atividades <- dados %>%
      filter(atividade_micro == input$atividade_macro) %>%
      pull(atividade) %>%
      unique()
    
    selectInput("atividade_especifica", "Escolha a atividade específica:",
                choices = atividades)
  })
  
  # Cálculo do gasto calórico
  resultado_calculo <- eventReactive(input$calcular, {
    req(input$peso, input$atividade_especifica, input$duracao)
    
    # Verifica se a função existe
    if(!exists("prever_calorias")) {
      stop("Função 'prever_calorias' não encontrada no arquivo funcoes.R")
    }
    
    prever_calorias(
      modelo = modelo,
      dados = dados,
      peso = input$peso,
      atividade = input$atividade_especifica,
      tempo_minutos = input$duracao
    )
  })
  
  output$resultado <- renderPrint({
    req(resultado_calculo())
    cat("Gasto Calórico Estimado:", round(resultado_calculo(), 2), "kcal 🔥")
  })
  
  # Gráfico de calorias
  output$grafico_calorias <- renderPlot({
    req(input$atividade_macro)
    
    dados_grafico <- dados %>%
      filter(atividade_micro == input$atividade_macro) %>%
      arrange(desc(caloria))
    
    ggplot(dados_grafico, aes(x = reorder(atividade, caloria), y = caloria, fill = categoria)) +
      geom_col() +
      coord_flip() +
      labs(
        title = paste("Gasto Calórico para", input$atividade_macro),
        x = "Atividade",
        y = "Calorias (kcal)",
        fill = "Intensidade"
      ) +
      theme_minimal() +
      theme(
        plot.title = element_text(size = 16, face = "bold", color = "white"),
        axis.title = element_text(color = "white"),
        axis.text = element_text(color = "white"),  # Isso afeta ambos os eixos
        axis.text.y = element_text(color = "white"),  # Especificamente para o eixo Y
        legend.text = element_text(color = "white"),
        legend.title = element_text(color = "white"),
        panel.background = element_rect(fill = "transparent"),
        plot.background = element_rect(fill = "#222222", color = NA),
        panel.grid.major = element_line(color = "gray30"),
        panel.grid.minor = element_line(color = "gray20")
      )
  })
  
  # Recomendações de atividades
  atividades_recomendadas <- eventReactive(input$recomendar, {
    req(input$intensidade)
    recomendar_atividades(dados, input$intensidade)
  })
  
  output$tabela_recomendacoes <- renderDataTable({
    req(atividades_recomendadas())
    atividades_recomendadas()
  }, options = list(pageLength = 5))
}

# Mantém a sessão ativa (executa a cada 5 minutos)
autoRefresh <- reactiveTimer(300000)
observe({
  autoRefresh()
  cat("Keeping alive at", Sys.time(), "\n")
})

# ---- RODAR APP ----
shinyApp(ui = ui, server = server)
