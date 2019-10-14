# *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=
# Copyright UCAR (c) 2018
# University Corporation for Atmospheric Research(UCAR)
# National Center for Atmospheric Research(NCAR)
# Research Applications Laboratory(RAL)
# P.O.Box 3000, Boulder, Colorado, 80307-3000, USA
#
# Authors:     Kevin Sampson, Joe Mills, Katelyn FitzGerald
# Created:     05/24/2018
# Updated:     10/14/2019
# *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=


import f90nml
import subprocess
import shlex
from argparse import ArgumentParser
import pathlib
import shutil
import os
import time
import cartopy.io.img_tiles as cimgt
from wrf import (projection, latlonutils)
import math

#Setup matplotlib to not use any xwindows backend
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

# Functions
def build_projparams(ref_lat=0.0, ref_lon=0.0, dx=1000.0, dy=1000.0,
                     map_proj='lambert', truelat1=0.0, truelat2=0.0,
                     stand_lon=0.0,pole_lat=90.0, pole_lon=0.0,
                     known_x=0.0, known_y=0.0, cen_lat=None, cen_lon=None):
    '''
    This function will take a set of input projection parameters (ideally
    from a WPS namelist) and fill in other parameters with defaults,
    returning the upper-case versions of these parameters for use in wrf-python
    functions.

    Note that currently MOAD_CEN_LAT is not provided by a WPS namelist and is
    given a null value here. It MUST however be provided to wrf-python funcitons.
    '''

    # Convert text in namelist map_proj to integer
    projdict = {'lambert': 1, 'polar': 2, 'mercator': 3, 'lat-lon': 6}
    map_proj = projdict[map_proj]
    moad_cen_lat = None

    # Build args dict using local variables
    scope = locals()
    varlist = ['dx','dy','map_proj','truelat1','truelat2','moad_cen_lat','stand_lon',
               'pole_lat','pole_lon','known_x','known_y','ref_lat','ref_lon','cen_lat','cen_lon']
    projparams = dict((name.upper(),eval(name, scope)) for name in varlist)
    return projparams

def find_corner(DX,DY,nrows,ncols,divFac,xOffset=0.0,yOffset=0.0):
    '''
    This function will take a grid (defined by rows and columns and cellsize) and
    produce the corner coordinates in projected space. Assumes that the 0,0 point
    is the center of the projected coordinate system. Allows for false eastings and
    northings (xOffset,yOffset) in projected coordinates.
    '''
    xdist = (float(DX)*float(ncols)/divFac)
    ydist = (float(DY)*float(nrows)/divFac)
    minX = xOffset-xdist
    minY = yOffset-ydist
    maxX = xOffset+xdist
    maxY = yOffset+ydist
    return minX, maxX, minY, maxY

def calculateZoom(WidthPixel,Ratio,Lat,Length):
    '''https://gis.stackexchange.com/questions/7430/what-ratio-scales-do-google-maps-zoom-levels-correspond-to'''
    k = WidthPixel * 156543.03392 * math.cos(Lat * math.pi / 180)        # k = circumference of the world at the Lat_level, for Z=0
    myZoom = round(math.log((Ratio*k)/(Length*100))/math.log(2))
    myZoom =  (myZoom -1)+8                   # Z starts from 0 instead of 1
    return int(myZoom)

