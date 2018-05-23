import f90nml
import subprocess
import sys
from argparse import ArgumentParser
import pathlib
import copy

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

    print('New namelist written to ' + new_nml_path)
    return(None)


#def plot_domain(ref_lat: float,ref_lon: float,x: int,y: int):

import pyproj



def main():

    parser = ArgumentParser()
    parser.add_argument("--patch_nml_path",
                        dest="patch_nml_path",
                        help="Path to namelist file containing the namelist updates")
    parser.add_argument("--orig_nml_path",
                        dest="orig_nml_path",
                        default='/home/docker/WRF_WPS/WPS/namelist.wps_orig',
                        help="Path to original wps namelist")
    parser.add_argument("--new_nml_path",
                        dest="new_nml_path",
                        default='/home/docker/WRF_WPS/WPS/namelist.wps',
                        help="Path to write the new namelist file with updates applied."
                             "Note this path must be the same as the directory containing "
                             "geogrid.exe")
    parser.add_argument("--plot",
                        dest="plot",
                        default='False',
                        help="Create a plot of the domain. Geogrid will not be created if "
                             "show_plot = True, only a plot of the domain.")
    args = parser.parse_args()

    orig_nml_path = args.orig_nml_path
    new_nml_path = args.new_nml_path
    patch_nml_path = args.patch_nml_path
    plot = bool(args.plot)

    if plot:
        None
        # Run plotting function
    else:
        # First patch the namelist
        patch_namelist(orig_nml_path=orig_nml_path,
                       patch_nml_path=patch_nml_path,
                       new_nml_path=new_nml_path)

        # Now run geogrid.exe
        subprocess.run(['./geogrid.exe'],
                       cwd=pathlib.Path(new_nml_path).parent,
                       stdout=subprocess.PIPE,
                       stderr=subprocess.PIPE)


if __name__ == '__main__':
    main()

