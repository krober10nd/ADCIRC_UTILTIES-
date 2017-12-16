# ADCIRC_UTILTIES-
Utilities for adcirc.

Readfort14 -->  read an adcirc mesh into MATLAB. 
Writefort14 --> write an adcirc mesh into a adcirc-compliant mesh file.
PlotTimeSeries --> plot sync'ed timeseries data from syncIMEDS_v1.5.py 
createxml --> creates an xml file for our webserver to visualize results on gmaps (may no longer work as browsers changes).
movebathy --> interpolates bathy between meshes using linear interpolation. 
syncIMEDS_v1.5.py --> synchrnoizes IMEDS files in time to be easily plotted (requires extStaIMEDS.sh).
interp_tides --> takes an adcirc mesh with an ocean bou and puts the tidal consts. on it. 
transfer_attr --> transfers nodal attributes between meshes. 
download_noaa_data --> downloads NOAA guage data into csv (requires a list of the station IDs). 
writenoaaImeds --> takes the csv's dl'ed from download_nooa_data and formats them into an IMEDS compliant file. 
readfort13 --> reads in an adcirc compliant fort.13 file
writefort13 --> writes an adcric complaint fort.13 file.

