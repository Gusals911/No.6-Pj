import json
import os   
import pymysql

script_dir = os.path.dirname(os.path.realpath(__file__))
CONFIG_FILE = script_dir+"/config.json"

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
    
    sampleLastdata = readTextFile("%s/%s/%s"%(script_dir, config["SAMPLE_DIR"], config["SAMPLE_LASTDATA"]))
    sampleLastdataData = readTextFile("%s/%s/%s"%(script_dir, config["SAMPLE_DIR"], config["SAMPLE_LASTDATA_DATA"]))
    
    database = pymysql.connect(
        host = config["DATABASE_ADDRESS"],
        port = config["DATABASE_PORT"],
        user = config["DATABASE_USER"],
        password = config["DATABASE_PASSWD"],
        db = config["DATABASE_SCHEMA"]
    )
    cursor = database.cursor()

    sql = "select wd_wds, wd_wdd, wd_temp, wd_humi from weather_data order by reg_date desc limit 1"
    cursor.execute(sql)

    windSpeed, windDirection, temperature, humidity = cursor.fetchone()
    temperature = round(temperature + 273.15, 2)

    sampleLastdataData = sampleLastdataData%(windSpeed, windDirection, temperature, humidity)
    sampleLastdata = sampleLastdata%(sampleLastdataData)

    os.makedirs("/".join(config["LASTDATA_PATH"].split("/")[:-1]), exist_ok=True)
    writeTextFile(config["LASTDATA_PATH"], sampleLastdata)

    cursor.close()
    database.close()
