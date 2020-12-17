# Shannon's Div Index parallelization at Crique Sarco & Graham Creek
# Matthew Walker

# required packages
library(raster)
library(sp)
library(gstat)
library(landscapemetrics)
library(partitions)
library(parallel)
cs<-raster("CLASSMAP_CS_clipped.tif")
p <- as(extent(cs), 'SpatialPolygons')  
cs_sample <-spsample(p, type = "regular", cellsize=20) #cellsize=100 is good; <20 more difficult

# The following function now parallelized below
#cs_grid_test <-sample_lsm(cs, y = cs_sample, size = 500, what = "lsm_l_shdi", progress=T)


# Calculate the number of cores: by default will use all - 1; fix if many cores
no_cores <- detectCores() - 1

# Initiate a cluster
cl <- makeCluster(no_cores)

#split sample points into (no cores) parts
parts <- split(x = 1:length(cs_sample), f = 1:no_cores)

#export variables, environment, and prepare libraries in cluster
clusterExport(cl = cl, varlist = c("cs_sample", "cs", "parts"), envir = .GlobalEnv)
clusterEvalQ(cl = cl, expr = c(library('sp'), library('gstat'),library('landscapemetrics')))

#times the parallel computation; adjust sample size as needed along with cell size (earlier)
system.time(parallelX <- parLapply(
  cl = cl,
  X = 1:no_cores,
  fun = function(x) sample_lsm(
    cs,
    y = cs_sample[parts[[x]],],
    size = 500,
    what = "lsm_l_shdi")
  ))

#for comparison - takes about (no cores) x as long 
#system.time(sample_lsm(gc,y=gc_sample,size=500,what='lsm_l_shdi'))

#shut down the cluster
stopCluster(cl)

# Merge all the parts
# NOTE: additional code needed for more than 3 cores (parts)
gc_grid_test <- rbind(parallelX[[1]],parallelX[[2]],parallelX[[3]])

# Plot as usual
plot(extent(gc),main='Shannon Diversity Index at Graham Creek')
n_unique <- dim(matrix(unique(gc_grid_test$value)))[1]
points(gc_sample,col=viridisLite::viridis(n_unique)[as.numeric(cut(gc_grid_test$value,breaks = n_unique))],cex=0.5,pch=15)
