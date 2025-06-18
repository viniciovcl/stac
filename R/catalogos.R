

library(rstac)
library(dplyr) #
library(purrr) #
library(knitr)

# 1. Conectar ao catálogo STAC
stac_url <- "https://earth-search.aws.element84.com/v1"
stac_obj <- stac(stac_url)



# O método collections() sem argumentos lista todas as coleções do catálogo raiz
all_collections <- rstac::collections(stac_obj) |>
  get_request()

message(paste("Encontradas", length(all_collections$collections), "coleções."))


# Extrair ID, título e o time-range de cada coleção
collection_data <- map_dfr(all_collections$collections, function(col) {
  collection_id <- col$id
  collection_title <- col$title

  # Inicializa o time_interval para uma mensagem de erro padrão
  time_interval_str <- "N/A (informação temporal ausente ou inválida)"

  # Verifica se extent e o intervalo temporal existem
  if (!is.null(col$extent) && !is.null(col$extent$temporal) && !is.null(col$extent$temporal$interval)) {
    # É possível que 'interval' seja uma lista de listas se houver múltiplos intervalos,
    # ou apenas uma única lista se houver um.
    interval_data <- col$extent$temporal$interval[[1]]

    # Verifica se interval_data é uma lista ou vetor com 2 elementos
    if ((is.list(interval_data) || is.vector(interval_data)) && length(interval_data) == 2) {
      start_time <- interval_data[[1]]
      end_time <- interval_data[[2]]

      # Formata a hora de início
      if (is.null(start_time) || is.na(start_time) || as.character(start_time) == "" || as.character(start_time) == "..") {
        start_time_formatted <- "Início Indefinido"
      } else {
        # Remove a parte da hora se for uma string ISO completa, mantendo apenas a data
        start_time_formatted <- sub("T.*Z$", "", as.character(start_time))
      }

      # Formata a hora de término
      if (is.null(end_time) || is.na(end_time) || as.character(end_time) == "" || as.character(end_time) == "..") {
        end_time_formatted <- "Fim Indefinido"
      } else {
        # Remove a parte da hora se for uma string ISO completa, mantendo apenas a data
        end_time_formatted <- sub("T.*Z$", "", as.character(end_time))
      }

      time_interval_str <- paste(start_time_formatted, "a", end_time_formatted)
    }
  }

  tibble(
    ID_Colecao = collection_id,
    Titulo = collection_title,
    Periodo_Aquisicao = time_interval_str
  )
})

library(stringr)

Algumas_coleções <- collection_data %>%
  mutate(
    num_caracteres_ID_Colecao = nchar(ID_Colecao),
    num_caracteres_Titulo = stringr::str_length(Titulo) # Exemplo com str_length()
  ) %>% filter( num_caracteres_Titulo < 31,
                num_caracteres_ID_Colecao < 26
                ) |> select(-c(num_caracteres_ID_Colecao,
                               num_caracteres_Titulo))


# Definindo os limites de comprimento desejados para cada coluna
limite_id <- 30
limite_titulo <- 30


# Percorrendo as colunas e truncando as strings

Algumas_coleções <- collection_data %>%
  mutate(
    # Trunca 'ID_Colecao' se for maior que 'limite_id'
    ID_Colecao = if_else(
      nchar(ID_Colecao) > limite_id,
      stringr::str_sub(ID_Colecao, 1, limite_id),
      ID_Colecao
    ),

    # Trunca 'Titulo' se for maior que 'limite_titulo'
    Titulo = if_else(
      nchar(Titulo) > limite_titulo,
      stringr::str_sub(Titulo, 1, limite_titulo),
      Titulo
    ),

    # Trunca 'Periodo_Aquisicao' se for maior que 'limite_periodo'
  #   Periodo_Aquisicao = if_else(
  #     nchar(Periodo_Aquisicao) > limite_periodo,
  #     str_sub(Periodo_Aquisicao, 1, limite_periodo),
  #     Periodo_Aquisicao
  #   )

  )

print(Algumas_coleções)



markdown_table <- kable(Algumas_coleções, format = "markdown", align = c('l', 'l', 'l'))
markdown_table


# ---------------------------------------
# Coleções

# stac("https://earth-search.aws.element84.com/v1") %>%
cols <-   stac("https://planetarycomputer.microsoft.com/api/stac/v1/") %>%
  # stac("https://openeo.dataspace.copernicus.eu/openeo/1.2") %>%
  # stac("https://eocat.esa.int/eo-catalogue/") %>%
  # stac("https://earthengine.openeo.org/v1.0/") %>%
    collections() %>%
     get_request()

cols$collections