def plot_from_wps(patch_nml_path: str,
                  figFilename: str = None,
                  display: bool = True,
                  useCartopy: bool = True,
                  TileService: bool = False,
                  xyzTiles: str = 'http://tile.stamen.com/terrain/{z}/{x}/{y}.jpg'):

    # namelist options to be passed as kwargs dict to projparams
    namelist_patch = f90nml.read(patch_nml_path)

    # Strip out all namelist classes
    plot_options = namelist_patch['geogrid']
    plot_options = dict(plot_options)

    # get options not used by proj_params
    e_we = plot_options['e_we']
    e_sn = plot_options['e_sn']

    # Remove unnescesary information
    keys_to_keep = ['ref_lat', 'ref_lon',
                    'dx', 'dy',
                    'map_proj',
                    'truelat1', 'truelat2',
                    'stand_lon']
    keys_to_keep = set(keys_to_keep)
    all_keys = set(plot_options.keys())
    keys_to_delete = all_keys - keys_to_keep
    for key in keys_to_delete:
        del plot_options[key]

    tic = time.time()

    # Gather parameters from WPS namelist and submit to function
    projparams = build_projparams(**plot_options, pole_lat=90.0, pole_lon=0.0,
                                  known_x=0.0, known_y=0.0)

    # Resolve parameter inconsistencies
    # ################################################################## #
    #
    # MOAD_CEN_LAT is calculated internally by WPS, not provided in the WPS namelist.
    # wrf-python requires either a defined MOAD_CEN_LAT or CEN_LAT to build the CRS.
    # The projection origin (MOAD_CEN_LAT,STAND_LON) is not necessarily going to be
    # identical to each grid origin (like with nested or subsetted domains), thus
    # MOAD_CEN_LAT can be anywhere (?).
    #
    # Make up a MOAD_CEN_LAT in order to use wrf-python
    if projparams['MOAD_CEN_LAT'] is None:
        # Fill with a dummy latitude (average the standard parallell latitudes)
        somelat = 0.5*(projparams['TRUELAT1']+projparams['TRUELAT2'])
        projparams['MOAD_CEN_LAT'] = somelat
    # ################################################################## #

    # ################################################################## #
    # Hack to get the projection away from the ref_lat and ref_lon
    #
    # The issue is that if ref_lat and ref_lon are provided to the projection.getproj
    # function, then they are not used in building the projection definition, but
    # they do get used later on by the _ll_to_xy and _xy_to_ll functions as the CRS origin.
    # That causes issues when trying to offset the grid origin from it's coordinate
    # system origin. To solve, set REF_LAT and REF_LON to the CRS origin
    # (MOAD_CEN_LAT,STAND_LON) and that will persist the CRS origin even when using
    # _ll_to_xy and _xy_to_ll functions.
    #
    reflat = projparams['REF_LAT']    # To be used later in calculating domain center xy
    reflon = projparams['REF_LON']    # To be used later in calculating domain center xy
    #
    # Set the ref_lat and ref_lon parameters to match MOAD_CEN_LAT and STAND_LON for
    # the purposes of building a coordinate system
    projparams['REF_LAT'] = projparams['MOAD_CEN_LAT']
    projparams['REF_LON'] = projparams['STAND_LON']
    # ################################################################## #

    # ################################################################## #
    # Use the wrf-python funcitonality to define the coordinate system given the input parameters
    inproj = projection.getproj(**projparams)
    wrf_proj4 = inproj.proj4()    # Test the coordinate system definition
    print('Proj4: %s' %wrf_proj4)
    # ################################################################## #

    # ################################################################## #
    # the wrf-python functions _xy_to_ll and _ll_to_xy provide the xy in cell coordinates,
    # not projected coordinates. Be sure to convert to projected coordinates by multiplying
    # by the resolution.
    #
    center_xy = latlonutils._ll_to_xy(reflat, reflon, as_int=False, **projparams)
    center_ll = latlonutils._xy_to_ll(center_xy[0], center_xy[0], as_int=False, **projparams)
    center_xy[0] = center_xy[0]*projparams['DX'] # Rescale from pixel coords to projected coords
    center_xy[1] = center_xy[1]*projparams['DY'] # Rescale from pixel coords to projected coords
    print('Grid center x,y: %s' %center_xy)
    print('Grid center lat,lon: %s' %center_ll)
    # ################################################################## #

    # ################################################################## #
    # Build exent and handle any false_easting and false_northings
    nrows = e_sn-1    # Subtract 1 for the number of rows in y
    ncols = e_we-1    # Subtract 1 for the number of columns in x
    minX, maxX, minY, maxY = find_corner(projparams['DX'], projparams['DY'],
                                         nrows, ncols, 2,
                                         xOffset=center_xy[0], yOffset=center_xy[1])
    xbbox = [minX, minX, maxX, maxX, minX]    # Used to draw a box in ax.plot()
    ybbox = [minY, maxY, maxY, minY, minY]    # Used to draw a box in ax.plot()
    img_extent = find_corner(projparams['DX'], projparams['DY'],
                             nrows, ncols, 1.75,
                             xOffset=center_xy[0], yOffset=center_xy[1])
    print('Domain extent: %s' %[minX, maxX, minY, maxY])
    # ################################################################## #

    # --- PLOTTING --- #
    wrf_crs = inproj.cartopy()  # Create a cartopy projection object

    # Create the plot image
    fig = plt.figure(figsize=(12, 12))
    ax = fig.add_subplot(1, 1, 1, projection=wrf_crs)
    ax.set_extent(img_extent, crs=wrf_crs)
    figsize = fig.get_size_inches()*fig.dpi # Figure size in pixels

    # Add the polygon boundary extent
    ax.plot(xbbox, ybbox, color='red', transform=wrf_crs)

    #You have to calculate the tile zoom level manually
    dist = img_extent[1]-img_extent[0]  # Horizontal distance of the map image
    percent_of_image = 0.85  # The percent of the image a horizontal line should cover
    zoomLev = calculateZoom(figsize[1],percent_of_image,center_ll[0],dist)

    # Request the XYZ tiles
    request = cimgt.GoogleTiles(url=xyzTiles)
    ax.add_image(request, zoomLev, interpolation='bicubic')
    ax.gridlines()

    if figFilename is not None:
        plt.savefig(figFilename)
    if display:
        plt.show()

    print('Process completed after %3.2f seconds.' %(time.time()-tic))

def patch_namelist(orig_nml_path: str,patch_nml_path: str,new_nml_path: str):
    """This function updates a larger orginal namelist with a file containing a smaller subset of
    changes and writes out a new namelist to a file.
    Args:
        orig_nml_path: Path to the namelist file to be updated
        patch_nml_path: Path to the file containing the namelist updates
        new_nml_path: Path to write the new namelist file with updates applied.

    Returns:
        None
    """
    # Read in namelist patch
    patch_nml = f90nml.read(nml_path=patch_nml_path)

    # Write new namelist to file
    f90nml.patch(nml_path=orig_nml_path,
                 nml_patch=patch_nml,
                 out_path=new_nml_path)

    #print('New namelist written to ' + new_nml_path)
    return(None)


