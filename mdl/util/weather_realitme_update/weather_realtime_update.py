import json
import os   
import pymysql

CONFIG_FILE = os.getcwd() + "/config.json"
UTIL_SAMPLE_DIR = os.getcwd() + "/sample/"
LAST_DATA = "/home/mdl/inp/surf/lastdata"
def readTextFile(path):
    with open(path, "r") as f:
        text = f.read()
    return text

def writeTextFile(path, text):
    with open(path, "w") as f:
        f.write(text)

if __name__ == "__main__":
    print(CONFIG_FILE)
    with open(CONFIG_FILE, "r") as f:
        config = json.load(f)
    
    sampleLastdata = readTextFile(UTIL_SAMPLE_DIR + config["SAMPLE_LASTDATA"])
    sampleLastdataData = readTextFile(UTIL_SAMPLE_DIR + config["SAMPLE_LASTDATA_DATA"])
    
    database = pymysql.connect(
        host = config["DATABASE_ADDRESS"],
        port = config["DATABASE_PORT"],
        user = config["DATABASE_USER"],
        password = config["DATABASE_PASSWD"],
        db = config["DATABASE_SCHEMA"]
    )
    cursor = database.cursor()

    sql = "select wind_spd, wind_dir, temp, humi from modeling_weather1 order by reg_date desc limit 1"
    cursor.execute(sql)

    windSpeed, windDirection, temperature, humidity = cursor.fetchone()
    temperature = round(temperature + 273.15, 2)

    sampleLastdataData = sampleLastdataData%(windSpeed, windDirection, temperature, humidity)
    sampleLastdata = sampleLastdata%(sampleLastdataData)

    writeTextFile(LAST_DATA, sampleLastdata)
    print(sampleLastdata)
    cursor.close()
    database.close()
