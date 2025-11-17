import json
import os
from datetime import datetime
import time
import pymysql

script_dir = os.path.dirname(os.path.realpath(__file__))    # Current File Location
CONFIG_FILE = script_dir+"/config.json"     # Config.json File DIR
diffusion_value = 8
diffusion_late = 0.01
aerror = 0.0005
dx, dy = [-0.0009, 0.0009, 0, 0], [0, 0, -0.0011, 0.0011]

if __name__ == '__main__':
    with open(CONFIG_FILE, "r") as f:
        config = json.load(f)  # load config
    regDatetime = datetime.strftime(datetime.now(), "%Y-%m-%d %H:%M:%S")  # set register date time

    # DB connect
    mysqldb = pymysql.connect(
        user=config["DATABASE_USER"],
        password=config["DATABASE_PASSWD"],
        host=config["DATABASE_ADDRESS"],
        port=int(config["DATABASE_PORT"]),
        db=config["DATABASE_SCHEMA"],
        charset='utf8'
    )
    cursor = mysqldb.cursor(pymysql.cursors.DictCursor)

    value = config["VALUE"]
    for j in range(value+1):
        p_index=10000+j
        sql = 'SELECT lat, lon, conc1, reg_date FROM modeling_data1 WHERE e_idx=%s AND reg_date IN (SELECT MAX(reg_date) FROM modeling_data1)'
        cursor.execute(sql, p_index)
        result = cursor.fetchall()


        for o in range(diffusion_value):
            for i in range(len(result)):
                lat = result[i]['lat']
                lng = result[i]['lon']
                conc = result[i]['conc1']
                for j in range(len(dx)):
                    aa = []
                    tlat = lat + dx[j]
                    tlng = lng + dy[j]
                    dup = False
                    for k in range(len(result)):
                        if (tlat-aerror < result[k].get('lat') < tlat+aerror) and (tlng-aerror < result[k].get('lon') < tlng+aerror):
                            print("Duplication Data Deleted")
                            dup = True
                    if (dup == False):
                        tconc = conc * diffusion_late
                        if(tconc>0.1):
                            reg_date = result[0]['reg_date']
                            dict = {'lat': tlat, 'lon': tlng, 'conc1': tconc, 'reg_date': reg_date}
                            result.append(dict)

        for i in range(len(result)):
            result[i]['e_idx'] = p_index - 10000
            result[i]['conc2'] = 0.0
            result[i]['conc3'] = 0.0
            result[i]['conc4'] = 0.0
            result[i]['conc5'] = 0.0
            result[i]['conc6'] = 0.0
            result[i]['conc7'] = 0.0
            result[i]['conc8'] = 0.0
            result[i]['conc9'] = 0.0
            result[i]['conc10'] = 0.0

        try:
            sql = "INSERT INTO modeling_data1 VALUES (0, %(e_idx)s, %(lat)s, %(lon)s, %(conc1)s, %(conc2)s, %(conc3)s, %(conc4)s, %(conc5)s, %(conc6)s, %(conc7)s, %(conc8)s, %(conc9)s, %(conc10)s, %(reg_date)s)"
            cursor.executemany(sql, result)
            mysqldb.commit()
        except Exception as e:
            print("DB INSERT ERROR, ", e)
    mysqldb.close()
