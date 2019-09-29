############### Question 1 ############### 

# Load package
library(igraph)

# Load dataset
links <- read.csv("asoiaf-all-edges.csv", header = TRUE, sep=",", stringsAsFactors = FALSE)

# Define nodes
links$Type <- NULL
links$id <- NULL

# Make the network
net <- graph_from_data_frame(d=links, directed=FALSE)
print(net, e=TRUE, v=TRUE)

############### Question 2 ############### 

# Number of vertices
vcount(net)
# Number of edges
ecount(net)
# Diameter
diameter(net)
# Top 10 characters (degree)
degrees <- sort(degree(net, v = V(net),loops = TRUE, normalized = FALSE), decreasing = TRUE)
top_10_degrees <- head(degrees, n=10)
top_10_degrees
# Top 10 characters (weighted degree)
weighted_degrees <- strength(net, vids = V(net), loops = TRUE, weights = NULL)
top_10_weighted_degrees <- head(weighted_degrees, n=10)
top_10_weighted_degrees

############### Question 3 ############### 

plot(net, layout=layout_with_kk, vertex.color="red", vertex.label = NA, edge.arrow.width=15, vertex.size=3)

# Subgraph
is_important_vertices <- degrees >= 10
plot(induced_subgraph(net, is_important_vertices),vertex.label = NA, edge.arrow.width=15, vertex.size=5)

# Edge density
edge_density(net, loops = FALSE)
edge_density(induced_subgraph(net, is_important_vertices), loops = FALSE)

############### Question 4 ############### 

# Closeness centrality
close <- sort(closeness(net, vids = V(net), weights = NULL, normalized = FALSE), decreasing = TRUE)
top_15_closeness <- head(close, n=15)
top_15_closeness

# Betweenness centrality 
between <- sort(betweenness(net, v = V(net), directed = TRUE, weights = NULL, nobigint = TRUE, normalized = FALSE), decreasing = TRUE)
top_15_betweeness <- head(between, n=15)
top_15_betweeness

############### Question 5 ############### 

library(magrittr)
pr <- net %>%
  page.rank(directed = FALSE) %>%
  use_series("vector") %>%
  sort(decreasing = TRUE) %>%
  as.matrix %>%
  set_colnames("page.rank")

page_rank <- as.data.frame(pr)
head(page_rank)

# For plotting purposes the page rank of the characters are resized
page_rank_resizing <- as.numeric(page_rank[,1] * 1000)

plot(net, layout=layout_with_kk, vertex.color="red", vertex.label = NA, edge.arrow.width=15, vertex.size=page_rank_resizing)
