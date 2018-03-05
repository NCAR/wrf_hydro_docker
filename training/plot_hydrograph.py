# Force matplotlib to not use any Xwindows backend.
import matplotlib
matplotlib.use('Agg')

import sys
from plotnine import *
import xarray as xr
import pandas as pd

def plot_hydrographs(channel_files: list,image_filename: str,feature_id: int,obs_file: str=None)->str:
    """Example function to plot a timeseries of streamflow for a given feature_id from wrf_hydro CHANOBS files.

    Args:
        channel_files: A list of CHANOBS output files from wrf-hydro > v5.0
        image_filename: A string path for .png plot output filename.
        feature_id: The feature_id to plot
        obs_file: An optional string path to an observed value csv file with the following structure, col1 = site number,
        col2 = datetime, col3 = streamflow, m/s

    Returns:
        A string including the plot file output path.
    """

    #Open the netcdfdataset
    chrtout_data = xr.open_mfdataset(channel_files)

    #Select one feature_id, optional. Can load all into memory by omitting this
    #Note that this is still subject to the same limitations of HDF5/netCDF4. Non-contiguous indices
    #can't be extracted in one disk read. Thus, if selecting many non-contiguous indices
    #from many files, it is almost always much slower than loading into memory before subsetting
    chrtout_data = chrtout_data.loc[dict(feature_id=feature_id)]

    #Load into memory as a pandas.dataframe
    chrtout_data = chrtout_data.to_dataframe()

    #Flatten index into a variable for plotting
    chrtout_data = chrtout_data.reset_index(level='time')

    #Make feature id a string for plotting
    chrtout_data['feature_id'] = chrtout_data['feature_id'].astype(str)


    #optionaly get the observed data
    if obs_file is not None:
        obs_data = pd.read_csv(obs_file)
        obs_data['dateTime']=pd.to_datetime(obs_data['dateTime'])
        obs_data=obs_data.rename(index=str,columns={'dateTime':'time','streamflow_cms':'streamflow_obs'})

        chrtout_data = chrtout_data.rename(index=str,columns={'streamflow':'streamflow_mod'})
        chrtout_data = chrtout_data[['feature_id','time','streamflow_mod']]
        chrtout_data = pd.merge(chrtout_data,obs_data,
                                how='left',
                                left_on=['time'],
                                right_on=['time'])
        chrtout_data=pd.melt(chrtout_data,id_vars=['feature_id','site_no','time'])

        #Plot it
        hydrograph = ggplot(chrtout_data,aes(x='time',y='value',color='variable')) + \
            geom_line() + \
            scale_x_datetime(breaks='1 days') + \
            labs(x='Date',y='Streamflow, cms',title='Modelled and Observed streamflow at West Branch of Croton River, USGS site 01374559') + \
            theme_bw()
        hydrograph.save(image_filename,'png',height=8,width=8)
    else:
        #Plot it
        hydrograph = ggplot(chrtout_data,aes(x='time',y='streamflow')) + \
            geom_line() + \
            scale_x_datetime(breaks='1 days') + \
            labs(x='Date',y='Streamflow, cms',title='Modelled streamflow at West Branch of Croton River, USGS site 01374559') + \
            theme_bw()
        hydrograph.save(image_filename,'png',height=8,width=8)

    return('Plot saved as '+image_filename)

def main(chanout_dir: str,image_filename: str)->None:
    """Main body of plotting script outputing a plot to the specified filename path.

    Args:
        chanout_dir: A string specifying the directory containing the wrf-hydro CHANOBS files
        filename: A string s[ecifying the output path for the plot.

    Returns:
        Returns None and outputs a plot to the specified path
    """
    channel_files=chanout_dir+'/*CHANOBS*'
    plot_hydrographs(channel_files=channel_files,
                     image_filename=image_filename,
                     feature_id=6226948,
                     obs_file='/home/docker/domain/croton_NY/Croton_usgsObs_01374559.csv')

if __name__ == '__main__':
    main(chanout_dir=sys.argv[1],image_filename=sys.argv[2])
