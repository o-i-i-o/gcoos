@echo off
setlocal EnableDelayedExpansion
chcp 65001
title gcoos v0.3a4
echo.
echo ---------------Windows环境下X509证书生成脚本------------------------------------------------------
echo.
echo ------------------作者：oi-io-------------------------------------------------------------------
echo  https://github.com/o-i-i-o/gcoos
echo ------------------Ver： 0.3a4 ------------------------------------------------------------------
echo.
echo ---------------使用此脚本前请用文本格式打开此脚本并核对openssl环境是否配置正确-------------------
echo ---------------环境变量包括配置文件路径cnf\openssl.cnf，key、csr、crt文件生成路径baseCA\certs----------------------
echo.
echo.

:ca
set /p ca=是否已生成ca（y/n）:
IF /i "!ca!"=="y" goto start 
IF /i "!ca!"=="n" goto mkca1
exit

:mkca1
echo 通常CA（根证书）只用生成一次，是否继续生成，若baseCA文件夹下已存在ca文件，将报错退出
set /p mkcaa=输入y继续生成CA，否则退出：
IF /i "!mkcaa!"=="y" Goto mkca2
exit

:mkca2
set casubj=/C=CN/ST=GuiZhou/L=GuiYang/O=Organization/OU=IT/emailAddress=boss@oi-io.cc
openssl req -new -x509 -days 3650 -keyout baseCA\ca.key -out baseCA\ca.crt -subj %casubj% -extensions v3_ca
IF %ERRORLEVEL% NEQ 0 ( echo 生成失败，请检查配置，即将退出！
exit ) else ( echo 生成成功，CA保存在baseCA\baseCA\ca.key、baseCA\ca.crt；请确定ca信息是否正确
echo 若需修改扩展信息，请直接修改脚本对应字段 )

:start
echo.
echo 0、输入域名或IP地址
echo 键入回车键跳过当前参数，域名为必选参数（为纯IP生成证书时请直接修改脚本），否则必报错。
set /p certname=请输入域名：
if "%certname%" neq "" (echo 您输入的域名为：%certname%)   else  ( echo 未输入域名，即将退出
Pause&exit)
echo.
set /p ipv4=请输入IPv4地址：
if "%ipv4%" neq "" (echo.您输入的ipv4地址为：%ipv4%
set var2=设定空参数)  else (
set var2="IP.1"
echo 未输入IPv4地址 )
echo.
set /p ipv6=请输入ipv6地址：
if "%ipv6%" neq "" (echo.您输入的ipv6地址为：%ipv6%
set var3=设定空参数) else (
set var3="IP.2" 
echo 未输入IPv6地址 )
findstr /v "%var2% %var3%" "cnf\openssl.cnf" >> cnf/temp
echo 删除未输入参数在配置文件中的对应字段

echo 1、生成私钥
echo rsa兼容性更好，ecc性能更好。
:keytype
set /p keytype=请选择输入私钥类型（rsa/ecc）:
IF /i "!keytype!"=="rsa" Goto :RSAKEY
IF /i "!keytype!"=="ecc" Goto :ECCKEY
Echo 输入有误，请重新输入!
Pause>Nul&Goto :keytype


:ECCKEY
echo 即将生成ECC私钥
openssl ecparam -genkey -name secp384r1 -out baseCA\certs\%certname%.key
echo 若需修改ECC私钥强度，请直接修改脚本的secp384r1字段。
echo ECC私钥保存在baseCA\certs\%certname%.key
pause
goto goon


:RSAKEY
echo 即将生成RSA私钥
openssl genrsa -out baseCA\certs\%certname%.key 2048
echo 若需修改RSA私钥强度，请直接修改脚本的2048字段。
echo RSA私钥保存在baseCA\certs\%certname%.key
pause
goto goon

:goon
echo.
echo 2、生成请求文件
set crtsubj=/C=CN/ST=GuiZhou/L=GuiYang/O=Organization/OU=IT/CN=%certname%/emailAddress=boss@oi-io.cc
openssl req -new   -key baseCA\certs\%certname%.key -out baseCA\certs\%certname%.csr -subj %crtsubj%
echo 若需修改扩展信息，请直接修改脚本-subj后对应字段。
echo 请求文件保存在baseCA\certs\%certname%.csr
pause

echo.
echo 3、将可选名称写入配置文件
for /f "delims=" %%a in ('type cnf\temp') do (
set "c=%%a"
set "c=!c:DNS.1=DNS.1 = %certname%!"
set "c=!c:IP.1=IP.1 = %ipv4%!"
set "c=!c:IP.2=IP.2 = %IPV6%!"
echo !c! >>cnf/%certname%.cnf )
echo 写入cnf/%certname%.cnf完成！
echo 此处需求：提高写入性能。
pause

echo.
echo 4、生成用户证书
echo 需求：输错密码可以选择重新输入而不是直接退出(密码错有error password字段）
openssl ca -in baseCA\certs\%certname%.csr -out baseCA\certs\%certname%.crt -cert baseCA\ca.crt -keyfile baseCA\ca.key -extensions v3_req -config cnf\%certname%.cnf -days 3650 
IF %ERRORLEVEL% NEQ 0 ( echo 删除缓存配置文件
del cnf\temp 
GOTO error ) else (echo 删除缓存配置文件
del cnf\temp 
GOTO OK)

:OK
echo.
echo 生成成功，用户证书保存在baseCA\certs\%certname%.crt
echo 证书有效期3650天，若需修改有效期，请直接修改脚本对应字段。
pause
exit

:error
echo.
ECHO 错误
echo 删除生成的文件
del baseCA\certs\%certname%.key
del baseCA\certs\%certname%.csr
del cnf\%certname%.cnf
Echo 请检查ca密码或各项配置
pause
exit

