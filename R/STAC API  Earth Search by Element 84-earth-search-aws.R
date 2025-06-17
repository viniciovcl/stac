

#-------------------------------------------------------------------------------
# Catálogo: Earth Search by Element 84 (earth-search-aws)
#
# Recupera conjuntos de dados do catálogo Earth Search by Element 84 <earth-search-aws>
# usando api STAC (rstac).
#
# Cria uma coleção (Image_Collection) spatio-temporal para que a coleção possa
# ser tratada como um cubo de dados (gdalcubes) para análise de séries temporais.
#
# O cubo de dados criado pode ser exportado para o formato NetCDF (mantendo a
# estrutura espaço temporal) ou GeoTIFF.
#
# Autor: Vinicio Lima
# Data: 13-06-2025
#
#-------------------------------------------------------------------------------


   ____ _____  __   _____
  / ___|_   _|/ \  / ___|
  \___ \ | | / _ \| |
   ___) || |/ ___ \ |___
  |____/ |_/_/   \_\____|


# A STAC API of public datasets on AWS
# Colletcions Earth Search by Element 84 <earth-search-aws>

# Collections

# |ID_Colecao            |                     Titulo                      |Periodo_Aquisicao           |
# |:---------------------|:-----------------------------------------------:|:---------------------------|
# |sentinel-2-pre-c1-l2a |      Sentinel-2 Pre-Collection 1 Level-2A       |2015-06-27 a Fim Indefinido |
# |cop-dem-glo-30        |              Copernicus DEM GLO-30              |2021-04-22 a 2021-04-22     |
# |naip                  |   NAIP: National Agriculture Imagery Program    |2010-01-01 a 2022-12-31     |
# |cop-dem-glo-90        |              Copernicus DEM GLO-90              |2021-04-22 a 2021-04-22     |
# |landsat-c2-l2         |          Landsat Collection 2 Level-2           |1982-08-22 a Fim Indefinido |
# |sentinel-2-l2a        |               Sentinel-2 Level-2A               |2015-06-27 a Fim Indefinido |
# |sentinel-2-l1c        |               Sentinel-2 Level-1C               |2015-06-27 a Fim Indefinido |
# |sentinel-2-c1-l2a     |        Sentinel-2 Collection 1 Level-2A         |2015-06-27 a Fim Indefinido |
# |sentinel-1-grd        | Sentinel-1 Level-1C Ground Range Detected (GRD) |2014-10-10 a Fim Indefinido |




library(rstac)
library(httr)
library(sf)
library(dplyr)

# URL base da STAC API da MPC
stac_obj <- stac("https://earth-search.aws.element84.com/v1")
rstac::get_request(stac_obj )

collections_query <- stac_obj|>
  rstac::collections()

class(stac_obj)
class(collections_query)

available_collections <- rstac::get_request(collections_query)
available_collections

# AOI

bb <- c(
  xmin = -51.8100,
  ymin = -20.8000,
  xmax = -51.7500,
  ymax = -20.7600
)

aoi_polygon <- st_as_sfc(st_bbox(bb), crs = 4326)
aoi_sf <- st_as_sf(aoi_polygon, crs = 4326)
# mapview::mapview(aoi_sf)
# aoi_sf |> dplyr::mutate(Area = st_area(st_geometry(aoi_sf$x))/10000)

aoi_sf |>
  st_transform("EPSG:31982") |>
  st_bbox() -> bbox_sirg_utm

aoi_sf |>
  st_transform("EPSG:4326") |>
  st_bbox() -> bbox_wgs84
bbox_wgs84



library(rstac)
s = stac("https://earth-search.aws.element84.com/v1")
items = s |>
  stac_search(collections = "sentinel-2-l2a",
              bbox = c(bbox_wgs84["xmin"],bbox_wgs84["ymin"],
                       bbox_wgs84["xmax"],bbox_wgs84["ymax"]),
              datetime = "2021-06-01T00:00:00Z/2021-06-30T23:59:59Z") |>
  post_request() |> items_fetch(progress = FALSE)
length(items$features)



assets_v1 = c("blue", "green", "red", "nir", # earth-search.aws.element84.com/v1
              "nir08", "rededge1",  "rededge2",
              "rededge3", "coastal","nir09",
              "swir16", "swir22", "scl")



s2_collection = stac_image_collection(
  items$features,
  asset_names = assets_v1 ,
  property_filter =
    function(x) {
      x[["eo:cloud_cover"]] < 10
    }
)

s2_collection


gdalcubes_options(parallel = 6)
v = cube_view(
  srs = "EPSG:31982",
  dx = 100,
  dy = 100,
  dt = "P1D",
  aggregation = "median",
  resampling = "average",
  extent = list(
    t0 = "2021-06-01",
    t1 = "2021-06-30",
    left = bbox_sirg_utm["xmin"],
    right = bbox_sirg_utm["xmax"],
    top = bbox_sirg_utm["ymax"],
    bottom = bbox_sirg_utm["ymin"]
  )
)

v



cubo <- raster_cube(s2_collection, v) |>
  select_bands(c("red","green","blue", "nir")) |> # earth-search.aws.element84.com/v1
  apply_pixel("(nir-red)/(nir+red)", "NDVI", keep_bands = TRUE) |>
