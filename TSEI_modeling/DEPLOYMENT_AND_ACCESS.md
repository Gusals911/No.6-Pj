# Deployment & Team Access Guide

## Current Status: Local-Only Setup ❌

**Right now, your teammates CANNOT see the project** because:
- Application runs on `localhost:9084` (only accessible from your machine)
- Database is on `localhost:3306` (only accessible from your machine)
- No network exposure configured

## Making It Accessible to Your Team

You have several options to share the application with your teammates:

### Option 1: Local Network Access (Quickest) 🏠

Make your local machine accessible on your local network:

#### Steps:

1. **Find your local IP address:**
   ```bash
   ifconfig | grep "inet " | grep -v 127.0.0.1
   # or
   ipconfig getifaddr en0  # macOS WiFi
   # Example output: 192.168.1.100
   ```

2. **Update application.properties to bind to all interfaces:**
   ```properties
   server.address=0.0.0.0  # Allow access from network
   server.port=9084
   ```

3. **Configure MySQL to accept remote connections:**
   ```bash
   # Edit MySQL config
   sudo nano /opt/homebrew/etc/my.cnf
   # Add or modify:
   [mysqld]
   bind-address = 0.0.0.0
   
   # Restart MySQL
   brew services restart mysql@8.0
   ```

4. **Create MySQL user for remote access:**
   ```sql
   CREATE USER 'tsei_user'@'%' IDENTIFIED BY 'secure_password';
   GRANT ALL PRIVILEGES ON tseiweb.* TO 'tsei_user'@'%';
   FLUSH PRIVILEGES;
   ```

5. **Update application.properties for remote DB:**
   ```properties
   spring.no1.datasource.jdbc-url=jdbc:mysql://YOUR_IP:3306/tseiweb?useSSL=false&serverTimezone=UTC
   spring.no1.datasource.username=tsei_user
   spring.no1.datasource.password=secure_password
   ```

6. **Configure firewall (if needed):**
   ```bash
   # macOS - Allow incoming connections on port 9084
   sudo pfctl -f /etc/pf.conf
   ```

7. **Share the URL with your team:**
   - `http://YOUR_IP:9084/soms/page3`
   - Example: `http://192.168.1.100:9084/soms/page3`

**Limitations:**
- Only works when your computer is on and connected to same network
- Your IP address may change (use static IP or update team)
- Security: Less secure than proper deployment

---

### Option 2: Deploy to a Server (Recommended) 🖥️

Deploy to a dedicated server (like the original `192.168.200.171`):

#### Requirements:
- Server with Java 11+ and MySQL
- Static IP address
- Domain name (optional)

#### Steps:

1. **On the server, clone/setup the project:**
   ```bash
   git clone <your-repo> /opt/tsei_modeling
   cd /opt/tsei_modeling/TSEI_modeling
   ```

2. **Configure for server environment:**
   ```properties
   # application.properties
   server.port=9084
   spring.no1.datasource.jdbc-url=jdbc:mysql://localhost:3306/tseiweb?useSSL=false&serverTimezone=UTC
   spring.no1.datasource.username=root
   spring.no1.datasource.password=your_secure_password
   ```

3. **Build the JAR:**
   ```bash
   mvn clean package
   ```

4. **Create systemd service (Linux):**
   ```ini
   # /etc/systemd/system/tsei-modeling.service
   [Unit]
   Description=TSEI Modeling Application
   After=mysql.service
   
   [Service]
   Type=simple
   User=www-data
   WorkingDirectory=/opt/tsei_modeling/TSEI_modeling
   ExecStart=/usr/bin/java -jar /opt/tsei_modeling/TSEI_modeling/target/TSEI-0.0.1-SNAPSHOT.jar
   Restart=always
   
   [Install]
   WantedBy=multi-user.target
   ```

5. **Start the service:**
   ```bash
   sudo systemctl enable tsei-modeling
   sudo systemctl start tsei-modeling
   ```

6. **Configure firewall:**
   ```bash
   sudo ufw allow 9084/tcp
   ```

7. **Share the server URL:**
   - `http://SERVER_IP:9084/soms/page3`
   - Example: `http://192.168.200.171:9084/soms/page3`

---

### Option 3: Cloud Deployment (Most Reliable) ☁️

Deploy to cloud platforms:

#### AWS/Google Cloud/Azure:
- Use Elastic Beanstalk, App Engine, or Azure App Service
- Set up RDS/Cloud SQL for database
- Configure load balancer and auto-scaling

#### Docker Deployment:
```dockerfile
# Dockerfile
FROM openjdk:11-jre-slim
WORKDIR /app
COPY target/TSEI-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 9084
CMD ["java", "-jar", "app.jar"]
```

```yaml
# docker-compose.yml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "9084:9084"
    depends_on:
      - mysql
    environment:
      - SPRING_DATASOURCE_URL=jdbc:mysql://mysql:3306/tseiweb
      
  mysql:
    image: mysql:8.0
    environment:
      - MYSQL_ROOT_PASSWORD=1234
      - MYSQL_DATABASE=tseiweb
    volumes:
      - ./modeling_DB:/docker-entrypoint-initdb.d
```

---

## Real-Time Capabilities

### Current Real-Time Status: ⚠️ Semi-Real-Time

#### What Works in "Real-Time":
1. ✅ **Weather Data**: Fetched from OpenWeatherMap API when script runs
2. ✅ **Data Display**: Once data is in database, web app shows it immediately (on page refresh/date selection)
3. ✅ **Multiple Users**: Multiple teammates can view the same data simultaneously

#### What Doesn't Work in Real-Time:
1. ❌ **Automatic Data Updates**: Data insertion requires manual script execution
2. ❌ **Auto-Refresh**: Web page doesn't automatically refresh when new data arrives
3. ❌ **Live Modeling**: No automatic processing of new modeling files

