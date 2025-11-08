# Quick Setup: Make Application Accessible to Team

## Quick Answer to Your Questions

### ❌ Current State:
- **Teammates CANNOT see it** - Running on localhost only
- **NOT real-time** - Requires manual data processing

### ✅ After Quick Setup:
- **Teammates CAN see it** - Accessible on local network
- **Near real-time** - Can set up automatic processing

---

## 5-Minute Setup: Local Network Access

### Step 1: Get Your IP Address
```bash
# On macOS:
ipconfig getifaddr en0
# or
ifconfig | grep "inet " | grep -v 127.0.0.1

# Example output: 192.168.1.100
```

### Step 2: Update Application Configuration
Edit `TSEI_modeling/src/main/resources/application.properties`:

```properties
# Change this line to allow network access:
server.address=0.0.0.0
server.port=9084

# Keep database as localhost (database stays on your machine)
spring.no1.datasource.jdbc-url=jdbc:mysql://localhost:3306/tseiweb?useSSL=false&serverTimezone=UTC
```

### Step 3: Restart Application
```bash
cd TSEI_modeling
export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Home
mvn spring-boot:run
```

### Step 4: Share URL with Team
```
http://YOUR_IP:9084/soms/page3
```

Example: If your IP is `192.168.1.100`, share:
```
http://192.168.1.100:9084/soms/page3
```

### Step 5: Test Access
- Open the URL from another device on the same network
- Should see the modeling page

---

## Making It More Real-Time

### Option 1: Automated File Processing (Recommended)

Create a script that watches for new files and processes them automatically:

```bash
# create file: auto_process.sh
#!/bin/bash
cd /Users/mirodilbekfazilov/developer/odorsystem/modeling/util/insert_weather_modleing_to_DB_3D

# Check for new files every 5 minutes
while true; do
    python insert_weather_modleing_to_DB_3D.py
    sleep 300  # Wait 5 minutes
done
```

Run it in background:
```bash
chmod +x auto_process.sh
nohup ./auto_process.sh > process.log 2>&1 &
```

### Option 2: Manual Processing (Current)
When modeling team provides new files:
1. Place files in correct directory
2. Run: `python insert_weather_modleing_to_DB_3D/insert_weather_modleing_to_DB_3D.py`
3. Data appears in web app immediately

---

## Important Notes

### ⚠️ Limitations of Local Network Setup:
1. **Your computer must be on** - Teammates can't access if your computer is off
2. **Same network required** - Must be on same WiFi/LAN
3. **IP may change** - If your IP changes, share new URL
4. **Security** - Less secure than server deployment

### ✅ Benefits:
1. **Quick setup** - 5 minutes to configure
2. **No server needed** - Use your own machine
3. **Free** - No hosting costs
4. **Good for testing** - Perfect for development/team review

---

## Workflow After Setup

### Your Workflow:
1. ✅ Receive modeling output files from team
2. ✅ Place files in directory structure
3. ✅ Run processing script (manual or automated)
4. ✅ Data appears in database
5. ✅ Team can view immediately at shared URL

### Team Workflow:
1. ✅ Open shared URL in browser
2. ✅ Select date/time of modeling data
3. ✅ View results on map
4. ✅ Analyze concentration data

---

## Troubleshooting

### "Connection Refused"
- Check application is running: `lsof -i :9084`
- Verify `server.address=0.0.0.0` in application.properties
- Check firewall settings

### "Can't Connect"
- Verify you're on same network
- Check IP address is correct
- Try accessing from your own machine first: `http://localhost:9084`

### "Database Error"
- Database stays on localhost (your machine)
- Only web application is shared, not database
- This is normal and expected

---

## Next Steps for Production

For permanent, reliable access, consider:
1. **Server Deployment** - Deploy to dedicated server
2. **Cloud Hosting** - Use AWS/Google Cloud/Azure
3. **Domain Name** - Get a proper domain (optional)
4. **SSL Certificate** - Add HTTPS security
5. **Authentication** - Add user login system

See `DEPLOYMENT_AND_ACCESS.md` for detailed deployment options.

