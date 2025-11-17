ls
exit
ls
clear
ls
cd modeling
ls
mv bin ..
ls
cd ..
ls
cd modeling
ls
mv inp ls
ls
cd ls
ls
clear
cd ..
ls
mv ls inp
ls
mv inp ..
mv out ..
mv run ..
mv scr ..
mv util ..
ls
clear
ls
cd
ls
rm modeling
rm modeling -r
ls
cd inp
ls
clear
cd
ls
ls util
cd util
clear
ls
vim mk.geo.csh
exit
ls
cd util
vim mk.geo.csh
ls
./mk.geo.csh
cd
ls
chmod +x bin
chmod +x util
chmod +x ru
chmod +x run
cd util
ls
./mk.geo.csh
chmod +x mk.geo.csh 
ls
clear
ls
./mk.geo.csh 
chmod u+x mk.geo.csh 
./mk.geo.csh 
cd ..
ls
cd bin
ls
chmod u+x mk.geo.exe 
cd
cd util
ls
./mk.geo.csh
ls
./domain2ll.csh
cd ..
ls
chmod +x util -r
chmod -R +x bin inp scr util
chmod -R +x bin 
chmod -R +x util
ls
chmod -R +x inp
chmod -R +x run
chmod -R +x scr
chmod -R +x util
sudo chmod -R +x util
dnf chmod -R +x util
exit
ls
clear
ls
su -
exit
ls
cd util
ls
clear
ls
cd ..
ls -l
ls
chmod 755 util
ls
ls -l
date
ls
cd util
clear
ls
./domain2ll.csh
clear
exit
date
exit
clear
ls
su - 
exit
ls
exit
ls
cd util
ls
./domain2ll.csh 
clear
ls
cat domain2ll.csh 
exit
ls
cd util
ls
./domain2ll.csh 
ls
cat topo.csv 
clear
ls
mv topo.csv /home/mdl/inp/nmlist/
cd ..
ls
cd inp
cd nmlist
ls
cd
cd scr
ls
clear
ls
vim mk.up.csh
ls
./mk.up.csh
exit
lls
ls
 clear
ls
exit 
ㅣㄴ
ls
cd scr
ls
./mk.up.csh
clear
# 1. 홈 디렉터리로 이동
cd ~
# 2. CentOS 7용 libgfortran RPM 패키지 다운로드
wget https://vault.centos.org/7.9.2009/os/x86_64/Packages/libgfortran-4.8.5-44.el7.x86_64.rpm
# 3. RPM 패키지 압축 해제 (./usr 폴더가 생성됨)
rpm2cpio libgfortran-4.8.5-44.el7.x86_64.rpm | cpio -idmv
# 4. 실제 라이브러리 파일을 Rocky 8 시스템 폴더로 복사
sudo cp ~/usr/lib64/libgfortran.so.3.0.0 /usr/lib64/
# 5. 프로그램이 찾을 수 있도록 'libgfortran.so.3' 이름의 바로가기(심볼릭 링크) 생성
sudo ln -sf /usr/lib64/libgfortran.so.3.0.0 /usr/lib64/libgfortran.so.3
# 6. 임시 파일 정리
rm libgfortran-4.8.5-44.el7.x86_64.rpm
rm -r ~/usr
exit
ls
cd scr
ls
clear
ls
cat mk.up.csh
im-config -n ibus
exit
ls
cd scr
ls
clear
s
ls
clear
cat mk.up.csh
cd
ls
cd inp
cd nmlist
ls
cd ..
ls -l
ls
cd surf
ls
cd
ls
cd bi
ls bin
clear
ls
ls run
clear
exit
lsl
ls
rm 1.tmp 
rm UP1.DAT 
ls
cd scr
ls
./mk.up.csh
clear
ls
cat mk.up.csh 
cd
clear
ls
rm gfs.t00z.pgrb2.0p25.f000 
cd scr
ls
./mk.up.csh
ls
./run.csh
ls
cd
ls
cd out
ls
cd 20251107
ls
cd conc.202511072201.csv 
cat conc.202511072201.csv 
cd ..
ls
cd 2025
cd 20251107/
ls
cd ..
clear
ls
cd util
ls
mv GEO.dat /home/mdl/inp/nmlist
mv GEO.DAT /home/mdl/inp/nmlist
cd
ls
cd scr
ls
cat mk.up.csh 
clear
ls
cd
ls
cd util
os
ls
clear
ls
vim mk.geo.csh 
cd
ls
cd scr
ls
vim mk.up.csh 
ls
cd
ls
cd util
ls
./mk.geo.csh
domain2ll.csh
./domain2ll.csh
cd
ls
clear
ls
ㅣㄴ
ls
ㅣㄴ
ls
cd out
ls
cd 20251107
ls
ls -l
clear
ls
cd
ls
cd run
ls
clear
ls
cd
ls
cd scr
ls
clear
ls
cd
cd inp
ls
cd surf
ls
cd pr
ls
cd ..
cd gfs
ls
cd ..
ls
cd gfs
ls
clear
ls
ls 20251108
cd ..
cd up
ls
cd
ls
clear
ls
cd util
lls
ls
cat mk.geo.csh 
cd
clear
ls
cd scr
ls
cat mk.up.csh 
cd
clear
ls
cd scr
clear
vim run.csh
./run.csh
cd ..
ls
cd out
ls
cd 20251108
ls
cat conc.202511081354.csv 
clear
ls
cd ..
ls
cd
ls
cd uitl
cd util
ls'
clear
ls
cat mk.geo.csh 
cd ..
ls
 cd scr