### Making It More Real-Time

#### Option A: Automated Data Processing (Near Real-Time)

Set up automatic processing when new files arrive:

1. **Create a watch script:**
   ```bash
   # watch_for_new_files.sh
   #!/bin/bash
   WATCH_DIR="/path/to/modeling/output"
   SCRIPT_DIR="/path/to/insert_weather_modleing_to_DB_3D"
   
   while true; do
       # Check for new files (files modified in last 5 minutes)
       NEW_FILES=$(find "$WATCH_DIR" -type f -name "conc.*.csv" -mmin -5)
       
       if [ ! -z "$NEW_FILES" ]; then
           echo "New files detected, processing..."
           cd "$SCRIPT_DIR"
           python insert_weather_modleing_to_DB_3D.py
           sleep 300  # Wait 5 minutes before next check
       else
           sleep 60   # Check every minute
       fi
   done
   ```

2. **Run as background service:**
   ```bash
   chmod +x watch_for_new_files.sh
   nohup ./watch_for_new_files.sh > watch.log 2>&1 &
   ```

#### Option B: WebSocket Auto-Refresh (True Real-Time Display)

Add WebSocket support to automatically refresh the web page:

1. **Add Spring WebSocket dependency to pom.xml:**
   ```xml
   <dependency>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-websocket</artifactId>
   </dependency>
   ```

2. **Create WebSocket configuration:**
   ```java
   @Configuration
   @EnableWebSocketMessageBroker
   public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {
       @Override
       public void configureMessageBroker(MessageBrokerConfigurer config) {
           config.enableSimpleBroker("/topic");
           config.setApplicationDestinationPrefixes("/app");
       }
       @Override
       public void registerStompEndpoints(StompEndpointRegistry registry) {
           registry.addEndpoint("/ws").withSockJS();
       }
   }
   ```

3. **Send notifications when new data arrives:**
   ```java
   @Autowired
   private SimpMessagingTemplate messagingTemplate;
   
   public void notifyNewData() {
       messagingTemplate.convertAndSend("/topic/newData", "New modeling data available");
   }
   ```

4. **Update frontend to listen for updates:**
   ```javascript
   const socket = new SockJS('/ws');
   const stompClient = Stomp.over(socket);
   
   stompClient.connect({}, function() {
       stompClient.subscribe('/topic/newData', function(message) {
           // Refresh data or show notification
           location.reload();
       });
   });
   ```

#### Option C: Scheduled Cron Job (Periodic Updates)

Set up a cron job to process files periodically:

```bash
# Add to crontab (crontab -e)
# Run every 15 minutes
*/15 * * * * cd /path/to/insert_weather_modleing_to_DB_3D && python insert_weather_modleing_to_DB_3D.py >> /var/log/modeling_import.log 2>&1
```

---

## Recommended Setup for Team Collaboration

### For Development/Testing:
1. Use **Option 1 (Local Network)** for quick sharing
2. Set up automated file watching (Option A above)
3. Team members access via your local IP

### For Production:
1. Use **Option 2 (Server Deployment)** on dedicated server
2. Set up cron job for periodic processing (Option C)
3. Configure proper security (firewall, SSL, authentication)
4. Set up monitoring and logging

### For Maximum Real-Time:
1. Deploy to server (Option 2 or 3)
2. Implement file watching (Option A)
3. Add WebSocket auto-refresh (Option B)
4. Result: New data appears automatically within minutes

---

## Security Considerations

### When Exposing to Network:

1. **Change default passwords:**
   - Database password
   - Application credentials (if added)

2. **Use HTTPS:**
   - Configure SSL certificate
   - Update to port 443 or use reverse proxy (nginx)

3. **Add authentication:**
   - Enable Spring Security (currently disabled)
   - Configure user roles and permissions

4. **Firewall rules:**
   - Only allow necessary ports
   - Restrict access to specific IPs if possible

5. **Database security:**
   - Don't use root user for application
   - Create dedicated user with minimal privileges
   - Use strong passwords

---

## Testing Team Access

### After Setup:

1. **Test from another machine on same network:**
   ```bash
   curl http://YOUR_IP:9084/soms/date
   # Should return JSON array of dates
   ```

2. **Test database connection:**
   ```bash
   mysql -h YOUR_IP -u tsei_user -p tseiweb -e "SELECT COUNT(*) FROM modeling_data1;"
   ```

3. **Test web interface:**
   - Open browser on teammate's machine
   - Navigate to `http://YOUR_IP:9084/soms/page3`
   - Should load the modeling page

---

## Troubleshooting Team Access

| Issue | Solution |
|-------|----------|
| Can't connect to application | Check firewall, verify server.address=0.0.0.0 |
| Can't connect to database | Check MySQL bind-address, verify user permissions |
| Connection timeout | Check network connectivity, verify IP address |
| Permission denied | Check MySQL user grants, verify password |
| Port already in use | Change port in application.properties |

---

## Summary

### To Answer Your Questions:

**Q: Will teammates see the completed project?**
- **Current**: ❌ No, it's local-only
- **After setup**: ✅ Yes, if you deploy using one of the options above

**Q: Will it work in real-time?**
- **Current**: ⚠️ Semi-real-time (manual processing, manual refresh)
- **After automation**: ✅ Near real-time (automatic processing every few minutes)
- **After WebSocket**: ✅ True real-time (automatic updates when data arrives)

### Recommended Next Steps:

1. **Immediate**: Set up local network access (Option 1) for team testing
2. **Short-term**: Deploy to server (Option 2) for stable access
3. **Long-term**: Add automation (Option A) and WebSocket (Option B) for real-time updates

