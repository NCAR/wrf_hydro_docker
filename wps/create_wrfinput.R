#!/usr/bin/env Rscript

############################################################
# R script to create wrfinput file from geogrid.
# Usage: Rscript create_Wrfinput.R 
# Developed: 07/09/2017, A. Dugger
#          Mirrors the HRLDAS routines here:
#          https://github.com/NCAR/hrldas-release/blob/release/HRLDAS/HRLDAS_forcing/lib/module_geo_em.F
#          from M. Barlage.
# Modified:
#  - Added command line arguments (J. Mills)
#  - Added treatment for dealing with 0 SOILTEMP values over water cells
############################################################

library(optparse)
library(ncdf4)

option_list = list(
  make_option(c("--geogrid"), type="character", default=NULL, 
              help="Path to input geogrid file", metavar="character"),
  make_option(c("--outfile"), type="character", default="wrfinput_d01.nc", 
              help="output file name [default= %default]", metavar="character"),
  make_option(c("--filltyp"), type="integer", default=3, help="Soil type to use as a fill value in case 
                conflicts between soil water and land cover water cells. If the script encounters a cell 
                that is classified as land in the land use field (LU_INDEX) but is classified as a water 
                soil type, it will replace the soil type with the value you specify. Ideally there are 
                not very many of these, so you can simply choose the most common soil type in your domain. 
                Alternatively, you can set to a bad value (e.g., -8888) to see how many of these conflicts 
                there are. If you do this DO NOT RUN THE MODEL WITH THESE BAD VALUES. Instead, fix them 
                manually with a neighbor fill or similar fill algorithm. [default= %default]", metavar="character"),
  make_option(c("--laimo"), type="integer", default=8, 
              help="output file name [default= %default]", metavar="character"),
  make_option(c("--missfloat"), type="numeric", default=(-1.e+36), 
              help="Missing values to use when defining netcdf file for floats [default= %default]", 
              metavar="character"),
  make_option(c("--missint"), type="integer", default=(-9999), 
              help="Missing values to use when defining netcdf file for integers [default= %default]", 
              metavar="character")
); 

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

if (is.null(opt$geogrid)){
  print_help(opt_parser)
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
}

#### Input geogrid:
geoFile <- opt$geogrid

#### Output wrfinput file:
wrfinFile <- opt$outfile

#### Soil type to use as a fill value in case conflicts between soil water and land cover water cells:
# If the script encounters a cell that is classified as land in the land use field (LU_INDEX)
# but is classified as a water soil type, it will replace the soil type with the value you
# specify below. Ideally there are not very many of these, so you can simply choose the most
# common soil type in your domain. Alternatively, you can set to a "bad" value (e.g., -8888) 
# to see how many of these conflicts there are. If you do this DO NOT RUN THE MODEL WITH THESE 
# BAD VALUES. Instead, fix them manually with a neighbor fill or similar fill algorithm.
fillsoiltyp <- opt$filltyp

#### Month to use for LAI initialization:
# This may or may not be used depending on your NoahMP options.
laimo <- opt$laimo

#### Missing values to use when defining netcdf file:
missFloat <- opt$missfloat
missInt <- opt$missint


#######################################################
# Do not update below here.
#######################################################

# Create initial file
cmd <- paste0("ncks -O -4 -v XLAT_M,XLONG_M,HGT_M,SOILTEMP,LU_INDEX,MAPFAC_MX,MAPFAC_MY,GREENFRAC,LAI12M,SOILCTOP ", geoFile, " ", wrfinFile)
print(cmd)
system(cmd, intern=FALSE)

# Variable name adjustments
cmd <- paste0("ncrename -O -v HGT_M,HGT ", wrfinFile, " ", wrfinFile)
print(cmd)
system(cmd, intern=FALSE)
cmd <- paste0("ncrename -O -v XLAT_M,XLAT ", wrfinFile, " ", wrfinFile)
print(cmd)
system(cmd, intern=FALSE)
cmd <- paste0("ncrename -O -v XLONG_M,XLONG ", wrfinFile, " ", wrfinFile)
print(cmd)
system(cmd, intern=FALSE)
cmd <- paste0("ncrename -O -v LU_INDEX,IVGTYP ", wrfinFile, " ", wrfinFile)
print(cmd)
system(cmd, intern=FALSE)

# Now create and add new vars
ncid <- nc_open(wrfinFile, write=TRUE)

# Dimensions
sndim <- ncid$dim[['south_north']]
wedim <- ncid$dim[['west_east']]
soildim <- ncdim_def("soil_layers_stag", "", vals=1:4, create_dimvar=FALSE)
timedim <- ncid$dim[['Time']]

# Attributes
gridid <- ncatt_get(ncid, 0)[["GRID_ID"]]
iswater <- ncatt_get(ncid, 0)[["ISWATER"]]
isoilwater <- ncatt_get(ncid, 0)[["ISOILWATER"]]
isurban <- ncatt_get(ncid, 0)[["ISURBAN"]]                                                             
isice <- ncatt_get(ncid, 0)[["ISICE"]] 
mminlu <- ncatt_get(ncid, 0)[["MMINLU"]]

# New Variables

# SOILTEMP will show 0 value over water. This can cause issues when varying land cover fields
# from default. Setting to mean non-zero values for now to have something reasonable.
soilt <- ncvar_get(ncid, "SOILTEMP")
soilt[soilt < 100] <- NA
soilt_mean <- mean(c(soilt), na.rm=TRUE)
soilt[is.na(soilt)] <- soilt_mean
tmn <- soilt - 0.0065 * ncvar_get(ncid, "HGT")

use <- ncvar_get(ncid, "IVGTYP")

msk <- use 
msk[msk == iswater] <- (-9999)
msk[msk >= 0] <- 1
msk[msk < 0] <- 2

ice <- msk * 0.0

soil_top_cat <- ncvar_get(ncid, "SOILCTOP")
idim <- dim(soil_top_cat)[1]
jdim <- dim(soil_top_cat)[2]
kdim <- dim(soil_top_cat)[3]
soi <- msk * 0.0
for (i in 1:idim) {
   for (j in 1:jdim) {
      dominant_value = soil_top_cat[i,j,1]
      dominant_index = 1
      if ( msk[i,j] < 1.5 ) {
         for (k in 2:kdim) {
            if ( ( k != isoilwater ) & ( soil_top_cat[i,j,k] > dominant_value ) ) {
               dominant_value <- soil_top_cat[i,j,k]
               dominant_index <- k
            }
         }
         if ( dominant_value < 0.01 ) dominant_index <- 8
      } else {
         dominant_index <- isoilwater
      }
      soi[i,j] <- dominant_index
   }
}
soi[use == iswater] <- isoilwater
soi[use != iswater & soi == isoilwater] <- fillsoiltyp

veg <- 100.0 * ncvar_get(ncid, "GREENFRAC")
vegmin <- apply(veg, c(1,2), min)
vegmax <- apply(veg, c(1,2), max)

lai <- ncvar_get(ncid, "LAI12M")
lai <- lai[,,laimo]

canwat <- msk * 0.0

snow <- msk * 0.0

tsk <- msk * 0.0 + 290.0

smois <- array(rep(msk, 4), dim=c(dim(msk),4)) 
smois[,,1] <- 0.20
smois[,,2] <- 0.21
smois[,,3] <- 0.25
smois[,,4] <- 0.27

tslb <- array(rep(msk, 4), dim=c(dim(msk),4))
tslb[,,1] <- 285.0
tslb[,,2] <- 283.0
tslb[,,3] <- 279.0
tslb[,,4] <- 277.0

zs <- c(0.05, 0.25, 0.7, 1.5)

dzs <- c(0.1, 0.3, 0.6, 1.0)


# Define and place new vars

vardef <- ncvar_def("TMN", "K", list(wedim, sndim, timedim), missval=missFloat)
ncid <- ncvar_add(ncid, vardef)
ncvar_put(ncid, "TMN", tmn)

vardef <- ncvar_def("XLAND", "", list(wedim, sndim, timedim), missval=missInt, prec='integer')
ncid <- ncvar_add(ncid, vardef)
ncvar_put(ncid, "XLAND", msk)

vardef <- ncvar_def("SEAICE", "", list(wedim, sndim, timedim), missval=missFloat)
ncid <- ncvar_add(ncid, vardef)
ncvar_put(ncid, "SEAICE", ice)

vardef <- ncvar_def("ISLTYP", "", list(wedim, sndim, timedim), missval=missInt, prec='integer')
ncid <- ncvar_add(ncid, vardef)
ncvar_put(ncid, "ISLTYP", soi)

vardef <- ncvar_def("SHDMAX", "%", list(wedim, sndim, timedim), missval=missFloat)
ncid <- ncvar_add(ncid, vardef)
ncvar_put(ncid, "SHDMAX", vegmax)

vardef <- ncvar_def("SHDMIN", "%", list(wedim, sndim, timedim), missval=missFloat)
ncid <- ncvar_add(ncid, vardef)
ncvar_put(ncid, "SHDMIN", vegmin)

vardef <- ncvar_def("LAI", "m^2/m^2", list(wedim, sndim, timedim), missval=missFloat)
ncid <- ncvar_add(ncid, vardef)
ncvar_put(ncid, "LAI", lai)

vardef <- ncvar_def("CANWAT", "kg/m^2", list(wedim, sndim, timedim), missval=missFloat)
ncid <- ncvar_add(ncid, vardef)
ncvar_put(ncid, "CANWAT", canwat)

vardef <- ncvar_def("SNOW", "kg/m^2", list(wedim, sndim, timedim), missval=missFloat)
ncid <- ncvar_add(ncid, vardef)
ncvar_put(ncid, "SNOW", snow)

vardef <- ncvar_def("TSK", "K", list(wedim, sndim, timedim), missval=missFloat)
ncid <- ncvar_add(ncid, vardef)
ncvar_put(ncid, "TSK", tsk)

vardef <- ncvar_def("SMOIS", "m^3/m^3", list(wedim, sndim, soildim, timedim), missval=missFloat)
ncid <- ncvar_add(ncid, vardef)
ncvar_put(ncid, "SMOIS", smois)

vardef <- ncvar_def("TSLB", "K", list(wedim, sndim, soildim, timedim), missval=missFloat)
ncid <- ncvar_add(ncid, vardef)
ncvar_put(ncid, "TSLB", tslb)

vardef <- ncvar_def("ZS", "m", list(soildim, timedim), missval=missFloat)
ncid <- ncvar_add(ncid, vardef)
ncvar_put(ncid, "ZS", zs)

vardef <- ncvar_def("DZS", "m", list(soildim, timedim), missval=missFloat)
ncid <- ncvar_add(ncid, vardef)
ncvar_put(ncid, "DZS", dzs)

nc_close(ncid)

# Remove extra vars
cmd <- paste0("ncks -O -x -v SOILTEMP,GREENFRAC,LAI12M,SOILCTOP ", wrfinFile, " ", wrfinFile)
print(cmd)
system(cmd, intern=FALSE)

quit("no")

