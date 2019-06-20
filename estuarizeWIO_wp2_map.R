# Load the necessary packages to build up the map

# I prefer `ggplot2` to build the map in an elegant and tidy manner
library(ggplot2)

# To insert map insets I made use of the `viewport` function from `grid` package
library(grid) 

# For the scale and north arrow I used ggsn
library(ggsn)

# sf is a good package I used in conjuction with `ggplot2` to build the map 
library(sf)

# First create a global theme for all maps to be created
maptheme <- theme(axis.text = element_blank(),
                  axis.ticks = element_blank(),
                  panel.grid = element_blank(),
                  panel.border = element_rect(fill = NA, colour = "black"),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank(),
                  panel.background = element_blank())

# Create dataframes with spatial information of the 4 individual maps

# Spatial data for the overall map
study.sites <- data.frame(site=c('Tana','Ruvu','Rufiji','Qeulimane'),long=c(40.538,38.87,39.218,37),
                          lat=c(-2.526,-6.408,-7.843,-18))

# Spatial data for Kenya map
tana.town <- data.frame(site=c('Ozi','Kipini'),long=c(40.451,40.538),lat=c(-2.505,-2.526))

# Spatial data for Tanzania map
ruvu.town <- data.frame(site="Ruvu",long=38.87,lat=-6.408)

# Spatial data for Tanzania map
rufiji.town <- data.frame(site = "Rufiji",long=39.218,lat=-7.843)

# Spatial data for Mozambique map
queli.town <- data.frame(site=" Rio dos Bons Sinais",long=36.8872,lat=-17.8763)

# Import all the shapefiles and set them to `WGS84` datum

mangroves <- st_read(dsn = "C:/Users/Mwamlavya/Dropbox/work.stuff/GIS/Kenya/ke_mangroves",layer = "ke_mangroves")
mangroves <- st_set_crs(mangroves,"+proj=longlat +datum=WGS84")

tana <- st_read(dsn = "C:/Users/Mwamlavya/Dropbox/work.stuff/GIS/Kenya/tana",layer = "R-Tana _Shapefile")
tana <- st_set_crs(tana,"+proj=longlat +datum=WGS84")

reef <- st_read(dsn = "C:/Users/Mwamlavya/Dropbox/work.stuff/GIS/Kenya/Coral_reefs",layer = "ke_coral_reefs")

afr <- st_read(dsn = "C:/Users/Mwamlavya/Dropbox/work.stuff/GIS/Africa_SHP",layer = "Africa")
afr <- st_set_crs(afr,"+proj=longlat +datum=WGS84")

ken <- st_read(dsn = "C:/Users/Mwamlavya/Dropbox/work.stuff/GIS/Kenya/District_boundaries",
               layer = "ke_district_boundaries")
ken <- st_set_crs(ken,"+proj=longlat +datum=WGS84")

ken1 <- st_read(dsn = "C:/Users/Mwamlavya/Dropbox/work.stuff/GIS/Kenya/KEN_outline_SHP",layer = "KEN_outline")
ken1 <- st_set_crs(ken1,"+proj=longlat +datum=WGS84")

tz <- st_read(dsn = "C:/Users/Mwamlavya/Dropbox/work.stuff/GIS/Tanzania/tz-rivers",layer = "tz-rivers")
tz <- st_set_crs(tz,"+proj=longlat +datum=WGS84")

mz <- st_read(dsn = "C:/Users/Mwamlavya/Dropbox/work.stuff/GIS/mozambique_rivers_and_streams",
              layer = "mozambique_rivers_and_streams")
mz <- st_set_crs(mz,"+proj=longlat +datum=WGS84")


# The first inset map - `Africa` continent
africa <- ggplot()+geom_sf(data = afr,color = 'black', fill = 'white') +
  maptheme + coord_sf(datum = NA)

# The second inset map - the Tana River Delta in Kenya
tana.river <- ggplot() +
  geom_sf(data = ken1, color = 'black', fill = 'grey89') +
  geom_sf(data = tana, color ='blue', fill = 'blue') +
  coord_sf(xlim = c(40.1,40.630),ylim = c(-2.2,-2.65), datum = NA) +
  geom_point(data = tana.town,aes(x=long,y=lat),shape=20,size=4,color="red")+
  annotate("text",x=c(40.2,40.450,40.559),y=c(-2.215,-2.455,-2.465),label=c("Tana river","Ozi","Kipini"),size=3) +
  labs(x=NULL,y=NULL) + maptheme

# The third inset map - The Ruvu estuary in Tanzania
ruvu.river <- ggplot() +
  geom_sf(data = afr, color ='black', fill = 'grey89') +
  geom_sf(data = tz, color = 'blue', fill = 'blue') +
  coord_sf(xlim = c(38.75,38.97),ylim = c(-6.491,-6.3),datum = NA) +
  annotate("text",x=38.79,y=-6.315,label="Ruvu river",size=3) +
  geom_point(data=ruvu.town,aes(x=long,y=lat),shape=20,size=4,color="red") +
  labs(x=NULL,y=NULL) + maptheme

