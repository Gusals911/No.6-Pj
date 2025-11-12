# Quick Start: Processing Local Modeling Output

This guide helps you process modeling output files that are already on your local machine.

## Prerequisites

- ✅ Modeling output files in: `/Users/mirodilbekfazilov/developer/odor2/20251107/`
- ✅ MySQL 8.0 installed and running
- ✅ Python 3.x with pip
- ✅ Java 11 (Temurin recommended)
- ✅ Maven

## Step-by-Step Workflow

### 1. Verify Your Modeling Output Structure

Check that your files are organized correctly:

```bash
ls -la /Users/mirodilbekfazilov/developer/odor2/20251107/
```

**Expected structure:**
```
20251107/
├── conc.20251107HHMM.csv    # Main concentration file
└── eachdata/                 # Individual emission sources
    ├── 20251107ll1.csv
    ├── 20251107ll2.csv
    ├── 20251107ll3.csv
    └── ... (up to ll21.csv)
```

**CSV Format Requirements:**
- Comma-separated values
- Columns: `lon,lat,conc1,conc2,conc3,conc4,conc5,conc6,conc7,conc8,conc9,conc10,null`
- Main file naming: `conc.YYYYMMDDHHMM.csv`
- Individual files: `YYYYMMDDllN.csv` (where N is 1-21)

### 2. Get OpenWeatherMap API Key

1. Visit: https://openweathermap.org/api
2. Sign up for a free account
3. Generate an API key
4. Keep it handy for the next step

### 3. Create Configuration File

```bash
cd modeling/util/insert_weather_modleing_to_DB_3D

# Copy the example config
cp config.local.json.example config.json

# Edit config.json with your settings
```

**Update these fields in `config.json`:**

```json
{
  "DATABASE_MODELING_TABLE": "modeling_data1",
  "WEATHER_LATITUDE": 35.456552,
  "DATA_DIR": "/Users/mirodilbekfazilov/developer/odor2",
  "LAST_UPDATE_FILE": "",
  "DATABASE_WEATHER_TABLE": "modeling_weather1",
  "DATABASE_ADDRESS": "localhost",
  "WEATHER_API_KEY": "YOUR_ACTUAL_API_KEY_HERE",
  "WEATHER_LONGITUDE": 129.327667,
  "DATA_HEADER": "conc",
  "VALUE": 21,
  "DATABASE_PORT": "3306",
  "DATABASE_SCHEMA": "tseiweb",
  "DATABASE_PASSWD": "1234",
  "DATABASE_USER": "root"
}
```

**Key settings to verify:**
- `DATA_DIR`: Parent directory containing your timestamped subdirectories
- `WEATHER_API_KEY`: Your actual OpenWeatherMap API key
- `DATABASE_USER`: Change to your MySQL username (default: `root`)
- `DATABASE_PASSWD`: Change to your MySQL password (default: `1234`)

### 4. Set Up MySQL Database

**Start MySQL:**
```bash
brew services start mysql@8.0
```

**Create database and tables:**
```bash
# From project root
mysql -uroot -p1234 < modeling_DB/DB구조생성.sql

# Import location data
mysql -uroot -p1234 tseiweb < modeling_DB/place_data_temp입력.sql
```

**Verify database:**
```bash
mysql -uroot -p1234 -e "SHOW DATABASES LIKE 'tseiweb';"
mysql -uroot -p1234 tseiweb -e "SHOW TABLES;"
```

### 5. Install Python Dependencies

```bash
cd modeling/util/insert_weather_modleing_to_DB_3D

# Install required packages
pip install pandas pymysql sqlalchemy requests

# Or use requirements.txt
pip install -r requirements.txt
```

### 6. Run Data Insertion Script

```bash
python insert_weather_modleing_to_DB_3D.py
```

**What the script does:**
1. ✅ Finds the latest timestamp directory in `DATA_DIR` (e.g., `20251107`)
2. ✅ Reads main `conc.*.csv` file
3. ✅ Filters rows where `conc1 > 0`
4. ✅ Inserts data with `e_idx=0` (total concentration)
5. ✅ Fetches current weather data from OpenWeatherMap API
6. ✅ Inserts weather data into database
7. ✅ Processes each individual emission source file (e_idx 1-21)
8. ✅ Updates `LAST_UPDATE_FILE` to prevent duplicates

**Expected output:**
```
/Users/mirodilbekfazilov/developer/odor2/20251107/conc.202511071200.csv
         lon      lat  conc1  conc2  ...
    0  129.xxx  35.xxx   1.23   0.45  ...
    ...
1200ll1.csv  Insert!
1200ll2.csv  Insert!
...
```

### 7. Verify Data Insertion

Check the database:

```bash
# Count total records by emission source
mysql -uroot -p1234 tseiweb -e "
  SELECT e_idx, COUNT(*) as records, MAX(reg_date) as latest_date
  FROM modeling_data1
  GROUP BY e_idx
  ORDER BY e_idx;"

# Check weather data
mysql -uroot -p1234 tseiweb -e "
  SELECT * FROM modeling_weather1
  ORDER BY reg_date DESC
  LIMIT 5;"

# View sample modeling data
mysql -uroot -p1234 tseiweb -e "
  SELECT e_idx, lat, lon, conc1, reg_date
  FROM modeling_data1
  LIMIT 10;"
```

**Expected results:**
- `e_idx=0`: Total concentration (main file)
- `e_idx=1-21`: Individual emission sources
- Each timestamp should have multiple records

### 8. Start Web Application

```bash
cd TSEI_modeling

# Set Java home (adjust path if needed)
export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Home

# Run application
mvn spring-boot:run
```

