@echo off
set ip_address_string="IPv4 Address"
rem Uncomment the following line when using older versions of Windows without IPv6 support (by removing "rem")
rem set ip_address_string="IP Address"
for /f "usebackq tokens=2 delims=:" %%f in (`ipconfig ^| findstr /c:%ip_address_string%`) do ( set ip=%%f)

for /f "tokens=* delims= " %%a in ("%ip%") do set ip=%%a
for /l %%a in (1,1,100) do if "!ip:~-1!"==" " set ip=!ip:~0,-1!
(
    echo HOST=%ip%
    echo PORT=3000
) > ./frontend/.env

(
    echo HOST=%ip%
    echo PORT=1337
) > ./backend/.env

call git pull 

cd ./frontend
call yarn
call yarn build

cd ../backend
call yarn
set NODE_ENV=production
call yarn build
start yarn start

cd ../frontend
start yarn start