#   reduce_time(c( "median(red)", "median(green)",
#             "median(blue)", "median(NDVI)")) #|>
 gdalcubes::aggregate_time("P15D", "min")

#
# cubo |> select_bands(c("red","green","blue") |>
#                        plot(rgb = 1:3, zlim = c(10,2000))


## Geotiff - Resumo (mediana) para o período

write_tif(cubo, dir = "./dados/tif/",
          prefix = "caminho_img_",
          COG = TRUE)

# Check
#========

list.files("./dados/tif/")

# [1] "caminho_img_2021-10-01.tif" "caminho_img_2021-11-01.tif" "caminho_img_2021-12-01.tif"
# [4] "caminho_img_2022-01-01.tif" "caminho_img_2022-02-01.tif" "caminho_img_2022-03-01.tif"
# [7] "caminho_img_2022-04-01.tif"

# --------  Plot RGB .GeoTiff ----------------

# r <- raster::stack("./dados/tif/caminho_img_2022-03-01.tif")
# max_expected_value <- 10000
# #  rescale 0-255)
# r_scaled <- (r[[c(1,2,3)]] / max_expected_value) * 255
# raster::plotRGB(
#   r_scaled,
#   r = 1,
#   g = 2,
#   b = 3,
#   stretch = "hist",
#   axes = TRUE
# )

#---------------------------------------------

## netCDF-4 format- para cubo de dados

cubo <- raster_cube(s2_collection, v) |>
  select_bands(c("red","green","blue", "nir")) |> # earth-search.aws.element84.com/v1
  apply_pixel("(nir-red)/(nir+red)", "NDVI", keep_bands = TRUE) #|>


# cubo |> select_bands(c("red","green","blue") |>
#                        plot(rgb = 1:3, zlim = c(10,2000))

write_ncdf(cubo, "./dados/caminho_netcdf_aws.nc",
           overwrite = FALSE )


 ncdf_cube("./dados/caminho_netcdf_aws.nc") |>
  select_bands("NDVI") |>
    gdalcubes::aggregate_time("P15D", "min") |>
    # gdalcubes::slice_time(c("2021-06-24")) |>
  plot(key.pos = 1, col=viridis::cividis)



 # > sessionInfo()
 # R version 4.5.0 (2025-04-11)
 # Platform: x86_64-pc-linux-gnu
 # Running under: Ubuntu 22.04.5 LTS
 #
 # Matrix products: default
 # BLAS:   /usr/lib/x86_64-linux-gnu/blas/libblas.so.3.10.0
 # LAPACK: /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3.10.0  LAPACK version 3.10.0
 #
 # locale:
 #   [1] LC_CTYPE=pt_BR.UTF-8       LC_NUMERIC=C               LC_TIME=pt_BR.UTF-8        LC_COLLATE=pt_BR.UTF-8
 # [5] LC_MONETARY=pt_BR.UTF-8    LC_MESSAGES=pt_BR.UTF-8    LC_PAPER=pt_BR.UTF-8       LC_NAME=C
 # [9] LC_ADDRESS=C               LC_TELEPHONE=C             LC_MEASUREMENT=pt_BR.UTF-8 LC_IDENTIFICATION=C
 #
 # time zone: America/Sao_Paulo
 # tzcode source: system (glibc)
 #
 # attached base packages:
 #   [1] stats     graphics  grDevices utils     datasets  methods   base
 #
 # other attached packages:
 #   [1] knitr_1.50      purrr_1.0.4     gdalcubes_0.7.1 dplyr_1.1.4     sf_1.0-21       httr_1.4.7
 # [7] rstac_1.0.1
 #
 # loaded via a namespace (and not attached):
 #   [1] viridis_0.6.5      utf8_1.2.6         generics_0.1.4     class_7.3-23       KernSmooth_2.23-26
 # [6] jpeg_0.1-11        lattice_0.22-5     digest_0.6.37      magrittr_2.0.3     evaluate_1.0.3
 # [11] grid_4.5.0         RColorBrewer_1.1-3 fastmap_1.2.0      jsonlite_2.0.0     e1071_1.7-16
 # [16] DBI_1.2.3          gridExtra_2.3      viridisLite_0.4.2  scales_1.4.0       codetools_0.2-19
 # [21] cli_3.6.5          rlang_1.1.6        crayon_1.5.3       units_0.8-7        yaml_2.3.10
 # [26] tools_4.5.0        raster_3.6-32      ncdf4_1.24         ggplot2_3.5.2      curl_6.3.0
 # [31] vctrs_0.6.5        R6_2.6.1           png_0.1-8          proxy_0.4-27       lifecycle_1.0.4
 # [36] classInt_0.4-11    pkgconfig_2.0.3    terra_1.8-54       pillar_1.10.2      gtable_0.3.6
 # [41] glue_1.8.0         Rcpp_1.0.14        xfun_0.52          tibble_3.3.0       tidyselect_1.2.1
 # [46] rstudioapi_0.17.1  dichromat_2.0-0.1  farver_2.1.2       htmltools_0.5.8.1  rmarkdown_2.29
 # [51] compiler_4.5.0     sp_2.2-0



