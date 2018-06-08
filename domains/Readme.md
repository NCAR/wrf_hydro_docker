# Overview 

These docker data containers are used primarily by the WRF-Hydro development team. If you are
searching for an example test case for general use, please see
https://ral.ucar.edu/projects/wrf_hydro/testcases.

Generally, these docker domain containers are used with a volume mount to one of our `wrfhydro/dev`
containers to create a modular docker environment that contains a domain and a WRF-Hydro development environment.

# Usage
For example:

```
docker pull wrfhydro/dev:base
docker pull wrfhydro/domains:croton_NY
```

```
docker create --name croton_NY wrfhydro/domains:croton_NY
docker run --volumes-from croton_NY -it wrfhydro/dev:base
```

