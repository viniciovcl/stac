#-------------------------------------------------------------------------------
# Catálogo: Microsoft Planetary Computer STAC API <microsoft-pc>
# Recupera conjuntos de dados do catálogo planetary computer.microsoft através da
# api STAC (usando rstac). Cria uma coleção (Image_Collection) spatio-temporal array
# para que a coleção possa ser tratada como cubo de dados (gdalcubes) para análise
# de séries temporais.
#
# O cubo de dados criado pode ser exportado para o formato NetCDF (mantendo a
# estrutura espaço temporal) ou GeoTIFF com write_tif()
#
# Autor: Vinicio Coelho Lima
# Data: 13-06-2025
#
#-------------------------------------------------------------------------------

#            _       _            _
#           | |     | |          | |
#   __ _  __| | __ _| | ___ _   _| |__   ___  ___
#  / _` |/ _` |/ _` | |/ __| | | | '_ \ / _ \/ __|
# | (_| | (_| | (_| | | (__| |_| | |_) |  __/\__ \
#  \__, |\__,_|\__,_|_|\___|\__,_|_.__/ \___||___/
#   __/ |
#  |___/
#

     #  ____ _____  __   _____
     # / ___|_   _|/ \  / ___|
     # \___ \ | | / _ \| |
     #  ___) || |/ ___ \ |___
     # |____/ |_/_/   \_\____|
     #