def main():

    parser = ArgumentParser(description="Step 1: Pull the image\n"
                                        "docker pull wrfhydro/wps\n"
                                        "Step 2: Create a directory to bind-mount to Docker for "
                                        "passing files between your system and docker\n"
                                        "mkdir /home/dockerMount\n"
                                        "Step 3: Create a namelist.wps file for your domain using the above example as a starting point and save it in your mount directory from step 1.\n"
                                        "Step 4: Run Docker invoking the python make_geogrid.py "
                                        "utility with the required arguments.\n"
                                        "NOTE THE PATHS LISTED BELOW IN THE ARUGMENT LIST ARE FOR THE DOCKER FILESYSTEM. ALSO NOTE THAT ALL PATHS MUST BE ABSOLUTE"
                                        "docker run -v "
                                        "<path-to-your-local-mount-folder>:/home/docker/mount\n"
                                        "wrfhydro/wps\n"
                                        "--namelist_path /home/docker/mount/namelist.wps\n"
                                        "--output_dir /home/docker/mount/\n"
                                        "Note: Windows users will need to remove the \ from the end of each line of the above commands.")
    parser.add_argument("--namelist_path",
                        dest="namelist_path",
                        default='/home/docker/mount/namelist.wps',
                        help="Path to namelist file containing the namelist.wps updates")
    parser.add_argument("--output_dir",
                        dest="output_dir",
                        default='/home/docker/mount/',
                        help="Path to directory to hold outputs")
    parser.add_argument("--plot_only",
                        dest="plot_only",
                        action='store_true',
                        default='false',
                        help="Only create a plot of the domain. Geogrid will not be created if "
                             "plot_only = true, only a plot of the domain will be created.")
    parser.add_argument("--create_wrf_input",
                        dest="create_wrf_input",
                        action='store_true',
                        default='true',
                        help="create a wrfinput initial condition file for WRF-Hydro")
    args = parser.parse_args()

    patch_nml_path = pathlib.Path(args.namelist_path)
    output_dir = args.output_dir
    plot_only = args.plot_only
    display = 'false'
    create_wrf_input = args.create_wrf_input

    # Move modified GEOGRID.TBL into geogrid folder if running utility
    # File will be moved back after finish
    modified_geogrid_tbl_path = pathlib.Path("/home/docker/WRF_WPS/utilities/geog_conus/" \
                                             "GEOGRID.TBL.ARW.wrf_hydro_training")
    original_geogrid_tbl_path= pathlib.Path("/home/docker/WRF_WPS/WPS/geogrid/GEOGRID.TBL.ARW")
    backup_geogrid_tbl_path = original_geogrid_tbl_path.parent.joinpath('GEOGRID.TBL.ARW_tempbak')
    shutil.move(str(original_geogrid_tbl_path),str(backup_geogrid_tbl_path))
    shutil.copy(str(modified_geogrid_tbl_path),str(original_geogrid_tbl_path))

    orig_nml_path = pathlib.Path('/home/docker/WRF_WPS/utilities/namelist.wps_orig')
    new_nml_path = pathlib.Path('/home/docker/WRF_WPS/WPS/namelist.wps')

    if display.lower() == 'true':
        display = True
    else:
        display = False

    try:
        if plot_only is True:
            plot_from_wps(patch_nml_path=str(patch_nml_path),
                          figFilename=output_dir + '/domain.png',
                          display=display)
        else:
            print('Plotting domain')
            plot_from_wps(patch_nml_path=str(patch_nml_path),
                          figFilename=output_dir + '/domain.png',
                          display=display)

            print('Generating geogrid file')
            # First patch the namelist
            patch_namelist(orig_nml_path=str(orig_nml_path),
                           patch_nml_path=str(patch_nml_path),
                           new_nml_path=str(new_nml_path))

            # Now run geogrid.exe
            new_nml_path = pathlib.Path(new_nml_path)
            subprocess.run(['./geogrid.exe'],
                           cwd=new_nml_path.parent)

            shutil.copy(str(new_nml_path.parent / 'geo_em.d01.nc'),
                        output_dir + '/geo_em.d01.nc')
            shutil.move(str(backup_geogrid_tbl_path),str(original_geogrid_tbl_path))

            if create_wrf_input:
                print('Generating wrfinput file')
                geoem_path = new_nml_path.parent / 'geo_em.d01.nc'
                Rstring = "Rscript /home/docker/WRF_WPS/utilities/create_wrfinput.R --geogrid " + \
                str(geoem_path) + " " + \
                "--outfile /home/docker/wrfinput_d01.nc"
                subprocess.run(shlex.split(Rstring))
                shutil.copy('/home/docker/wrfinput_d01.nc',
                            output_dir + '/wrfinput_d01.nc')

    except Exception as e:
        print('Error, cleaning up and exiting')
        shutil.move(str(backup_geogrid_tbl_path),str(original_geogrid_tbl_path))
        raise ChildProcessError(e)


if __name__ == '__main__':
    main()

