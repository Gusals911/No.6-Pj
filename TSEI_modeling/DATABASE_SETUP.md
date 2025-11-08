## Database Connection Summary

The TSEI_modeling application is now properly connected to MySQL database.

### Database Configuration:
- **Host:** localhost:3306
- **Database:** tseiweb
- **Driver:** com.mysql.cj.jdbc.Driver
- **Username:** root
- **Password:** 1234

### Key Files:
- **Configuration:** src/main/resources/application.properties
- **Database Config:** src/main/java/com/tsei/www/config/no1DataBaseConfig.java
- **Mapper:** src/main/resources/mapper/soms/soms_no1.xml
- **Database Schema:** modeling_DB/DB구조생성.sql

### Running the Application:
```bash
export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Home
cd TSEI_modeling
mvn spring-boot:run
```

Or if already built:
```bash
export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Home
java -jar target/TSEI-0.0.1-SNAPSHOT.jar
```

The application will start on port 9084: http://localhost:9084

### Database Tables:
1. **modeling_data1** - Modeling concentration data (lat, lon, conc1-10, reg_date)
2. **modeling_weather1** - Weather data (wind_dir, wind_spd, temp, humi, pressure, reg_date)
3. **place_data_temp** - Place location data (lat, lon, name, p_index, poi)

### Initial Setup Steps:
1. Fixed pom.xml dependencies (removed conflicts)
2. Updated MySQL connector for Spring Boot 2.7.2
3. Installed Maven via Homebrew
4. Compiled successfully with Java 11
5. Installed MySQL 8.0 via Homebrew
6. Created database and imported schema
7. Removed JPA (using MyBatis only)

### ✅ Successfully Connected!

**Current Status:** The TSEI_modeling application is now successfully running and connected to MySQL!

**Application URL:** http://localhost:9084

**Available Endpoints:**
- http://localhost:9084/soms/page3 - Main modeling page
- http://localhost:9084/soms/page5 - Additional page
- http://localhost:9084/soms/places - Places API endpoint
- http://localhost:9084/soms/date - Date API endpoint

**What was done:**
1. ✅ Installed MySQL 8.0 via Homebrew
2. ✅ Created tseiweb database with all required tables
3. ✅ Configured application to use MySQL on port 3306
4. ✅ Removed JPA dependency (using MyBatis only)
5. ✅ Application is running successfully
6. ✅ Database queries are working

**To stop the application:**
```bash
# Find the process
ps aux | grep "TSEI.*jar"

# Kill it
pkill -f "TSEI.*jar"
# or kill the Maven process
pkill -f "spring-boot:run"
```

**To start the application again:**
```bash
cd TSEI_modeling
export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Home
export PATH="/opt/homebrew/opt/mysql@8.0/bin:$PATH"
brew services start mysql@8.0
mvn spring-boot:run
```