# A STAC API of  <microsoft-pc>
# Collections Microsoft Planetary Computer



  # |ID_Colecao                     |Titulo                         |Periodo_Aquisicao                  |
  # |:------------------------------|:------------------------------|:----------------------------------|
  # |daymet-annual-pr               |Daymet Annual Puerto Rico      |1980-07-01 a 2020-07-01            |
  # |daymet-daily-hi                |Daymet Daily Hawaii            |1980-01-01 a 2020-12-30            |
  # |3dep-seamless                  |USGS 3DEP Seamless DEMs        |1925-01-01 a 2020-05-06            |
  # |3dep-lidar-dsm                 |USGS 3DEP Lidar Digital Surfac |2012-01-01 a 2022-01-01            |
  # |fia                            |Forest Inventory and Analysis  |2020-06-01 a Fim Indefinido        |
  # |sentinel-1-rtc                 |Sentinel 1 Radiometrically Ter |2014-10-10 a Fim Indefinido        |
  # |gridmet                        |gridMET                        |1979-01-01 a 2020-12-31            |
  # |daymet-annual-na               |Daymet Annual North America    |1980-07-01 a 2020-07-01            |
  # |daymet-monthly-na              |Daymet Monthly North America   |1980-01-16 a 2020-12-16            |
  # |daymet-annual-hi               |Daymet Annual Hawaii           |1980-07-01 a 2020-07-01            |
  # |daymet-monthly-hi              |Daymet Monthly Hawaii          |1980-01-16 a 2020-12-16            |
  # |daymet-monthly-pr              |Daymet Monthly Puerto Rico     |1980-01-16 a 2020-12-16            |
  # |gnatsgo-tables                 |gNATSGO Soil Database - Tables |2020-07-01 a 2020-07-01            |
  # |hgb                            |HGB: Harmonized Global Biomass |2010-12-31 a 2010-12-31            |
  # |cop-dem-glo-30                 |Copernicus DEM GLO-30          |2021-04-22 a 2021-04-22            |
  # |cop-dem-glo-90                 |Copernicus DEM GLO-90          |2021-04-22 a 2021-04-22            |
  # |terraclimate                   |TerraClimate                   |1958-01-01 a 2021-12-01            |
  # |nasa-nex-gddp-cmip6            |Earth Exchange Global Daily Do |1950-01-01 a 2100-12-31            |
  # |gpm-imerg-hhr                  |GPM IMERG                      |2000-06-01 a 2021-05-31            |
  # |gnatsgo-rasters                |gNATSGO Soil Database - Raster |2020-07-01 a 2020-07-01            |
  # |3dep-lidar-hag                 |USGS 3DEP Lidar Height above G |2012-01-01 a 2022-01-01            |
  # |io-lulc-annual-v02             |10m Annual Land Use Land Cover |2017-01-01 a 2024-01-01            |
  # |goes-cmi                       |GOES-R Cloud & Moisture Imager |2017-02-28 a Fim Indefinido        |
  # |conus404                       |CONUS404                       |1979-10-01 a 2022-09-30            |
  # |3dep-lidar-intensity           |USGS 3DEP Lidar Intensity      |2012-01-01 a 2022-01-01            |
  # |3dep-lidar-pointsourceid       |USGS 3DEP Lidar Point Source   |2012-01-01 a 2022-01-01            |
  # |mtbs                           |MTBS: Monitoring Trends in Bur |1984-12-31 a 2018-12-31            |
  # |noaa-c-cap                     |C-CAP Regional Land Cover and  |1975-01-01 a 2016-12-31            |
  # |3dep-lidar-copc                |USGS 3DEP Lidar Point Cloud    |2012-01-01 a 2022-01-01            |
  # |modis-64A1-061                 |MODIS Burned Area Monthly      |2000-11-01 a Fim Indefinido        |
  # |alos-fnf-mosaic                |ALOS Forest/Non-Forest Annual  |2015-01-01 a 2020-12-31            |
  # |3dep-lidar-returns             |USGS 3DEP Lidar Returns        |2012-01-01 a 2022-01-01            |
  # |mobi                           |MoBI: Map of Biodiversity Impo |2020-04-14 a 2020-04-14            |
  # |landsat-c2-l2                  |Landsat Collection 2 Level-2   |1982-08-22 a Fim Indefinido        |
  # |era5-pds                       |ERA5 - PDS                     |1979-01-01 a Fim Indefinido        |
  # |chloris-biomass                |Chloris Biomass                |2003-07-31 a 2019-07-31            |
  # |kaza-hydroforecast             |HydroForecast - Kwando & Upper |2022-01-01 a Fim Indefinido        |
  # |planet-nicfi-analytic          |Planet-NICFI Basemaps (Analyti |2015-12-01 a Fim Indefinido        |
  # |modis-17A2H-061                |MODIS Gross Primary Productivi |2000-02-18 a Fim Indefinido        |
  # |modis-11A2-061                 |MODIS Land Surface Temperature |2000-02-18 a Fim Indefinido        |
  # |daymet-daily-pr                |Daymet Daily Puerto Rico       |1980-01-01 a 2020-12-30            |
  # |3dep-lidar-dtm-native          |USGS 3DEP Lidar Digital Terrai |2012-01-01 a 2022-01-01            |
  # |3dep-lidar-classification      |USGS 3DEP Lidar Classification |2012-01-01 a 2022-01-01            |
  # |3dep-lidar-dtm                 |USGS 3DEP Lidar Digital Terrai |2012-01-01 a 2022-01-01            |
  # |gap                            |USGS Gap Land Cover            |1999-01-01 a 2011-12-31            |
  # |modis-17A2HGF-061              |MODIS Gross Primary Productivi |2000-02-18 a Fim Indefinido        |
  # |planet-nicfi-visual            |Planet-NICFI Basemaps (Visual) |2015-12-01 a Fim Indefinido        |
  # |gbif                           |Global Biodiversity Informatio |2021-04-13 a Fim Indefinido        |
  # |modis-17A3HGF-061              |MODIS Net Primary Production Y |2000-02-18 a Fim Indefinido        |
  # |modis-09A1-061                 |MODIS Surface Reflectance 8-Da |2000-02-18 a Fim Indefinido        |
  # |alos-dem                       |ALOS World 3D-30m              |2016-12-07 a 2016-12-07            |
  # |alos-palsar-mosaic             |ALOS PALSAR Annual Mosaic      |2015-01-01 a 2021-12-31            |
  # |deltares-water-availability    |Deltares Global Water Availabi |1970-01-01 a 2020-12-31            |
  # |modis-16A3GF-061               |MODIS Net Evapotranspiration Y |2001-01-01 a Fim Indefinido        |
  # |modis-21A2-061                 |MODIS Land Surface Temperature |2000-02-16 a Fim Indefinido        |
  # |us-census                      |US Census                      |2021-08-01 a 2021-08-01            |
  # |jrc-gsw                        |JRC Global Surface Water       |1984-03-01 a 2020-12-31            |
  # |deltares-floods                |Deltares Global Flood Maps     |2018-01-01 a 2018-12-31            |
  # |modis-43A4-061                 |MODIS Nadir BRDF-Adjusted Refl |2000-02-16 a Fim Indefinido        |
  # |modis-09Q1-061                 |MODIS Surface Reflectance 8-Da |2000-02-18 a Fim Indefinido        |
  # |modis-14A1-061                 |MODIS Thermal Anomalies/Fire D |2000-02-18 a Fim Indefinido        |
  # |hrea                           |HREA: High Resolution Electric |2012-12-31 a 2019-12-31            |
  # |modis-13Q1-061                 |MODIS Vegetation Indices 16-Da |2000-02-18 a Fim Indefinido        |
  # |modis-14A2-061                 |MODIS Thermal Anomalies/Fire 8 |2000-02-18 a Fim Indefinido        |
  * |sentinel-2-l2a                 |Sentinel-2 Level-2A            |2015-06-27 a Fim Indefinido*       |
  # |modis-15A2H-061                |MODIS Leaf Area Index/FPAR 8-D |2002-07-04 a Fim Indefinido        |
  # |modis-11A1-061                 |MODIS Land Surface Temperature |2000-02-24 a Fim Indefinido        |
  # |modis-15A3H-061                |MODIS Leaf Area Index/FPAR 4-D |2002-07-04 a Fim Indefinido        |
  # |modis-13A1-061                 |MODIS Vegetation Indices 16-Da |2000-02-18 a Fim Indefinido        |
  # |daymet-daily-na                |Daymet Daily North America     |1980-01-01 a 2020-12-30            |
  # |nrcan-landcover                |Land Cover of Canada           |2015-01-01 a 2020-01-01            |
  # |modis-10A2-061                 |MODIS Snow Cover 8-day         |2000-02-18 a Fim Indefinido        |
  # |ecmwf-forecast                 |ECMWF Open Data (real-time)    |Início Indefinido a Fim Indefinido |
  # |noaa-mrms-qpe-24h-pass2        |NOAA MRMS QPE 24-Hour Pass 2   |2022-07-21 a Fim Indefinido        |
  # |sentinel-1-grd                 |Sentinel 1 Level-1 Ground Rang |2014-10-10 a Fim Indefinido        |
  # |nasadem                        |NASADEM HGT v001               |2000-02-20 a 2000-02-20            |
  # |io-lulc                        |Esri 10-Meter Land Cover (10-c |2017-01-01 a 2021-01-01            |
  # |landsat-c2-l1                  |Landsat Collection 2 Level-1   |1972-07-25 a 2013-01-07            |
  # |drcog-lulc                     |Denver Regional Council of Gov |2018-01-01 a 2020-12-31            |
  # |chesapeake-lc-7                |Chesapeake Land Cover (7-class |2013-01-01 a 2014-12-31            |
  # |chesapeake-lc-13               |Chesapeake Land Cover (13-clas |2013-01-01 a 2014-12-31            |




