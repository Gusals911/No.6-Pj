import json
import os
from datetime import datetime
import pymysql

script_dir = os.path.dirname(os.path.realpath(__file__))    # Current File Location
CONFIG_FILE = script_dir+"/config.json"     # Config.json File DIR
aerror = 0.00044
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

    # index=0 initialized first place
    # p_index -> place index
    # a_index -> affected by place_index
    sql = 'SELECT lat, lon, name, p_index FROM test_place_data WHERE idx=0'
    cursor.execute(sql)
    places = cursor.fetchall()
    print(places)


    result = []
    value = config["VALUE"]
    for i in range(len(places)):
        # print(places[i]['name'])
        lat = places[i]['lat']
        lon = places[i]['lon']
        p_index = places[i]['p_index']
        for j in range(value+1):
            if(j!=0):
                sql = 'SELECT conc1, reg_date, e_idx FROM modeling_data1 ' \
                      'WHERE e_idx={0} ' \
                      'AND lat BETWEEN {1} AND {2}' \
                      'AND lon BETWEEN {3} AND {4}' \
                      'AND reg_date IN(SELECT MAX(reg_date) FROM modeling_data1)'.format(j, lat-aerror, lat+aerror, lon-aerror, lon+aerror)
                cursor.execute(sql)
                test_result = cursor.fetchall()


                if(len(test_result) != 0):
                    for k in range(len(test_result)):
                        dict = {'lat': 0, 'lon': 0, 'name':places[test_result[k]['e_idx']]['name'], 'idx':1, 'a_index':places[test_result[k]['e_idx']]['p_index'], 'p_index':p_index, 'a_conc':test_result[k]['conc1'], 'reg_date':test_result[0]['reg_date']}
                        result.append(dict)
                        # print(i, places[i]['name'], "is affected by ", j-1, places[j-1]['name'], test_result)
                        print("Add a place(", places[i]['name'], ") is affected by ", places[test_result[k]['e_idx']]['name']);

    print(result)

    try:
        sql = "INSERT INTO test_place_data VALUES (0, %(lat)s, %(lon)s, %(name)s, %(idx)s, %(a_index)s, %(p_index)s, %(a_conc)s, %(reg_date)s)"
        cursor.executemany(sql, result)
        mysqldb.commit()
    except Exception as e:
        print("DB INSERT ERROR, ", e)
    mysqldb.close()