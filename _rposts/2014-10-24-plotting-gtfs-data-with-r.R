#' ---
#' output:
#'  html_fragment:
#'   keep_md: yes
#' categories: R
#' layout: post
#' ---

#+ echo=FALSE
library("printr")
options(digits = 3, knitr.table.format = "markdown",
        encoding = "UTF-8", stringsAsFactors = FALSE)
knitr::opts_chunk$set(fig.path = "images/plotting-gtfs-data_with-r/", warnings = FALSE,
                      fig.align = "center", dpi = 85, message = FALSE)

#' Days ago a study says that Santiago, city where I live, has one of the best
#' public transport system in LATAM (WAT?! define *best* please!). So I've search
#' for some information and I found
#' [this](http://www.siemens.com/press/pool/de/feature/2014/infrastructure-cities/2014-06-mobility-opportunity/slide-credo.pdf#page=6).
#' Anyway I tried to find some related data/gtfs/information to work/play and I found the
#' *Transantiago GTFS*. GTFS means *General Transit Feed Specification* and is a format for
#' public transportation schedules and geographic data.
#'
#' This information comes in a zip file with information about routes, stations
#' (name, location), shapes (route, path) and other elements in the system. For example
#' the `shape.txt` file have the geographic path of each route.
#' 
#' Let's see the files:

dir("data/gtfs/")

library("dplyr")
library("readr")

shapes <- read_csv("data/gtfs/shapes.txt")
head(shapes)

#' It's simple plot this data with ggplot.

library("ggplot2")
library("ggthemes")


p <- ggplot(shapes) +
  geom_path(aes(shape_pt_lon, shape_pt_lat, group = shape_id),
            size = .2, alpha = .1) +
  coord_equal() +
  theme_map()
p

#' Is a good plot with a few lines of code. But let's get the things more fun:
#' Transantiago have a subway called *Metro*, so let's plot with more detail showing the
#' stations and the routes (lines) over this plot.
#'
#' We need obtain the stops and routes which belong to *Metro*. In this case, the *stop_id*
#' don't contain a number so we filter the metro's stations with `!grepl("\\d", stop_id)`.
#' Then we need filter the shapes and routes for the *metro*. At the beggining is a bit complicated,
#' in fact I needed some time to see the association between all this tables.

routes <- read_csv("data/gtfs/routes.txt")
trips <- read.csv("data/gtfs/trips.txt")
stops <- read.csv("data/gtfs/stops.txt")

stops_metro <- stops %>%
  filter(!grepl("\\d", stop_id))

routes_metro <- routes %>%
  filter(grepl("^L\\d", route_id))

shapes_metro <- shapes %>%
  filter(shape_id %in% trips$shape_id[trips$route_id %in% routes_metro$route_id]) %>%
  arrange(shape_id, shape_pt_sequence)

#' Now, get the color for each Metro line.
shapes_colors <- left_join(left_join(shapes %>% select(shape_id) %>% unique(),
                                     trips %>% select(shape_id, route_id) %>% unique(),
                                     by = "shape_id"),
                           routes %>% select(route_id, route_color) %>% unique(),
                           by = "route_id") %>%
  mutate(route_color = paste0("#", route_color))

shapes_colors_metro <- shapes_colors %>%
  filter(shape_id %in% trips$shape_id[trips$route_id %in% routes_metro$route_id]) %>% unique() %>%
  arrange(shape_id)


#' The data is ready. So it's time to make another plot.

#+ dev.args=list(bg="black"), fig.height=7.5
p2 <- ggplot() +
  geom_path(data=shapes, aes(shape_pt_lon, shape_pt_lat, group=shape_id),
            color="white", size=.2, alpha=.05) +
  geom_path(data=shapes_metro, aes(shape_pt_lon, shape_pt_lat, group=shape_id, colour=shape_id),
            size = 2, alpha=.7) +
  scale_color_manual(values=shapes_colors_metro$route_color) +
  geom_point(data=stops_metro, aes(stop_lon, stop_lat), shape=21, colour="white", alpha =.8) +
  coord_equal() +
  theme_map() +
  theme(plot.background = element_rect(fill = "black", colour = "black"),
        title = element_text(hjust=1, colour="white", size = 8),
        axis.title.x = element_text(hjust=0, colour="white", size = 7),
        legend.position = "none") +
  xlab(sprintf("Joshua Kunst | Jkunst.com %s", format(Sys.Date(), "%Y"))) +
  ggtitle("TRANSANTIAGO\nSantiago's public transport system")
p2


#' Or we can just plot only te metro routes with the follow code:

#+ dev.args=list(bg="black"), fig.height=7.5
p3 <- ggplot() +
  geom_path(data = shapes_metro,
            aes(shape_pt_lon, shape_pt_lat, group = shape_id, colour = shape_id),
            size = 2, alpha =.8) +
  scale_color_manual(values = shapes_colors_metro$route_color) +
  geom_point(data = stops_metro,
             aes(stop_lon, stop_lat),
             shape = 21, colour = "white", alpha = .8, size = 3) +
  coord_equal() +
  theme_map() +
  theme(plot.background = element_rect(fill = "black", colour = "black"),
        title = element_text(hjust=1, colour="white", size = 8),
        legend.position = "none") + 
  xlab(sprintf("Joshua Kunst | Jkunst.com %s", format(Sys.Date(), "%Y"))) +
  ggtitle("Santiago's METRO") 
p3


#' You can see the original image on wikipedia
#' [here](http://upload.wikimedia.org/wikipedia/commons/archive/4/49/20091229144454%21Metro_de_Santiago.svg).

#' As you can see, it's simply make a good graphic with a few lines of code. And better,
#' *GTFS* is a *standard*, so you can reuse a big part of this code (and make it a better code!)
#' to plot transport systems from other cities. If you do it, let me know.