library(rstac)
library(httr)
library(sf)
library(dplyr)
library(gdalcubes)


# URL base da STAC API da MPC
stac_obj <- stac("https://planetarycomputer.microsoft.com/api/stac/v1/")
rstac::get_request(stac_obj )

collections_query <- stac_obj|>
  rstac::collections()

class(stac_obj)
class(collections_query)

all_collections <- rstac::get_request(collections_query)
all_collections

# AOI

bb <- c(
  xmin = -51.8100,
  ymin = -20.8000,
  xmax = -51.7500,
  ymax = -20.7600
)

aoi_polygon <- st_as_sfc(st_bbox(bb), crs = 4326)
aoi_sf <- st_as_sf(aoi_polygon, crs = 4326)
box <- st_bbox(aoi_sf)
# mapview::mapview(aoi_sf)
# aoi_sf |> dplyr::mutate(Area = as.numeric(st_area(st_geometry(aoi_sf$x)))/10000)


# Search STAC  -----------------------------------------------------------------

stac_url <- "https://planetarycomputer.microsoft.com/api/stac/v1"
stac_obj <- stac(stac_url) #%>%
# items_sign_planetary_computer()

time_range <- "2021-10-01/2022-04-30"
collection_id <- "sentinel-2-l2a"
limit_results <- 100

