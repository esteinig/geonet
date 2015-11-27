##Tutorial

####1. Input Data and Main Function
---

The configuration of your visualization depends on two components: the input data and a list of options to pass to the handlers for globeJS and Leaflet.
Let's have a look at the input. We will need an undirected network and a data frame containing the meta data for each node in the network.

A minimal data frame requires three columns named `ID`, `Longitude`, `Latitude` and two columns that, for convenience, we will name `Colour` and `Size`. 
You can change the last two name references in the options, but these are the default names and therefore do not require any more configuration later on.

The network is an `igraph` object with undirected edges, the order of the nodes in the network dictates the order of rows in the meta data,
i.e. first row contains data for the first node in the network.

You will notice that we have a few more columns in the data frame, which hold additional data - you can use these to switch between sizes or colours,
add layers with different node attributes and attach text to popups - but more on that later!

Let's have a look at the main function:

```
maps <- geonet(g, d, mode='globejs', filter='off', time=FALSE, shiny=FALSE, save=FALSE, project='tutorial',
               options=geonetOptions() )
```

The required arguments are the graph `g` and the data frame `d`. The mode sets the type of visualization - you have the choice between `globejs`, `leaflet` or `sample`.
We will discuss each in later sections of the Tutorial. The filter assesses if a specified data category in each pair of nodes linked by an edge is `different` or the `same`.
The default is filter switched `off`. 

The time option decomposes the graph into its subgraphs by time points, so that the network can be traced through time. The column containing the
time points is set in the options. Instead of returning a list of map objects, the `shiny` argument launches a simple bootstrap page showing the result in with Shiny.

You can save your visualizations through the argument `save`, which will use the `project` name to write data and the final HTML.

####2. Options
---

The second component of the visualization are its attributes defined in a list of options.
Calling the *geonetOptions(...)* function will return a list of settings that you can pass to the options argument in *geonet(...)*.
There are quite a few arguments for *geonetOptions*, so let's have a look at the basic settings first and discuss the specific options in the sections dealing with globeJS and Lealflet.

One of the generally quite useful options is to randomly `jitter` the nodes by the given Longitude/ Latitude. You might want to use this option if you have non-unique coordinates for your samples, which would otherwise overlap each other.
However, please consider that the most salient feature of a map is the exact position encoding of your nodes /samples.

```
opts <- geonetOptions(jitter = 0.5, ...)
```
The data category for the edge filter is specified as the name of the column in your data frame, set in`filterValue`. The colours of un-filtered and filtered edges are specified in a vector of length two in `edgeColours`. The filter itself is set in the main function *geonet(...)*. 

```
opts <- geonetOptions(..., filterValue = 'Country', edgeColours = c('yellow', 'red'))
```

The option `containHTML` is by default set to FALSE. When saving your project, it will attempt to write the visuaization as self-contained HTML. However, for maps with many nodes and layers the *pandoc* converter throws a memory error (especially Leaflet).

```
opts <- geonetOptions(..., containHTML = TRUE)
```

Finally, you can set the column names for node colours, sizes, fills and time points used in the visualization:

```
opts <- geonetOptions(..., nodeColour = 'ColourColumn', nodeSize = 'SizeColumn',
                           nodeFill = 'FillColumn', timeData = 'TimeColumn')
```

Together, you can set options and insert them into the main *geonet* function:

```
opts <- geonetOptions(jitter = 1, containHTML = TRUE,
                      filterValue = 'Country', edgeColours = c('yellow', 'red'),
                      nodeColour = 'CountryColour', nodeFill = 'CountryColour',
                      nodeSize = 'NodeSize', timeData = 'Time')

geonet(...., filter='different', options=opts)
```

####3. GlobeJS

