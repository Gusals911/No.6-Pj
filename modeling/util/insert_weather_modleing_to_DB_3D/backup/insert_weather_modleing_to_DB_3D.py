import json
import os
from datetime import datetime
import requests
import pymysql
import pandas as pd
from sqlalchemy import create_engine


script_dir = os.path.dirname(os.path.realpath(__file__))    # Current File Location
CONFIG_FILE = script_dir+"/config.json"     # Config.json File DIR

if __name__ == "__main__":
    with open(CONFIG_FILE, "r") as f:
        config = json.load(f)   # load config
    regDatetime = datetime.strftime(datetime.now(), "%Y-%m-%d %H:%M:%S")    # set register date time
    
    MYSQL_HOSTNAME = config["DATABASE_ADDRESS"]
    MYSQL_PORT = config["DATABASE_PORT"]
    MYSQL_USER = config["DATABASE_USER"]
    MYSQL_PASSWORD = config["DATABASE_PASSWD"]
    MYSQL_DATABASE = config["DATABASE_SCHEMA"]
    MYSQL_MODEL = config["DATABASE_MODELING_TABLE"]
    MYSQL_WEATHER = config["DATABASE_WEATHER_TABLE"]
    DATA_DIR = config["DATA_DIR"]

    engine = create_engine("mysql+pymysql://"+MYSQL_USER+':'+MYSQL_PASSWORD+'@'+MYSQL_HOSTNAME+':'+MYSQL_PORT+'/'+MYSQL_DATABASE+"?charset=utf8", encoding='utf8')
    conn = engine.connect()


    dirList = os.listdir(DATA_DIR) # import conc.csv file directory
    dirList.sort(reverse=True)  # Sort by Latest
    dataDirectory = dirList[0]  # import latest time directory

    fileList = os.listdir(DATA_DIR+'/'+dataDirectory)
    fileList.sort(reverse=True)
    for dataFile in fileList:
        if dataFile.startswith(config["DATA_HEADER"]):
            break
    
    if config["LAST_UPDATE_FILE"] == dataFile:
        print("There are no updates.")
        exit()

    
    modelData = pd.read_csv(DATA_DIR+'/'+dataDirectory+'/'+dataFile, sep=',')

    modelData = modelData[modelData['conc1'] > 0] 
    reg_date = [[regDatetime] for i in range(len(modelData))]
    modelData = modelData.reset_index()
    modelData.columns = ['lon','lat','conc1','conc2','conc3','conc4','conc5','conc6','conc7','conc8','conc9','conc10', 'null']
    del modelData['null']

    modelData = modelData.assign(reg_date = reg_date)
    modelData = modelData.assign(e_idx = 0)
    
    
    url = "http://api.openweathermap.org/data/2.5/weather?lat=%s&lon=%s&APPID=%s"%(
        config["WEATHER_LATITUDE"], config["WEATHER_LONGITUDE"], config["WEATHER_API_KEY"])     # weather api url / import data(LAT/LNG, API Key) from config.json file

    response = requests.get(url)
    weatherDict = json.loads(response.text)
    regDateTimeForWeather = [regDatetime]
    weatherData = pd.DataFrame({
        'wind_dir' : weatherDict["wind"]["deg"],
        'wind_spd' : weatherDict["wind"]["speed"],
        'temp' : weatherDict["main"]["temp"],
        'humi' : weatherDict["main"]["humidity"],
        'pressure' : weatherDict["main"]["pressure"],
        'reg_date' : regDateTimeForWeather
    })


    # Insert conc values
    modelData.to_sql(name=MYSQL_MODEL, con=engine, if_exists='append', index=False)


    # # Insert weather data
    weatherData.to_sql(name=MYSQL_WEATHER, con=engine, if_exists='append', index=False)


    # Save Last update file name
    # Prevent duplicate upload to DB
    config["LAST_UPDATE_FILE"] = dataFile
    with open(CONFIG_FILE, "w") as f:
        json.dump(config, f, indent=0)
    

    value = config["VALUE"]
    v = 1
    while (v <= value):
            fileList = os.listdir(DATA_DIR+'/'+dataDirectory+'/eachdata')
            fileList.sort()
            for dataFile in fileList:
                if dataFile.endswith("ll%d", v):
                    break
            modelData = pd.read_csv(DATA_DIR+'/'+dataDirectory+'/eachdata/'+dataFile)
            modelData = modelData[modelData['conc1'] > 0]
            reg_date = [[regDatetime] for i in range(len(modelData))]
            modelData = modelData.reset_index()
            modelData.columns = ['lon','lat','conc1','conc2','conc3','conc4','conc5','conc6','conc7','conc8','conc9','conc10', 'null']
            del modelData['null']
            modelData = modelData.assign(reg_date = reg_date)
            modelData = modelData.assign(e_idx = v)
            
            modelData.to_sql(name=MYSQL_MODEL, con=engine, if_exists='append', index=False)

            v += 1
            
    conn.close()    # DB close