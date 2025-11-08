# Modeling Output Processing Workflow

## Overview
This guide explains what to do when you receive modeling output from your team. The workflow involves processing CSV files from CALPUFF/CALMET modeling and inserting them into the MySQL database for visualization in the web application.

## Step-by-Step Process

### 1. **Receive Modeling Output Files**

Your team should provide modeling output in the following format:

#### File Structure:
```
modeling_output/
├── YYYYMMDDHHMM/                    # Directory named with timestamp
│   ├── conc.YYYYMMDDHHMM.csv        # Main concentration file (e_idx=0)
│   └── eachdata/                    # Individual emission source data
│       ├── YYYYMMDDll1.csv          # Emission source 1 (e_idx=1)
│       ├── YYYYMMDDll2.csv          # Emission source 2 (e_idx=2)
│       ├── YYYYMMDDll3.csv          # Emission source 3 (e_idx=3)
│       └── ...                      # Up to VALUE (default 21)
```

#### CSV File Format:
Each CSV file must have the following columns (in order):
```csv
lon,lat,conc1,conc2,conc3,conc4,conc5,conc6,conc7,conc8,conc9,conc10,null
```

**Important:**
- Files must be comma-separated CSV
- Column order: longitude, latitude, conc1-10, then a null column
- Only rows with `conc1 > 0` will be inserted (filtered automatically)
- File naming:
  - Main file: `conc.YYYYMMDDHHMM.csv` (e.g., `conc.202509282241.csv`)
  - Individual files: `YYYYMMDDll{N}.csv` (e.g., `20250928ll1.csv`)

### 2. **Configure Database Connection**

Update the configuration file for your local environment:

**File:** `modeling/util/insert_weather_modleing_to_DB_3D/config.json`

```json
{
  "DATABASE_MODELING_TABLE": "modeling_data1",
  "WEATHER_LATITUDE": 35.456552,
  "DATA_DIR": "/path/to/your/modeling_output_directory",
  "LAST_UPDATE_FILE": "",
  "DATABASE_WEATHER_TABLE": "modeling_weather1",
  "DATABASE_ADDRESS": "localhost",
  "WEATHER_API_KEY": "your_openweather_api_key",
  "WEATHER_LONGITUDE": 129.327667,
  "DATA_HEADER": "conc",
  "VALUE": 21,
  "DATABASE_PORT": "3306",
  "DATABASE_SCHEMA": "tseiweb",
  "DATABASE_PASSWD": "1234",
  "DATABASE_USER": "root"
}
```

**Configuration Parameters:**
- `DATA_DIR`: Path to directory containing timestamped subdirectories with CSV files
- `DATABASE_ADDRESS`: Change from `192.168.200.171` to `localhost` for local setup
- `DATABASE_USER`: Change from `modeling` to `root` for local setup
- `DATABASE_PASSWD`: Change from `tsei1234` to `1234` for local setup
- `VALUE`: Number of individual emission sources (default: 21)
- `WEATHER_API_KEY`: Your OpenWeatherMap API key (for weather data)

### 3. **Place Files in Correct Directory**

1. Copy the modeling output directory structure to the path specified in `DATA_DIR`
2. Ensure the directory structure matches the expected format:
   ```
   DATA_DIR/
   └── YYYYMMDDHHMM/          # Latest timestamp directory
       ├── conc.YYYYMMDDHHMM.csv
       └── eachdata/
           ├── YYYYMMDDll1.csv
           ├── YYYYMMDDll2.csv
           └── ...
   ```

### 4. **Install Python Dependencies**

The script requires the following Python packages:

```bash
pip install pandas pymysql sqlalchemy requests
```

Or create a `requirements.txt`:
```txt
pandas>=1.3.0
pymysql>=1.0.0
sqlalchemy>=1.4.0
requests>=2.25.0
```

Install with:
```bash
pip install -r requirements.txt
```

### 5. **Run the Data Insertion Script**

```bash
cd modeling/util/insert_weather_modleing_to_DB_3D
python insert_weather_modleing_to_DB_3D.py
```

**What the script does:**
1. ✅ Connects to MySQL database
2. ✅ Finds the latest timestamp directory in `DATA_DIR`
3. ✅ Reads the main `conc.*.csv` file
4. ✅ Filters rows where `conc1 > 0`
5. ✅ Inserts main data with `e_idx=0`
6. ✅ Fetches weather data from OpenWeatherMap API
7. ✅ Inserts weather data into `modeling_weather1` table
8. ✅ Processes individual emission source files (`e_idx=1` to `e_idx=VALUE`)
9. ✅ Prevents duplicate inserts by tracking `LAST_UPDATE_FILE`

### 6. **Verify Data Insertion**

Check the database to verify data was inserted:

