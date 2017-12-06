#!/usr/bin/python
import datetime
import pandas as pd 
import os,sys, getopt 
##################################################################################################################################################################
#DESCRIPTION: Reads in observed and modeled data in the IMEDS format, synchronizes data in time, and then writes a text file with the sync'ed time series (i.e., intervals that match exactly in time). 
#REQUIREMENTS:Stations have to be named exactly the same way as they appear in both the model and observed IMEDS files.
#stations file has to be in the format: No. of stations \n station name   lat   lon \n yyyy mm dd hh MM SS data \n 
#V2.0,KJR 2016
##################################################################################################################################################################

#command line interface 
def main(argv):
   stationsFile = ''
   obsIMEDfile = ''
   modIMEDfile = ''
   try: 
      opts, args = getopt.getopt(argv, "hm:o:s:" , ["help", "obs=", "mod=","stations="] ) 
   except getopt.GetoptError as err: 
      print ("\nUsage : syncIMEDS.py -o or --obs <observed IMEDS file> -m or --mod = <modeled IMEDS file> -s or --stations = <file with stations names>" )
      sys.exit(2) 
   if len(sys.argv) == 1:  
      print("\nNot enough input arguements. Use --help")
      sys.exit() 
   for opt, arg in opts: 
      if opt in ("-h", "--help"):
         print("\nUsage : syncIMEDS.py -o or --obs= <observed IMEDS file> -m or --mod = <modeled IMEDS file> -s or --stations = <file with stations names> \nReads in observed and modeled data in the IMEDS format, synchronizes data in time, and then writes a csv file with the sync'ed time series (i.e., intervals that match exactly in time). \nREQUIREMENTS:The station's names have to be prefixed with STATION_ and have to be named exactly the same way in both the model and observed IMEDS files. \nStations file has to be in the format: \n No. of stations \n station_name   lat   lon \n yyyy mm dd hh MM SS data \n \nNote that No of stations only appears once at the top of the file.") 
         sys.exit()
      elif opt in ( "-m", "--mod"):
         modIMEDfile = arg 
      elif opt in ( "-o", "--obs"): 
         obsIMEDfile = arg
      elif opt in ( "-s", "--stations"): 
         stationsFile = arg 

   #read in the stations file 
   f = open(stationsFile,'r')
   noStations = f.readline()
   noStations=int(noStations)
   stationNames = f.readlines()

   for i in range(0,noStations): 
      os.system("./extStaIMEDS.sh " + str(obsIMEDfile) + " " + str(stationNames[i].rstrip())) #extract time series data for particular station
      os.system("mv " + str(stationNames[i].rstrip()) + " " + "tempObs")#rename the file to tempObs 

      os.system("./extStaIMEDS.sh " + str(modIMEDfile) + " " + str(stationNames[i].rstrip())) #extract time series data for particular station
      os.system("mv " + str(stationNames[i].rstrip()) + " " + "tempMod")#rename the file to tempMod 

      print 'Processing', stationNames[i].rstrip()
      #use pandas to read in the IMEDS files and sync them in time  
      df_obs=pd.read_csv("tempObs",header=None,names=['y','m','d','h','min','sec','wl'],sep='\s+',parse_dates={'datetime':['y','m','d','h','min','sec']})
      df_obs.index=pd.to_datetime(df_obs['datetime'],format='%Y %m %d %H %M %S') 
      df_obs= df_obs.drop('datetime', 1)
      df_mod=pd.read_csv("tempMod",header=None,names=['y','m','d','h','min','sec','wl'],sep='\s+',parse_dates={'datetime':['y','m','d','h','min','sec']})
      df_mod.index=pd.to_datetime(df_mod['datetime'],format='%Y %m %d %H %M %S')
      df_mod= df_mod.drop('datetime', 1)   
      df_merged=df_obs.merge(df_mod, how='inner', left_index=True, right_index=True,suffixes=('_obs', '_mod')) 
      #write merged file to a csv file 
      df_merged.to_csv("sync_" + stationNames[i].rstrip(),date_format='%Y%m%d%H%M%S') 
      print 'Finished with',stationNames[i].rstrip()
     
      os.system("rm " + "tempMod")
      os.system("rm " + "tempObs")
if __name__ == "__main__":
   main(sys.argv[1:])
