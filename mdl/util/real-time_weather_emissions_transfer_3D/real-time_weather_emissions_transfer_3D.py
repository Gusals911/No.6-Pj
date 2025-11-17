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
    with open(CONFIG_FILE, "r") as f:
        config = json.load(f)
    
    sampleEmissions = readTextFile("%s/%s/%s"%(script_dir,config["SAMPLE_DIR"], config["SAMPLE_EMISSIONS"]))
    sampleEmissionsDeviceData = readTextFile("%s/%s/%s"%(script_dir,config["SAMPLE_DIR"], config["SAMPLE_EMISSIONS_DEVICE_DATA"]))
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

    sql = "select wspd, wdir, temp, humi from weather order by mdate desc limit 1"
    cursor.execute(sql)

    windSpeed, windDirection, temperature, humidity = cursor.fetchone()
    temperature = round(temperature + 273.15, 2)

    sampleLastdataData = sampleLastdataData%(windSpeed, windDirection, temperature, humidity)
    sampleLastdata = sampleLastdata%(sampleLastdataData)

    os.makedirs("/".join(config["LASTDATA_PATH"].split("/")[:-1]), exist_ok=True)
    writeTextFile(config["LASTDATA_PATH"], sampleLastdata)

#    totalEmissionsDeviceData = ""
#        for key, value in config["EMISSIONS"].items():
#        sql = "select ou from oms where dev_id=%s order by mdate desc limit 1"%(key)
#        cursor.execute(sql)
#        ou = cursor.fetchone()[0]

        # tmpEmissionsDeviceData = sampleEmissionsDeviceData%(
        #     int(key), value["tmx"], value["tmy"], value["height"],
        #     value["diameter"], value["speed"], value["temperature"], ou
        # )
#        tmpEmissionsDeviceData = sampleEmissionsDeviceData%(
#            int(key), value["tmx"], value["tmy"], value["height"],
#            value["diameter"], value["speed"], temperature, ou
#        )
#        tmpEmissionsDeviceData = "\n".join(
#            ["%4d ! "%(int(key))+tEDD for tEDD in tmpEmissionsDeviceData.split("\n")]
#        ) + "\n"

#        totalEmissionsDeviceData += "\n" + tmpEmissionsDeviceData
#    sampleEmissions = sampleEmissions%(totalEmissionsDeviceData)

#    os.makedirs("/".join(config["EMISSIONS_PATH"].split("/")[:-1]), exist_ok=True)
#    writeTextFile(config["EMISSIONS_PATH"], sampleEmissions)

    cursor.close()
    database.close()