# The fourth inset map - The Rufiji Delta in Tanzania
rufiji.river <- ggplot() +
  geom_sf(data = afr, color ='black', fill = 'grey89') +
  geom_sf(data = tz, color = 'blue', fill = 'blue') +
  coord_sf(xlim = c(39.094,39.529),ylim = c(-7.669,-8.027),datum = NA) +
  annotate("text",x=39.17,y=-7.68,label="Rufiji river",size=3) +
  geom_point(data=rufiji.town,aes(x=long,y=lat),shape=20,size=4,color="red") +
  labs(x=NULL,y=NULL) + maptheme

# The fifth inset map - The Quelimane estaury in Mozambique
quelimane <- ggplot() +
  geom_sf(data = afr, color ='black', fill = 'grey89') +
  geom_sf(data = mz, color = 'blue', fill = 'blue') +
  coord_sf(xlim = c(36.556,37.421),ylim = c(-18.347,-17.581),datum = NA) +
  annotate("text",x=36.898,y=-17.60,label="Rio dos Bons Sinais",size=3) +
  annotate("text",x=36.8872,y=-17.8,label="Quelimane",size=3) +
  geom_point(data=queli.town,aes(x=long,y=lat),shape=20,size=4,color="red") +
  labs(x=NULL,y=NULL) + maptheme

# The main with all the details of the 4 previous maps
study.area <- ggplot() + 
  geom_sf(data = afr,color = 'black', fill = 'white') +
  annotate("rect", xmin = 40, xmax = 40.8, ymin = -2.3, ymax = -3,alpha = .5,color='blue',fill=NA,size=.8) +
  annotate("text",x=38,y=-1,label="Kenya") +
  annotate("rect", xmin = 38.462, xmax = 39.308, ymin = -6.791, ymax = -6.069,alpha = .5,color='blue',fill=NA,size=.8) +
  annotate("rect", xmin = 38.8, xmax = 39.629, ymin = -8.161, ymax = -7.4,alpha = .5,color='blue',fill=NA,size=.8) +
  annotate("text",x=37.484,y=-10.527,label="Tanzania") +
  annotate("rect", xmin = 36.556, xmax = 37.421, ymin = -18.347, ymax = -17.581,alpha = .5,color='blue',fill=NA,size=.8) +
  annotate("text",x=37.539,y=-13.311,label="Mozambique") +
  geom_point(data=study.sites,aes(x=long,y=lat,color="red"),shape=20,size=4) +
  scale_shape_identity() +
  scale_color_manual(values="red",name="Legend",labels = "Study sites") +
  coord_sf(xlim = c(34,47.5),ylim = c(-0.900,-19.199)) + 
  labs(x = NULL, y = NULL) + scale_y_continuous() + scale_x_continuous(breaks = c(34,38,42,46)) +
  theme(axis.text = element_text(colour = "black"),
        axis.ticks.x.bottom = element_line(colour = "black"),
        axis.ticks.y.left = element_line(colour = "black"),
        panel.grid = element_line(colour = "white"),
        panel.border = element_rect(fill = NA, colour = "black"),
        legend.box.background = element_blank(),
        legend.text = element_text(size = 11),
        legend.position = c(.75,.07),
        legend.title = element_text(size=11,hjust = 0.5,vjust = 1),
        panel.background = element_blank())
  
# Include scale to the main map
study.map <- study.area + 
  scalebar(location = "bottomleft", y.min = -15, y.max = -19, 
           x.min = 34.5, x.max = 44, dist = 300, dd2km = TRUE, 
           model = 'WGS84', st.dist = .15,st.size = 4.5)

# Create a tiff image with the specifications provided
tiff("wio study sites.tiff",height = 6.5,width = 6.5,units = 'in',res = 200)

# Specify the dimensions of the inset maps using `viewport` fucntion
vp_a <- viewport(width = 0.15, height = 0.15, x = 0.255, y = 0.911)
vp_b <- viewport(width = .235, height = .23, x = 0.73, y = 0.87)
vp_c <- viewport(width = .23, height = .23, x = 0.73, y = 0.673)
vp_d <- viewport(width = .23, height = .23, x = 0.73, y = 0.478)
vp_e <- viewport(width = .23, height = .23, x = 0.73, y = 0.277)

# Include the north arrow in the main map
north2(study.map, x = .5, y = .938, symbol = 1)

# Print the inset maps on the main map
print(africa, vp = vp_a)
print(tana.river, vp = vp_b)
print(ruvu.river, vp = vp_c)
print(rufiji.river, vp = vp_d)
print(quelimane, vp = vp_e)

dev.off()