# Leaflet

## Used to create maps
library(leaflet)

my_map <- leaflet() %>% # creates a base layer
    addTiles() %>% #adds mapping content %>% 
    addMarkers(lat = 39.2980803, lng = -76.5898801, # add markers
           popup = "Jeff Leek's Office")
my_map

# Multiple markers
set.seed(100)

df <- data.frame(lat = runif(20, min = 39.2, max = 39.3),
                 lng = runif(20, min = -76.6, max = -76.5))

df %>% 
    leaflet() %>% 
    addTiles() %>% 
    addMarkers()


## Custom markers and pop ups

hopkinsIcon <- makeIcon(
    iconUrl = "https://brand.jhu.edu/content/uploads/2014/06/university.shield.small_.blue_.png",
    iconWidth = 31*215*230, iconHeight = 31,
    iconAnchorX = 31*215/230/2, iconAnchorY = 16
)

hopkinsLatLong <- data.frame(
    lat = c(39.2973166, 39.3288851, 39.2906617, 39.2970681, 39.2824806),
    lng = c(-76.5929798, -76.6206598, -76.5469683, -76.6150537, -76.6016766)
)

hopkinsLatLong %>%
    leaflet() %>% 
    addTiles() %>% 
    addMarkers(icon = hopkinsIcon)

# Custom pop up links

hopkinsSites <- c(
    "<a href = 'http://www.jhsph.edu/'>East Baltimore Campus</a>",
    "<a href = 'https://apply.jhu.edu/visit/homewood/'>Homewood Campus</a>",
    "<a href = 'http://www.hopkinsmedicine.org/johns_hopkins_bayview/'>Bayview Medical Center</a>",
    "<a href = 'http://www.peabody.jhu.edu/'>Peabody Institute</a>",
    "<a href = 'http://carey.jhu.edu/'>Carey Business School</a>"
)


hopkinsLatLong %>% 
    leaflet() %>% 
    addTiles() %>% 
    addMarkers(icon = hopkinsIcon, popup = hopkinsSites)


## Cluster points

df <- data.frame(lat = runif(500, min = 39.25, max = 39.35),
                 lng = runif(500, min = -76.65, max = -76.55))

df %>% 
    leaflet() %>% 
    addTiles() %>% 
    addMarkers(clusterOptions = markerClusterOptions()) # points clustered together


## Mapping Circle markers

df %>% 
    leaflet() %>% 
    addTiles() %>% 
    addCircleMarkers() # circles at the lat/lon positions


## Drawing shapes on the maps

md_cities <- data.frame(name = c("Baltimore", "Frederick", "Rockville", "Gaithersburg", "Bowie", "Hagerstown", "Annapolis", "College Park", "Salisbury", "Laurel"),
                        pop = c(619493, 66169, 62334, 61045, 55232, 39890, 38880, 30587, 30484, 25346),
                        lat = c(39.2920592, 39.4143921, 39.0840, 39.1434, 39.0068, 39.6418, 38.9784, 38.9897, 38.3607, 39.0993),
                        lng = c(-76.6077852, -77.4204875, -77.1528, -77.2014, -76.7791, -77.7200, -76.4922, -76.9378, -76.5994, -76.8483))

md_cities %>% 
    leaflet() %>% 
    addTiles() %>% 
    addCircles(weight = 5, radius = sqrt(md_cities$pop)*30) # weight increases size of borders


md_cities %>% 
    leaflet() %>% 
    addTiles() %>% 
    addRectangles(lat1 = 37.3858, lng1 = -122.0595,
                  lat2 = 37.3890, lng2 = -122.0625) #give two opposite corners


## Adding legends

df <- data.frame(lat = runif(20, min = 39.25, max = 39.35),
                 lng = runif(20, min = -76.65, max = -76.55),
                 col = sample(c("red", "blue", "green"), 20, replace = TRUE),
                 stringsAsFactors= FALSE)

df %>% 
    leaflet() %>% 
    addTiles() %>% 
    addCircleMarkers(color = df$col) %>% 
    addLegend(labels = LETTERS[1:3], colors = c("blue", "red", "green")) #add a legend