search_query <- stac_obj %>%
  stac_search(
    collections = collection_id,
    bbox = #box,
      c(-51.81, # xmin
        -20.80, # ymin
        -51.75, # xmax
        -20.76  # ymax
      ),
    datetime = time_range,
    limit = limit_results
  )  %>%
  ext_filter(
    # s_intersects(geometry, {{aoi_polygon}}) &&
    `eo:cloud_cover` < 20
  )

items_matched <- search_query %>%
  post_request()  %>%  items_fetch()

signed_stac_query <- rstac::items_sign(
  items_matched,
  rstac::sign_planetary_computer()
)

items_df <- signed_stac_query %>%
  items_as_tibble()

items_df %>% arrange(datetime) %>% select(datetime)%>% pull() %>% unique()
glimpse(items_df)


items_df %>% arrange(datetime) %>%
  select(platform,
         instruments,
         `s2:product_type`,
         datetime,
         # `s2:processing_baseline`,
         # `s2:reflectance_conversion_factor`,
         `s2:datastrip_id`
         ) |> slice(1:10) |>
              kable(format = "markdown", align = c('l', 'l', 'l'))





# Gdalcubes Colletion-----------------------------------------------------------

bands <- c("B02", "B03", "B04", "B08", "B8A", "SCL")

#system.time(
image_collection <- gdalcubes::stac_image_collection(
  # items_matched$features,
  signed_stac_query$features,
  asset_names = bands,
  property_filter = function(x) {x[["eo:cloud_cover"]] < 20}
)
#)

print(image_collection)


# Gdalcubes Cube View-----------------------------------------------------------

aoi_sf |>
  st_transform("EPSG:31982") |>
  st_bbox() -> bbox_utm


v = cube_view(
  srs = "EPSG:31982",
  extent = list(
    t0 = "2021-10-01",
    t1 = "2022-04-30",
    left = bbox_utm["xmin"],
    right = bbox_utm["xmax"],
    bottom = bbox_utm["ymin"],
    top = bbox_utm["ymax"]
  ),
  dx = 100,
  dy = 100,
  dt = "P1M",
  aggregation = "median",
  resampling = "bilinear"
)

v


# Gdalcubes Raster Cube --------------------------------------------------------

s2.mask = image_mask("SCL", values=c(3,8,9)) # clouds and cloud shadows
gdalcubes_options(parallel = 6, show_progress = TRUE)


cubo <- raster_cube(image_collection, v)

write_ncdf(cubo, "./dados/caminho_netcdf_mpc.nc",
           overwrite = FALSE)

# Plot
ncdf_cube("./dados/caminho_netcdf_mpc.nc") |>
  select_bands("B08") |>
  # select_time(c("2022-02-01", "2022-03-01",  "2022-04-01")) #|>
  plot(key.pos = 1, col=viridis::cividis)



# cubo |>
#   select_bands(c("B02","B03","B04", "B08" )) %>%
#   apply_pixel("(B08-B04)/(B08+B04)", "NDVI", keep_bands = TRUE) |>
#   plot(key.pos = 1, col=viridis::cividis)


# Fill  ------------------------------------------------------------------------

cube <- ncdf_cube("./dados/caminho_netcdf_mpc.nc")


cube_fill <- gdalcubes::fill_time(cube, method = "near" ) # |>
  # select_bands("B08") |>
  # select_time(c("2022-02-01", "2022-03-01",  "2022-04-01")) #|>
  # plot(key.pos = 1, col=viridis::cividis)


## -----------------------------------------------------------------------------