cat mk.up.csh 
clear
ls
cat mk.up.csh 
cd
cd scr
ls
clear
ls
cat run.csh
ls
cd
clear
ls
cd scf
clear
ls
cd out
ls'
ls
cd 20251108
ls
cat conc.202511081354.csv 
clear
ls
cd
ls
cd inp
ls
cd surf
ls
cat lastdata 
clear
cd
ls
cd out
ls
cd 20251108
ls
clear
less conc.202511081354.csv 
cat conc.202511081354.csv 
clear
less conc.202511081354.csv 
clear
ls
cd
ls
cd util
sl
ls
clear
ls
cd real-time_weather_emissions_transfer_3D/
ls
cdcd
cd
clear
docker pull mysql:8.0
exit
ls'
ls
clear
ls
cd run
cd
cd out
ls
cd 20251108
ls
exit
ls
cd util
ls
clear
ls
cd api_weather_modeling_transfer_3D/
ls
cat api_weather_modeling_transfer_3D.py 
clear
cat config.json 
clear
ls
cd ..
ls
cd real-time_weather_emissions_transfer_3D/
ls
clear
ls
cat real-time_weather_emissions_transfer_3D.py 
cd ..
cd real-time_weather_emissions_transfer_3D/
clear
ls
cat config.json 
clear
ls
cd
exit
ls
cd util
ls
cd api_weather_modeling_transfer_3D/
cd ..
ls
cd real-time_weather_emissions_transfer_3D/
clear
ls
vim real-time_weather_emissions_transfer_3D.py 
cd ..
ls
cd api_weather_modeling_transfer_3D/
ls
python api_weather_modeling_transfer_3D.py 
exit
cd util
ls
cd api_weather_modeling_transfer_3D/
ls
python api_weather_modeling_transfer_3D.py 
python3
clear
jobs
kill %1
clear
ls
python3 api_weather_modeling_transfer_3D.py 
exit
ls
cd util
cd api_weather_modeling_transfer_3D/
ls
python3 api_weather_modeling_transfer_3D.py 
python3 -m pip install cryptography requests
python3 -m pip install cryptography requests pandas sqlalchemy
python3 -m pip install setuptools_rust
exit
ls
cd util
cd api_weather_modeling_transfer_3D/
clear
ls
exit
ls
cd uti
cd util
ls
clear
ls
cd api_weather_modeling_transfer_3D/
python3 api_weather_modeling_transfer_3D.py 
clear
cd ..
ls
cd insert_weather_modleing_to_DB_3D/
ls
clear
cat config.json 
clear
ls
vim config.json 
cd ..
ls
clear
ls
cd insert_weather_modleing_to_DB_3D/
ls
python3 insert_weather_modleing_to_DB_3D.py 
ls
vim insert_weather_modleing_to_DB_3D.py 
vim config.json 
ls
clear
ls
python3 insert_weather_modleing_to_DB_3D.py 
clear
ls
python3 insert_weather_modleing_to_DB_3D.py 
cd
ls
clear
docker exec -it mysql_cont /bin/bash
exit
ls
cd uti
cd util
ls
cd insert_weather_modleing_to_DB_3D/
clear
ls
python3 insert_weather_modleing_to_DB_3D.py 
exit
clear
ls
cd util
ls
cd insert_weather_modleing_to_DB_3D/
python3 insert_weather_modleing_to_DB_3D.py 
exit
ls
cd util
ls
cd insert_weather_modleing_to_DB_3D/
python3 insert_weather_modleing_to_DB_3D.py 
cd
exit
cd ..
clear
exit
ls
cd util
ls
cd real-time_weather_emissions_transfer_3D/
ls
cat real-time_weather_emissions_transfer_3D.py 
ls
clear
cat config.json 
clear
cd ..
ls
cd int
cd insert_weather_modleing_to_DB_3D/
clear
ls
cat insert_weather_modleing_to_DB_3D.py 
clear
ls
cat config.json 
cd
exit
ls
clear
exit
ls
clear
ls
cd run
ls
clear
ls
cd
ls
clear
ls
cd scr
ls
./mk.up.csh
clear
cd
ls
clear
ls
cd scr
sl
ls
./mk.up.csh
ls
clear
ls
./run.csh
ls
clear
ls
cd ..
ls
cd out
ls
cd 20251114
ls
c
cd
ls
exit
 ls
clear
ls
cd scr
ls
clear
cd out
ls
cd
cd out
ls
cd 20251114
ls
clear
cd ..
ls
cd out
ls
cdd 20251114
cd 20251114
ls
cd
crontab -e
dnf install crontab
exit
crontab -e
crontab -l
exit
ls
cd scr
clear
ls
vim run.csh 
cat run.csh 
clear
vim run.csh 
crontab -e
crontab -l > cron_backup.txt
l
ls
rm cron_backup.txt 
crontab -r
crontab -e
cd ..
ls
cd mdl
ls
crontab -l > crontab_settings.txt
ls
clear
ls
cd out
ls
git
exit
ls
cd out
ls
rm 20251107 -r
rm 20251108 -r
rm 20251113 -
rm 20251113 -r
clear
ls
cd
ls
exit
ls
cd inp
ls
cd nmlist
ls
cd
clear
ls
cd util
ls
cd real-time_weather_emissions_transfer_3D/
ls
cd ..
ls
cd insert_weather_modleing_to_DB_3D/
ls
exit
ls
cd util
ls
cd real-time_weather_emissions_transfer_3D/
ls
cd sample
ls
cd ..
ls
cd
ls
cd out
ls
rm 20251114 -r
exit
ls
cd out
ls
clear
exit
ls
cd log
ls
cd 20251114
ls
cat 000
clear
cat 000
clear
exit
ls
cd src
ls
cd scr
ls
cat run.csh
clear
exit
