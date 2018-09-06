import subprocess
from argparse import ArgumentParser
from argparse import RawTextHelpFormatter

def main():
    parser = ArgumentParser(description='Docker container for WRF-Hydro model testing using a '
                                        'small, single-node domain.\n'
            'Example usage:\n '
            'docker run \ \n'
            '-v <local_system_path_for_candidate>/wrf_hydro_nwm_public/:/home/docker/candidate \ \n'
            '-v <local_system_path_for_reference>/wrf_hydro_nwm_public/:/home/docker/reference \ \n'
            'wrfhydro/dev:modeltesting --config nwm_ana gridded --domain_tag v5.0.1\n\n'
            
            'To run interactively:\n' 
            'docker run \ \n'
            '--entrypoint="bash" \ \n'
            '-v <local_system_path_for_candidate>/wrf_hydro_nwm_public/:/home/docker/candidate \ \n'
            '-v <local_system_path_for_reference>/wrf_hydro_nwm_public/:/home/docker/reference \ \n'
            'wrfhydro/dev:modeltesting \n\n'
    
            'To mount a user supplied domain add a volume mount like so:\n'
            '-v <local_system_path_for_domain_dir>/:/home/docker/example_case\n\n'

                                    
            'The candidate is the source code you would like to test and'
            ' the reference is the source code you would like to regress'
            ' the candidate against for regression testing. These '
            'directories reside on your local system and need to be '
            'volume mounted into the Docker container file system. Likewise, a domain directory '
            'can be mounted into the container \n\n'
    
            '**DO NOT EDIT THE DOCKER SYSTEM PATH OF THE VOLUME MOUNTS, '
            'THIS IS HARD CODED INTO THE TESTING**',formatter_class=RawTextHelpFormatter)

    parser.add_argument("--config",
                        dest="config",
                        required=True,
                        nargs='+',
                        help="<Required> The configuration(s) to test, "
                             "must be one listed in hydro_namelist.json keys.")
    parser.add_argument("--domain_tag",
                        help="The release tag of the domain to use, e.g. v5.0.1. Alternatively, "
                             "mount a local domain to /home/docker/example_case. If a local domain "
                             "is mounted, the mounted domain will be used regardless of tag option")

    args = parser.parse_args()

    run_tests_cmd = "python candidate/tests/local/run_tests.py" \
                    " --compiler gfort" \
                    " --output_dir /home/docker/test_out" \
                    " --candidate_dir /home/docker/candidate " \
                    " --reference_dir /home/docker/reference " \
                    " --domain_dir /home/docker/example_case " \
                    " --print"
    run_tests_cmd += " --config " + ' '.join(args.config)
    if args.domain_tag is not None:
        run_tests_cmd += " --domain_tag " + args.domain_tag

    test_proc = subprocess.run(run_tests_cmd,
                   shell=True,
                   cwd='/home/docker')

    exit(test_proc.returncode)
if __name__ == '__main__':
    main()