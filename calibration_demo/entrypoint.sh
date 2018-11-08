#!/usr/bin/env bash
echo -e "\e[0;49;32m-----------------------------------\e[0m"
echo -e "Training Jupyter notebook server running"
echo
echo "Open your browser to the following address to access notebooks"
echo -e "\033[33;5;7mlocalhost:8484\033[0m"
echo
echo -e "The password to login is:"
echo -e "\033[33;5;7mwrfhydrotraining\033[0m"
echo
echo "Press ctrl-C then type 'y' then press return to shut down container."
echo "NOTE ALL WORK WILL BE LOST UNLESS copied out of the container"

jupyter notebook --ip 0.0.0.0 --no-browser &> /dev/null