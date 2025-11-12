import json
import os
import re
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

    engine = create_engine("mysql+pymysql://"+MYSQL_USER+':'+MYSQL_PASSWORD+'@'+MYSQL_HOSTNAME+':'+MYSQL_PORT+'/'+MYSQL_DATABASE+"?charset=utf8mb4")
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

    print(DATA_DIR+'/'+dataDirectory+'/'+dataFile)
    modelData = pd.read_csv(DATA_DIR+'/'+dataDirectory+'/'+dataFile, skipinitialspace=True)
    
    # Clean column names (remove extra spaces)
    modelData.columns = modelData.columns.str.strip()
    
    # Check if columns are already named correctly
    if 'lon' in modelData.columns and 'lat' in modelData.columns:
        # Columns are already named correctly, just ensure order and remove any extra columns
        required_cols = ['lon', 'lat', 'conc1', 'conc2', 'conc3', 'conc4', 'conc5', 'conc6', 'conc7', 'conc8', 'conc9', 'conc10']
        # Keep only required columns and ensure correct order
        existing_cols = [col for col in required_cols if col in modelData.columns]
        modelData = modelData[existing_cols]
        # Reorder to match required order
        modelData = modelData[required_cols]
    else:
        # CSV doesn't have headers or has different structure - assign column names by position
        modelData = modelData.reset_index(drop=True)
        if len(modelData.columns) == 12:
            modelData.columns = ['lon','lat','conc1','conc2','conc3','conc4','conc5','conc6','conc7','conc8','conc9','conc10']
        elif len(modelData.columns) == 13:
            modelData.columns = ['lon','lat','conc1','conc2','conc3','conc4','conc5','conc6','conc7','conc8','conc9','conc10', 'null']
            del modelData['null']
        else:
            raise ValueError(f"Unexpected number of columns ({len(modelData.columns)}). Expected 12 or 13.")
    
    modelData = modelData[modelData['conc1'] > 0]
    reg_date = [[regDatetime] for i in range(len(modelData))]
    modelData = modelData.reset_index(drop=True)
    print(f"Processing {len(modelData)} rows with conc1 > 0")
    print(modelData[['lon', 'lat', 'conc1']].head())

    modelData = modelData.assign(reg_date = reg_date)
    modelData = modelData.assign(e_idx = 0)
    
    # Reorder columns to match database table structure: e_idx, lat, lon, conc1-10, reg_date
    # Database expects: e_idx, lat, lon, conc1, conc2, ..., conc10, reg_date
    column_order = ['e_idx', 'lat', 'lon', 'conc1', 'conc2', 'conc3', 'conc4', 'conc5', 'conc6', 'conc7', 'conc8', 'conc9', 'conc10', 'reg_date']
    modelData = modelData[column_order]
    
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
    
    # Extract date from filename (e.g., conc.202511072324.csv -> 202511072324)
    date_match = re.search(r'(\d{12})', dataFile)
    if date_match:
        date_str = date_match.group(1)
    else:
        # Fallback: try to extract from filename position
        if len(dataFile) > 17:
            date_str = dataFile[5:17]  # Skip "conc." and take 12 digits
        else:
            date_str = dataFile.replace('conc.', '').replace('.csv', '')
    
    value = config["VALUE"]
    v = 1
    while (v <= value):
            # Pattern: conc.YYYYMMDDHHMMll{N}.csv
            endfile = "ll" + str(v) + ".csv"
            eachdata_dir = DATA_DIR+'/'+dataDirectory+'/eachdata'
            if not os.path.exists(eachdata_dir):
                print(f"Warning: Directory {eachdata_dir} does not exist. Skipping individual files.")
                break
            fileList = os.listdir(eachdata_dir)
            fileList.sort()
            print(f"Looking for file ending with: {endfile}")
            dataFile_found = None
            for f in fileList:
                if f.endswith(endfile) and date_str in f:
                    dataFile_found = f
                    break
            if dataFile_found is None:
                print(f"Warning: File ending with {endfile} not found. Skipping.")
                v += 1
                continue
            modelData = pd.read_csv(eachdata_dir + '/' + dataFile_found, skipinitialspace=True)
            print(dataFile_found + "  Insert!")
            
            # Clean column names
            modelData.columns = modelData.columns.str.strip()
            
            # Check if columns are already named correctly
            if 'lon' in modelData.columns and 'lat' in modelData.columns:
                required_cols = ['lon', 'lat', 'conc1', 'conc2', 'conc3', 'conc4', 'conc5', 'conc6', 'conc7', 'conc8', 'conc9', 'conc10']
                existing_cols = [col for col in required_cols if col in modelData.columns]
                modelData = modelData[existing_cols]
                modelData = modelData[required_cols]
            else:
                modelData = modelData.reset_index(drop=True)
                if len(modelData.columns) == 12:
                    modelData.columns = ['lon','lat','conc1','conc2','conc3','conc4','conc5','conc6','conc7','conc8','conc9','conc10']
                elif len(modelData.columns) == 13:
                    modelData.columns = ['lon','lat','conc1','conc2','conc3','conc4','conc5','conc6','conc7','conc8','conc9','conc10', 'null']
                    del modelData['null']
            
            modelData = modelData[modelData['conc1'] > 0]
            reg_date = [[regDatetime] for i in range(len(modelData))]
            modelData = modelData.reset_index(drop=True)
            modelData = modelData.assign(reg_date = reg_date)
            modelData = modelData.assign(e_idx = v)
            
            # Reorder columns to match database table structure: e_idx, lat, lon, conc1-10, reg_date
            column_order = ['e_idx', 'lat', 'lon', 'conc1', 'conc2', 'conc3', 'conc4', 'conc5', 'conc6', 'conc7', 'conc8', 'conc9', 'conc10', 'reg_date']
            modelData = modelData[column_order]
            
            modelData.to_sql(name=MYSQL_MODEL, con=engine, if_exists='append', index=False)

            v += 1
            
    conn.close()    # DB close