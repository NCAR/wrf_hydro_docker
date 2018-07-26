import subprocess
import pathlib
from argparse import ArgumentParser
import shutil

from releaseapi import get_release_asset
from gdrive_download import download_file_from_google_drive

def run_tests(config: str):
    """Function to run wrf_hydro_nwm pytests
        Args:
            config: The config to run, must be one listed in hydro_namelist.json keys.
            E.g. 'nwm_ana'
    """
    pytest_cmd = "pytest -v --ignore local " \
                 "--compiler gfort " \
                 "--domain_dir /home/docker/example_case/ " \
                 "--candidate_dir /home/docker/candidate_copy/trunk/NDHMS " \
                 "--reference_dir /home/docker/reference_copy/trunk/NDHMS " \
                 "--output_dir /home/docker/mount/test_out "
    pytest_cmd += "--config " + config + " "

    tests = subprocess.run(pytest_cmd,
                   shell=True,
                   cwd=str('/home/docker/candidate/tests'))
    return(tests)


def main():
    parser = ArgumentParser(description='Docker container for WRF-Hydro model testing using a '
                                        'small, single-node domain.\n'
            'Example usage:\n '
            'docker run \ \n'
            '-v <local_system_path_for_candidate>/wrf_hydro_nwm_public/:/home/docker/candidate \ \n'
            '-v <local_system_path_for_reference>/wrf_hydro_nwm_public/:/home/docker/reference \ \n'
            'wrfhydro/dev:modeltesting --config nwm_ana --tag v5.0.1\n'
            
            'The candidate is the source code you would like to test and'
            ' the reference is the source code you would like to regress'
            ' the candidate against for regression testing. These '
            'directories reside on your local system and need to be '
            'volume mounted into the Docker container file system. \n'
            '**DO NOT EDIT THE DOCKER SYSTEM PATH OF THE VOLUME MOUNTS, '
            'THIS IS HARD CODED INTO THE TESTING**')

    parser.add_argument("--config",
                        dest="config",
                        required=True,
                        nargs='+',
                        help="<Required> The configuration(s) to test, "
                             "must be one listed in hydro_namelist.json keys.")
    parser.add_argument("--tag",
                        dest="tag",
                        help="The release tag of the domain to use, e.g. v5.0.1. Alternatively, "
                             "mount a local domain to /home/docker/example_case. If a local domain "
                             "is mounted, the mounted domain will be used regardless of tag option")
    args = parser.parse_args()

    # Make symlnks of candidate and reference as not to potentially pollute mounted dirs
    ## Make source code paths
    candidate_path = pathlib.Path('/home/docker/candidate')
    reference_path = pathlib.Path('/home/docker/reference')

    ## Make symlnk paths
    candidate_copy = pathlib.Path('/home/docker/candidate_copy')
    reference_copy = pathlib.Path('/home/docker/reference_copy')

    ## Remove if exist and make if not
    if candidate_copy.is_dir():
        shutil.rmtree(str(candidate_copy))
    if reference_copy.is_dir():
        shutil.rmtree(str(reference_copy))

    ## copy directories to avoid polluting user source code directories
    shutil.copytree(str(candidate_path),str(candidate_copy),symlinks=True)
    shutil.copytree(str(reference_path),str(reference_copy),symlinks=True)

    # Check if a domain is mounted and if not grab test case
    domain_dir = pathlib.Path('/home/docker/example_case')
    if not domain_dir.is_dir():
        # Get the test case
        if args.tag is not None:
            get_release_asset(download_dir='/home/docker',
                              repo_name='NCAR/wrf_hydro_nwm_public',
                              tag=args.tag,
                              asset_name='testcase')
        else:
            file_id = '1EHgWeM8k2-Y3jNMLri6C0u_fIUQIonO_'
            download_file_from_google_drive(file_id, '/home/docker/gdrive_testcase.tar.gz')

        # untar the test case
        untar_cmd = 'tar -xf *testcase*.tar.gz'
        subprocess.run(untar_cmd,
                       shell=True,
                       cwd='/home/docker/')

    # run pytest for each supplied config
    has_failure = False
    for config in args.config:
        print('\n\n############################')
        print('### TESTING ' + config + ' ###')
        print('############################\n\n',flush=True)

        test_result = run_tests(config)
        if test_result.returncode != 0:
            has_failure = True

    # Exit with 1 if failure
    if has_failure:
        print('\n\n############################')
        print('### FAILED ###')
        print('############################\n\n',flush=True)
        exit(1)
    else:
        print('\n\n############################')
        print('### PASSED ###')
        print('############################\n\n',flush=True)
        exit(0)

if __name__ == '__main__':
    main()