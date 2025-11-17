import csv
import json
import os
from datetime import datetime

import requests
import pymysql


script_dir = os.path.dirname(os.path.realpath(__file__))
CONFIG_FILE = script_dir+"/config.json"

if __name__ == "__main__":
    with open(CONFIG_FILE, "r") as f:
        config = json.load(f)
    regDatetime = datetime.strftime(datetime.now(), "%Y-%m-%d %H:%M:%S")
    
    dirList = os.listdir("%s"%(config["DATA_DIR"]))
    dirList.sort(reverse=True)
    dataDirectory = dirList[0]

    fileList = os.listdir("%s/%s"%(config["DATA_DIR"], dataDirectory))
    fileList.sort(reverse=True)
    for dataFile in fileList:
        if dataFile.startswith(config["DATA_HEADER"]):
            break
    if config["LAST_UPDATE_FILE"] == dataFile:
        exit()

    with open("%s/%s/%s"%(config["DATA_DIR"], dataDirectory, dataFile), "r") as f:
        modelingData = [[float(value) for value in line if len(value)!=0]+[regDatetime] for i, line in enumerate(csv.reader(f)) if i != 0]

    url = "http://api.openweathermap.org/data/2.5/weather?lat=%s&lon=%s&APPID=%s"%(
        config["WEATHER_LATITUDE"], config["WEATHER_LONGITUDE"], config["WEATHER_API_KEY"])

    response = requests.get(url)
    weatherDict = json.loads(response.text)
    weatherData = [
        weatherDict["wind"]["deg"],
        weatherDict["wind"]["speed"],
        weatherDict["main"]["temp"],
        weatherDict["main"]["humidity"],
        weatherDict["main"]["pressure"],
        regDatetime
    ]
    
    database = pymysql.connect(
        host = config["DATABASE_ADDRESS"],
        port = config["DATABASE_PORT"],
        user = config["DATABASE_USER"],
        password = config["DATABASE_PASSWD"],
        db = config["DATABASE_SCHEMA"]
    )
    cursor = database.cursor()

    sql = "insert into %s (lat, lon, conc1, conc2, conc3, conc4, conc5, conc6, conc7, conc8, conc9, conc10, reg_date)"%(config["DATABASE_MODELING_TABLE"])
    sql += " values (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
    with database.cursor() as cursor:
        cursor.executemany(sql, modelingData)
    database.commit()

    sql = "insert into %s (wind_dir, wind_spd, temp, humi, pressure, reg_date)"%(config["DATABASE_WEATHER_TABLE"])
    sql += " values (%s, %s, %s, %s, %s, %s)"
    with database.cursor() as cursor:
        cursor.execute(sql, weatherData)
    database.commit()

    database.close()
    
    config["LAST_UPDATE_FILE"] = dataFile
    with open(CONFIG_FILE, "w") as f:
        json.dump(config, f, indent="\t")
    