```bash
export PATH="/opt/homebrew/opt/mysql@8.0/bin:$PATH"
mysql -uroot -p1234 tseiweb -e "SELECT COUNT(*) as total_records, MIN(reg_date) as earliest, MAX(reg_date) as latest FROM modeling_data1;"
mysql -uroot -p1234 tseiweb -e "SELECT * FROM modeling_weather1 ORDER BY reg_date DESC LIMIT 5;"
```

### 7. **View Data in Web Application**

1. Start the Spring Boot application:
   ```bash
   cd TSEI_modeling
   export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Home
   mvn spring-boot:run
   ```

2. Access the web interface:
   - Main modeling page: http://localhost:9084/soms/page3
   - Additional page: http://localhost:9084/soms/page5

3. The web application will:
   - Display available dates via `/soms/date` endpoint
   - Show modeling data on map visualization
   - Allow selection of date/time and emission source (e_idx)
   - Display weather data for selected time period

## Database Schema Reference

### `modeling_data1` Table
- `md_idx`: Auto-increment primary key
- `e_idx`: Emission source index (0 = total, 1-N = individual sources)
- `lat`: Latitude
- `lon`: Longitude
- `conc1` to `conc10`: Concentration values
- `reg_date`: Registration datetime

### `modeling_weather1` Table
- `mw_idx`: Auto-increment primary key
- `wind_dir`: Wind direction (degrees)
- `wind_spd`: Wind speed
- `temp`: Temperature
- `humi`: Humidity
- `pressure`: Pressure
- `reg_date`: Registration datetime

## Troubleshooting

### Issue: "There are no updates"
- **Cause**: The script detected the same file was already processed
- **Solution**: Either:
  - Remove/update `LAST_UPDATE_FILE` in `config.json`, or
  - Ensure new files have different timestamps

### Issue: Database connection error
- **Cause**: Wrong database credentials or MySQL not running
- **Solution**: 
  - Verify MySQL is running: `brew services list | grep mysql`
  - Check credentials in `config.json`
  - Test connection: `mysql -uroot -p1234 -e "SHOW DATABASES;"`

### Issue: File not found
- **Cause**: Wrong `DATA_DIR` path or incorrect file structure
- **Solution**:
  - Verify `DATA_DIR` path in `config.json` is correct
  - Ensure directory structure matches expected format
  - Check file names match pattern (conc.*.csv)

### Issue: Column mismatch error
- **Cause**: CSV file doesn't have expected columns
- **Solution**:
  - Verify CSV has columns: `lon,lat,conc1,conc2,...,conc10,null`
  - Check column order matches exactly
  - Ensure CSV is comma-separated

### Issue: No weather data
- **Cause**: Invalid OpenWeatherMap API key or network issue
- **Solution**:
  - Verify API key in `config.json`
  - Check internet connection
  - Test API: `curl "http://api.openweathermap.org/data/2.5/weather?lat=35.456552&lon=129.327667&APPID=your_key"`

## Automation (Optional)

To automate the process, you can:

1. **Set up a cron job** to run the script periodically:
   ```bash
   # Run every hour
   0 * * * * cd /path/to/modeling/util/insert_weather_modleing_to_DB_3D && python insert_weather_modleing_to_DB_3D.py >> /path/to/logfile.log 2>&1
   ```

2. **Create a watch script** that monitors the output directory:
   ```bash
   # Monitor directory for new files and process automatically
   ```

## Next Steps After Data Insertion

1. ✅ Data is now in the database
2. ✅ Start the web application
3. ✅ Access http://localhost:9084/soms/page3
4. ✅ Select the date/time of the inserted data
5. ✅ View modeling results on the map
6. ✅ Analyze concentration data by emission source (e_idx)

## API Endpoints Available

Once the application is running, these endpoints provide data:

- `GET /soms/date` - Get available modeling dates
- `GET /soms/places` - Get place/location data
- `GET /soms/dataList?selectDate=YYYY-MM-DD&selectTime=HH&e_idx=0&c_idx=1` - Get modeling data
- `GET /soms/weatherList?selectDate=YYYY-MM-DD&selectTime=HH` - Get weather data
- `GET /soms/aplaceList?e_index=0&lat=35.45&lon=129.32&selectDate=YYYY-MM-DD&selectTime=HH&conc=1` - Get concentration at specific location

## Notes

- The script automatically filters out rows where `conc1 = 0`
- Duplicate prevention: Script tracks `LAST_UPDATE_FILE` to avoid re-processing
- Weather data is fetched from OpenWeatherMap API in real-time when script runs
- Database uses partitioning by year for performance
- `e_idx=0` represents total/combined concentration
- `e_idx=1` to `e_idx=VALUE` represent individual emission sources

