![](https://github.com/viniciovcl/magick-images/blob/master/rstac-banner.png?raw=true)


---

### Interface padronizada para pesquisar e acessar dados de observação da Terra.

Cria uma série temporal (spatio-temporal array) usando uma interface padronizada para pesquisar e acessar dados de observação da Terra. API SpatioTemporal Asset Catalog (STAC).

> #### STAC Endpoints
>
> - https://planetarycomputer.microsoft.com/api/stac/v1/
> - https://earth-search.aws.element84.com/v1
> - https://brazildatacube.dpi.inpe.br/stac/
>
>  *Alguns* provedores da API STAC que fornecem acesso **público** às coleções.



```
collections <-   stac("https://planetarycomputer.microsoft.com/api/stac/v1/") %>%
    collections() %>%  get_request()

collections$collections[112]

# > collections$collections[112]
# [[1]]
# ###Collection
# - id: hls2-l30
# - title: Harmonized Landsat Sentinel-2 (HLS) Version 2.0, Landsat Data
```


id                     |title                                           |description             |
|:---------------------|:-----------------------------------------------|:-----------------------|
|sentinel-2-pre-c1-l2a |Sentinel-2 Pre-Collection 1 Level-2A            |2015-06-27 a atual      |
|cop-dem-glo-30        |Copernicus DEM GLO-30                           |2021-04-22 a 2021-04-22 |
|naip                  |NAIP: National Agriculture Imagery Program      |2010-01-01 a 2022-12-31 |
|cop-dem-glo-90        |Copernicus DEM GLO-90                           |2021-04-22 a 2021-04-22 |
|landsat-c2-l2         |Landsat Collection 2 Level-2                    |1982-08-22 a atual      |
|sentinel-2-l2a        |Sentinel-2 Level-2A                             |2015-06-27 a atual      |
|sentinel-2-l1c        |Sentinel-2 Level-1C                             |2015-06-27 a atual      |
|sentinel-2-c1-l2a     |Sentinel-2 Collection 1 Level-2A                |2015-06-27 a atual      |
|sentinel-1-grd        |Sentinel-1 Level-1C Ground Range Detected (GRD) |2014-10-10 a atual      |


```
search_query <- stac_obj %>% stac_search( collections = collection_id,
    bbox = c(-51.81,  -20.80,  -51.75,  -20.76 ), datetime = time_range,
    limit = limit_results)  %>% ext_filter(`eo:cloud_cover` < 20 )

items_matched <- search_query %>% post_request()  %>%  items_fetch()

signed_stac_query <- rstac::items_sign(items_matched,
  rstac::sign_planetary_computer())
```
<p style="font-size: 7px;">  
  
|platform    |instruments |s2:product_type |datetime                    |s2:datastrip_id                                                  |
|:-----------|:-----------|:---------------|:---------------------------|:----------------------------------------------------------------|
|Sentinel-2B |msi         |S2MSI2A         |2021-10-12T13:42:09.024000Z |S2B_OPER_MSI_L2A_DS_ESRI_20211013T040126_S20211012T134211_N03.00 |
|Sentinel-2A |msi         |S2MSI2A         |2021-10-17T13:42:21.024000Z |S2A_OPER_MSI_L2A_DS_ESRI_20211019T021405_S20211017T134216_N03.00 |
|Sentinel-2B |msi         |S2MSI2A         |2021-10-22T13:42:09.024000Z |S2B_OPER_MSI_L2A_DS_ESRI_20211023T091849_S20211022T134212_N03.00 |
|Sentinel-2B |msi         |S2MSI2A         |2021-10-22T13:42:09.024000Z |S2B_OPER_MSI_L2A_DS_ESRI_20211023T092324_S20211022T134212_N03.00 |
|Sentinel-2A |msi         |S2MSI2A         |2021-11-06T13:42:11.024000Z |S2A_OPER_MSI_L2A_DS_ESRI_20211107T034850_S20211106T134214_N03.00 |
|Sentinel-2A |msi         |S2MSI2A         |2021-11-06T13:42:11.024000Z |S2A_OPER_MSI_L2A_DS_ESRI_20211107T032220_S20211106T134214_N03.00 |
|Sentinel-2B |msi         |S2MSI2A         |2021-11-21T13:42:09.024000Z |S2B_OPER_MSI_L2A_DS_ESRI_20211121T224225_S20211121T134207_N03.00 |
|Sentinel-2B |msi         |S2MSI2A         |2021-11-21T13:42:09.024000Z |S2B_OPER_MSI_L2A_DS_ESRI_20211121T224103_S20211121T134207_N03.00 |
|Sentinel-2A |msi         |S2MSI2A         |2021-12-06T13:42:11.024000Z |S2A_OPER_MSI_L2A_DS_ESRI_20211207T022325_S20211206T134210_N03.00 |
|Sentinel-2A |msi         |S2MSI2A         |2021-12-06T13:42:11.024000Z |S2A_OPER_MSI_L2A_DS_ESRI_20211207T031116_S20211206T134210_N03.00 |
</p>

### gdalcubes::stac_image_collection

```
image_collection <- gdalcubes::stac_image_collection(
  signed_stac_query$features,  asset_names = bands,
  property_filter = function(x) {x[["eo:cloud_cover"]] < 20})
```

```
# Gdalcubes Raster Cube --------------------------------------------------------

s2.mask = image_mask("SCL", values=c(3,8,9)) # clouds and cloud shadows
gdalcubes_options(parallel = 6, show_progress = TRUE)


cubo <- raster_cube(image_collection, v)

```

  ```
Script R. Pesquisa e recupera conjuntos de dados de observação da Terra usando a interface padronizada
 SpatioTemporal Asset Catalog (STAC).

Cria uma série temporal (spatio-temporal array) a partir dos assets retornarnados pela API STAC.

Exporta a série temporal para o formato NetCDF ou GeoTIFF.

> str(time_serie)
Classes 'fill_time_cube', 'cube', 'xptr' <externalptr> 

A data cube proxy object - aggregation time: 1 Month

Dimensions:
               low             high count pixel_size chunk_size
t       2021-10-01       2022-04-30     7        P1M          1
y 7699753.68441534 7704253.68441534    45        100         45
x 415665.031861902 421965.031861902    63        100         63

Bands:
  name offset scale nodata unit
1  B02      0     1    NaN     
2  B03      0     1    NaN     
3  B04      0     1    NaN     
4  B08      0     1    NaN     
5  B8A      0     1    NaN     
6  SCL      0     1    NaN  

```

<p align="center" width="60%">
    <img width="60%" src="./animate.gif"> 
</p>



### Referências:

R. Simoes, F. C. de Souza, M. Zaglia, G. R. de Queiroz, R. D. C. dos Santos and K. R. Ferreira, “Rstac: An R Package to Access Spatiotemporal Asset Catalog Satellite Imagery,” 2021 IEEE International Geoscience and Remote Sensing Symposium IGARSS, 2021, pp. 7674-7677, doi: 10.1109/IGARSS47720.2021.9553518. <https://github.com/brazil-data-cube/rstac>

E. Appel, M.; Pebesma. On-demand processing of data cubes from satellite image collections with the gdalcubes library. Data, 2019. doi:https://doi.org/10.3390/data4030092.

https://gdalcubes.github.io/

https://stacspec.org/en/

https://planetarycomputer.microsoft.com/

https://element84.com/earth-search/