**Wait for startup message:**
```
Started TseiModelingApplication in X.XXX seconds
```

### 9. Access Web Interface

Open your browser and visit:

- **Main modeling page:** http://localhost:9084/soms/page3
- **Additional page:** http://localhost:9084/soms/page5

**In the web interface:**
1. Select date: `2025-11-07`
2. Select time: based on your file timestamp
3. Select emission source (e_idx): `0` for total, `1-21` for individual sources
4. View concentration data on the map
5. Check weather information

### 10. Test API Endpoints

You can also query the data directly:

```bash
# Get available dates
curl http://localhost:9084/soms/date

# Get modeling data for specific time
curl "http://localhost:9084/soms/dataList?selectDate=2025-11-07&selectTime=12&e_idx=0&c_idx=1"

# Get weather data
curl "http://localhost:9084/soms/weatherList?selectDate=2025-11-07&selectTime=12"

# Get places
curl http://localhost:9084/soms/places
```

## Troubleshooting

### Issue: "There are no updates"

**Cause:** Script detected the same file was already processed

**Solution:**
```bash
# Edit config.json and set LAST_UPDATE_FILE to empty string
"LAST_UPDATE_FILE": ""
```

### Issue: Database connection error

**Cause:** MySQL not running or wrong credentials

**Solution:**
```bash
# Check MySQL status
brew services list | grep mysql

# Start MySQL if not running
brew services start mysql@8.0

# Test connection
mysql -uroot -p1234 -e "SHOW DATABASES;"
```

### Issue: Python module not found

**Cause:** Dependencies not installed

**Solution:**
```bash
# Install all dependencies
pip install pandas pymysql sqlalchemy requests

# Or upgrade pip first
pip install --upgrade pip
pip install -r requirements.txt
```

### Issue: File not found

**Cause:** Wrong `DATA_DIR` path or file structure

**Solution:**
1. Verify `DATA_DIR` path in `config.json`
2. Check directory structure matches expected format
3. Ensure file names match pattern (conc.*.csv)
4. List files:
   ```bash
   ls -la /Users/mirodilbekfazilov/developer/odor2/20251107/
   ls -la /Users/mirodilbekfazilov/developer/odor2/20251107/eachdata/
   ```

### Issue: Weather API error

**Cause:** Invalid API key or network issue

**Solution:**
1. Verify API key in `config.json`
2. Test API directly:
   ```bash
   curl "http://api.openweathermap.org/data/2.5/weather?lat=35.456552&lon=129.327667&APPID=YOUR_API_KEY"
   ```
3. Check internet connection

### Issue: Maven build error

**Cause:** Wrong Java version or dependencies issue

**Solution:**
```bash
# Check Java version (should be 11)
java -version

# Set correct JAVA_HOME
export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Home

# Clean and rebuild
cd TSEI_modeling
mvn clean install
mvn spring-boot:run
```

## Process Multiple Time Periods

To process additional modeling output:

1. Place new files in a new timestamped directory:
   ```
   /Users/mirodilbekfazilov/developer/odor2/20251108/
   ```

2. Run the script again:
   ```bash
   python insert_weather_modleing_to_DB_3D.py
   ```

The script automatically processes the **latest** directory and prevents duplicates.

## Database Schema Reference

### `modeling_data1` Table
- `md_idx`: Auto-increment primary key
- `e_idx`: Emission source (0=total, 1-21=individual)
- `lat`: Latitude
- `lon`: Longitude
- `conc1` to `conc10`: Concentration values
- `reg_date`: Registration datetime

### `modeling_weather1` Table
- `mw_idx`: Auto-increment primary key
- `wind_dir`: Wind direction (degrees)
- `wind_spd`: Wind speed (m/s)
- `temp`: Temperature (Kelvin)
- `humi`: Humidity (%)
- `pressure`: Pressure (hPa)
- `reg_date`: Registration datetime

## Next Steps

After successful data insertion and visualization:

1. ✅ **Analyze Results:** Use the web interface to analyze concentration patterns
2. ✅ **Compare Sources:** Switch between different `e_idx` values to compare emission sources
3. ✅ **Time Series:** Process multiple time periods to see trends
4. ✅ **Export Data:** Use API endpoints to export data for further analysis
5. ✅ **Team Sharing:** Set up network access for team members (see DEPLOYMENT_AND_ACCESS.md)

## Automation (Optional)

To automate processing new modeling outputs:

```bash
# Create a simple monitor script
cat > monitor_and_process.sh << 'EOF'
#!/bin/bash
cd /path/to/No.6-Pj/modeling/util/insert_weather_modleing_to_DB_3D
python insert_weather_modleing_to_DB_3D.py >> /tmp/modeling_import.log 2>&1
EOF

chmod +x monitor_and_process.sh

# Run periodically with cron (every hour)
crontab -e
# Add: 0 * * * * /path/to/monitor_and_process.sh
```

## Summary

You've successfully:
- ✅ Configured database connection
- ✅ Processed modeling CSV files
- ✅ Inserted concentration data (e_idx 0-21)
- ✅ Imported weather data
- ✅ Started web application
- ✅ Visualized results on map

For more information, see:
- [DATABASE_SETUP.md](DATABASE_SETUP.md) - Database configuration details
- [MODELING_OUTPUT_WORKFLOW.md](MODELING_OUTPUT_WORKFLOW.md) - Detailed workflow explanation
- [DEPLOYMENT_AND_ACCESS.md](DEPLOYMENT_AND_ACCESS.md) - Team deployment guide
