# Quick Start: Processing Modeling Output

## Quick Checklist

When you receive modeling output from your team:

### 1. ✅ Prepare Files
- [ ] Verify CSV files are in correct format: `lon,lat,conc1,conc2,...,conc10,null`
- [ ] Organize files in directory structure:
  ```
  output_directory/
  └── YYYYMMDDHHMM/
      ├── conc.YYYYMMDDHHMM.csv
      └── eachdata/
          ├── YYYYMMDDll1.csv
          ├── YYYYMMDDll2.csv
          └── ... (up to 21 files)
  ```

### 2. ✅ Configure Database Connection
- [ ] Update `modeling/util/insert_weather_modleing_to_DB_3D/config.json`:
  - Set `DATA_DIR` to your output directory path
  - Set `DATABASE_ADDRESS` to `"localhost"`
  - Set `DATABASE_USER` to `"root"`
  - Set `DATABASE_PASSWD` to `"1234"`
  - Set `DATABASE_SCHEMA` to `"tseiweb"`
  - Add your OpenWeatherMap API key

### 3. ✅ Install Dependencies
```bash
cd modeling/util/insert_weather_modleing_to_DB_3D
pip install -r requirements.txt
```

### 4. ✅ Run Script
```bash
python insert_weather_modleing_to_DB_3D.py
```

### 5. ✅ Verify Data
```bash
export PATH="/opt/homebrew/opt/mysql@8.0/bin:$PATH"
mysql -uroot -p1234 tseiweb -e "SELECT COUNT(*) FROM modeling_data1;"
```

### 6. ✅ Start Web Application
```bash
cd TSEI_modeling
export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Home
mvn spring-boot:run
```

### 7. ✅ View Results
- Open http://localhost:9084/soms/page3
- Select the date/time of your inserted data
- View modeling results on the map

## File Format Requirements

**Main CSV file:** `conc.YYYYMMDDHHMM.csv`
```csv
lon,lat,conc1,conc2,conc3,conc4,conc5,conc6,conc7,conc8,conc9,conc10,null
129.32,35.45,0.5,0.3,0.2,0.1,0.0,0.0,0.0,0.0,0.0,0.0,
```

**Individual source files:** `YYYYMMDDll{N}.csv` (same format)

## Common Issues

| Issue | Solution |
|-------|----------|
| "There are no updates" | Clear `LAST_UPDATE_FILE` in config.json |
| Connection error | Check MySQL is running and credentials are correct |
| File not found | Verify `DATA_DIR` path and file structure |
| Column error | Ensure CSV has exact column format |
| No weather data | Check OpenWeatherMap API key |

## Full Documentation

See `MODELING_OUTPUT_WORKFLOW.md` for detailed instructions.

