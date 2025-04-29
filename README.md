# 🔥 Calculadora de Gasto Calórico

![R](https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white)
![Shiny](https://img.shields.io/badge/Shiny-3776AB?style=for-the-badge&logo=r&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)
![Status](https://img.shields.io/badge/status-Em%20Produção-blue?style=for-the-badge)

---

## Visão Geral

Aplicativo interativo desenvolvido em **Shiny** para calcular o gasto calórico de atividades físicas, com base no peso do usuário, tipo de exercício e tempo de prática. Utiliza modelos de regressão linear para previsões altamente precisas, integrando ciência de dados e interface amigável.

---

## Funcionalidades

- **Cálculo Personalizado**: Estimativas de calorias queimadas para diferentes atividades.
- **Sistema de Recomendação**: Sugestão de exercícios conforme a intensidade desejada (leve, moderado ou intenso).
- **Visualizações Interativas**: Gráficos dinâmicos mostrando a relação entre peso e gasto calórico.
- **Classificação Automática**: Organização de 249 atividades físicas em categorias como Ciclismo, Natação, Corrida, entre outras.

---

## Tecnologias Utilizadas

- **R** — Linguagem principal para análise e modelagem.
- **Shiny** — Framework para construção da aplicação web interativa.
- **Tidyverse** — Manipulação, limpeza e transformação de dados.
- **rvest** — Coleta de dados via web scraping.
- **ggplot2** — Criação de visualizações gráficas informativas.

---

## Estrutura do Projeto

```bash
preditivo_calorico/
├── R/
│   ├── main.Rmd            # Análises principais e construção dos modelos
│   ├── raspagem_dados.Rmd  # Código para raspagem e preparação dos dados
│   └── funcoes.R           # Funções auxiliares e utilitárias
├── datas/
│   ├── dados_raspados.csv  # Dados brutos coletados via web scraping
│   └── dados_limpos.csv    # Dados tratados e prontos para modelagem
├── modelos/
│   ├── modelo_geral.rds    # Modelo geral de previsão
│   └── modelos_calorias.rds # Modelos específicos por atividade
└── app.R                   # Aplicativo Shiny principal
```

---

## Metodologia Científica

- **Modelagem Individualizada**: 249 modelos lineares, um para cada atividade física.
- **Modelo Geral Multivariado**:

```r
calorias ~ peso + atividade + categoria
``` 
---

## Exemplo de uso

Previsão de calorias para uma pessoa de 70 kg praticando ciclismo moderado durante 60 minutos
prever_calorias(
  peso_usuario = 70,
  atividade_usuario = "Cycling, 12-13.9 mph, moderate",
  categoria_usuario = "moderado",
  tempo_minutos = 60
)

---

## 📲 Acesse o Aplicativo

➡️ [Clique aqui para acessar o app online!](https://kaud.shinyapps.io/preditivo_calorico/)

---