## ESA is pleased to announce that the new Sentinel-2 Processing Baseline 04.00
# will be deployed on 25 January 2022.

# https://planetarycomputer.microsoft.com/dataset/sentinel-2-l2a#Baseline-Change


# CORREÇÃO DE REFLECTÂNCIA SENTINEL-2 (BASELINE 04.00)
#
# A partir de 25 de janeiro de 2022, a ESA atualizou o processamento das
# imagens Sentinel-2 para o Processing Baseline 04.00. Essa atualização
# introduziu uma mudança na forma como os valores de reflectância de superfície
# (BOA - Bottom of Atmosphere) são representados.
#
# Alteração:
#   - Antes da baseline 04.00:
#   Reflectância = (DN) / 10000
#
# - A partir da baseline 04.00:
#   Reflectância = (DN - BOA_ADD_OFFSET) / 10000
#
# O valor padrão de BOA_ADD_OFFSET é 1000 (mas deve ser confirmado nos metadados
# do produto).
#
# Se você estiver trabalhando com dados após 25/01/2022 e quiser comparar com
# dados anteriores, é necessário subtrair o BOA_ADD_OFFSET dos valores de pixel.
#
# -------------------------------------------------
#   Fórmula geral:
#
#   DN_POS_25-01-2022_harmonizado = (DN - BOA_ADD_OFFSET)
#
# Onde:
#   - DN = valor digital do pixel (Digital Number)
#   - BOA_ADD_OFFSET = normalmente 1000

# -------------------------------------------------


## -----------------------------------------------------------------------------


cube_fill |> select_bands("B08") |>
  plot(key.pos = 1, zlim = c(500, 5000), col=viridis::plasma(10))




####
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
#   [1] LC_CTYPE=pt_BR.UTF-8       LC_NUMERIC=C
# [3] LC_TIME=pt_BR.UTF-8        LC_COLLATE=pt_BR.UTF-8
# [5] LC_MONETARY=pt_BR.UTF-8    LC_MESSAGES=pt_BR.UTF-8
# [7] LC_PAPER=pt_BR.UTF-8       LC_NAME=C
# [9] LC_ADDRESS=C               LC_TELEPHONE=C
# [11] LC_MEASUREMENT=pt_BR.UTF-8 LC_IDENTIFICATION=C
#
# time zone: America/Sao_Paulo
# tzcode source: system (glibc)
#
# attached base packages:
#   [1] stats     graphics  grDevices utils     datasets  methods
# [7] base
#
# other attached packages:
#   [1] ggplot2_3.5.2   gdalcubes_0.7.1 dplyr_1.1.4
# [4] sf_1.0-21
#
# loaded via a namespace (and not attached):
#   [1] vctrs_0.6.5        cli_3.6.5          rlang_1.1.6
# [4] ncdf4_1.24         DBI_1.2.3          KernSmooth_2.23-26
# [7] generics_0.1.4     jsonlite_2.0.0     labeling_0.4.3
# [10] glue_1.8.0         e1071_1.7-16       gridExtra_2.3
# [13] viridis_0.6.5      scales_1.4.0       grid_4.5.0
# [16] classInt_0.4-11    tibble_3.3.0       lifecycle_1.0.4
# [19] compiler_4.5.0     RColorBrewer_1.1-3 Rcpp_1.0.14
# [22] pkgconfig_2.0.3    rstudioapi_0.17.1  farver_2.1.2
# [25] viridisLite_0.4.2  R6_2.6.1           dichromat_2.0-0.1
# [28] class_7.3-23       tidyselect_1.2.1   pillar_1.10.2
# [31] magrittr_2.0.3     tools_4.5.0        proxy_0.4-27
# [34] withr_3.0.2        gtable_0.3.6       units_0.8-7
# Mensagens de aviso:
#   1: In doTryCatch(return(expr), name, parentenv, handler) :
#   display list redraw incomplete
# 2: In doTryCatch(return(expr), name, parentenv, handler) :
#   invalid graphics state
# 3: In doTryCatch(return(expr), name, parentenv, handler) :
#   invalid graphics state
#


