#rwrfhydro docker file
This is a docker files that contains R, Rstudio, and rwrfhydro plus all its dependencies and suggests. 
This image could be made considerably smaller with the exclusion of Rstudio and many unneeded dependencies included in the rocker/tidyverse image.

#Docker run commands
###Once running R-studio can be accessed using browser and navigating to localhost:8787
###Make sure to map the port on local host to the container using -p 8787:8787
###For example, docker run --name rwrfhydro -d -p 8787:8787 -v /Volumes/d1/jmills/cuahsiTrainingMaterials:/home/rstudio/cuahsiTrainingMaterials rwrfhydro
