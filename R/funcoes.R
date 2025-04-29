# ---- FUNCOES PARA O APP ----

library(tidyverse)

prever_calorias <- function(modelo, dados, peso, atividade, tempo_minutos = 60) {
  # Obter a categoria correspondente à atividade selecionada
  categoria_atividade <- dados %>%
    filter(atividade == atividade) %>%
    pull(categoria) %>%
    first()
  
  nova_obs <- data.frame(
    peso = peso,
    atividade = atividade,
    categoria = categoria_atividade
  )
  
  # Previsão usando o modelo
  caloria_prevista_total <- predict(modelo, newdata = nova_obs)
  
  # Ajusta pelo tempo informado
  caloria_prevista_final <- caloria_prevista_total * (tempo_minutos / 60)
  
  return(caloria_prevista_final)
}

recomendar_atividades <- function(dados, categoria_filtrada = NULL, top_n = 5) {
  dados_filtrados <- dados %>%
    mutate(calorias_por_minuto = caloria / 60) %>%
    filter(peso == 70)  # Peso médio para recomendações
  
  if (!is.null(categoria_filtrada)) {
    dados_filtrados <- dados_filtrados %>%
      filter(categoria == categoria_filtrada)
  }
  
  recomendacoes <- dados_filtrados %>%
    arrange(desc(calorias_por_minuto)) %>%
    distinct(atividade, .keep_all = TRUE) %>%
    slice_head(n = top_n) %>%
    select(atividade, calorias_por_minuto, atividade_micro)
  
  return(recomendacoes)
}