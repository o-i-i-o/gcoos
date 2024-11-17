@echo off
setlocal EnableDelayedExpansion
title X509֤�����ɽű�
echo.
echo ---------------Windows������X509֤�����ɽű�------------------------------------------------------
echo.
echo ------------------���ߣ�xiazhia-----------------------------------------------------------------
echo ------------------Ver�� 0.3a4 ------------------------------------------------------------------
echo.
echo ---------------ʹ�ô˽ű�ǰ�����ı���ʽ�򿪴˽ű����˶�openssl�����Ƿ�������ȷ-------------------
echo ---------------�����������������ļ�·��cnf\openssl.cnf��key��csr��crt�ļ�����·��baseCA\certs----------------------
echo.
echo.

:ca
set /p ca=�Ƿ�������ca��y/n��:
IF /i "!ca!"=="y" goto start 
IF /i "!ca!"=="n" goto mkca1
exit

:mkca1
echo ͨ��CA����֤�飩ֻ������һ�Σ��Ƿ�������ɣ���baseCA�ļ������Ѵ���ca�ļ����������˳�
set /p mkcaa=����y��������CA�������˳���
IF /i "!mkcaa!"=="y" Goto mkca2
exit

:mkca2
set casubj=/C=CN/ST=GuiZhou/L=GuiYang/O=Organization/OU=IT/emailAddress=boss@oi-io.cc
openssl req -new -x509 -days 3650 -keyout baseCA\ca.key -out baseCA\ca.crt -subj %casubj% -extensions v3_ca
IF %ERRORLEVEL% NEQ 0 ( echo ����ʧ�ܣ��������ã������˳���
exit ) else ( echo ���ɳɹ���CA������baseCA\baseCA\ca.key��baseCA\ca.crt����ȷ��ca��Ϣ�Ƿ���ȷ
echo �����޸���չ��Ϣ����ֱ���޸Ľű���Ӧ�ֶ� )

:start
echo.
echo 0������������IP��ַ
echo ����س���������ǰ����������Ϊ��ѡ������Ϊ��IP����֤��ʱ��ֱ���޸Ľű���������ر���
set /p certname=������������
if "%certname%" neq "" (echo �����������Ϊ��%certname%)   else  ( echo δ���������������˳�
Pause&exit)
echo.
set /p ipv4=������IPv4��ַ��
if "%ipv4%" neq "" (echo.�������ipv4��ַΪ��%ipv4%
set var2=�趨�ղ���)  else (
set var2="IP.1"
echo δ����IPv4��ַ )
echo.
set /p ipv6=������ipv6��ַ��
if "%ipv6%" neq "" (echo.�������ipv6��ַΪ��%ipv6%
set var3=�趨�ղ���) else (
set var3="IP.2" 
echo δ����IPv6��ַ )
findstr /v "%var2% %var3%" "cnf\openssl.cnf" >> cnf/temp
echo ɾ��δ��������������ļ��еĶ�Ӧ�ֶ�

echo 1������˽Կ
echo rsa�����Ը��ã�ecc���ܸ��á�
:keytype
set /p keytype=��ѡ������˽Կ���ͣ�rsa/ecc��:
IF /i "!keytype!"=="rsa" Goto :RSAKEY
IF /i "!keytype!"=="ecc" Goto :ECCKEY
Echo ������������������!
Pause>Nul&Goto :keytype


:ECCKEY
echo ��������ECC˽Կ
openssl ecparam -genkey -name secp384r1 -out baseCA\certs\%certname%.key
echo �����޸�ECC˽Կǿ�ȣ���ֱ���޸Ľű���secp384r1�ֶΡ�
echo ECC˽Կ������baseCA\certs\%certname%.key
pause
goto goon


:RSAKEY
echo ��������RSA˽Կ
openssl genrsa -out baseCA\certs\%certname%.key 2048
echo �����޸�RSA˽Կǿ�ȣ���ֱ���޸Ľű���2048�ֶΡ�
echo RSA˽Կ������baseCA\certs\%certname%.key
pause
goto goon

:goon
echo.
echo 2�����������ļ�
set crtsubj=/C=CN/ST=GuiZhou/L=GuiYang/O=Organization/OU=IT/CN=%certname%/emailAddress=boss@oi-io.cc
openssl req -new   -key baseCA\certs\%certname%.key -out baseCA\certs\%certname%.csr -subj %crtsubj%
echo �����޸���չ��Ϣ����ֱ���޸Ľű�-subj���Ӧ�ֶΡ�
echo �����ļ�������baseCA\certs\%certname%.csr
pause

echo.
echo 3������ѡ����д�������ļ�
for /f "delims=" %%a in ('type cnf\temp') do (
set "c=%%a"
set "c=!c:DNS.1=DNS.1 = %certname%!"
set "c=!c:IP.1=IP.1 = %ipv4%!"
set "c=!c:IP.2=IP.2 = %IPV6%!"
echo !c! >>cnf/%certname%.cnf )
echo д��cnf/%certname%.cnf��ɣ�
echo �˴��������д�����ܡ�
pause

echo.
echo 4�������û�֤��
echo ��������������ѡ���������������ֱ���˳�(�������error password�ֶΣ�
openssl ca -in baseCA\certs\%certname%.csr -out baseCA\certs\%certname%.crt -cert baseCA\ca.crt -keyfile baseCA\ca.key -extensions v3_req -config cnf\%certname%.cnf -days 3650 
IF %ERRORLEVEL% NEQ 0 ( echo ɾ�����������ļ�
del cnf\temp 
GOTO error ) else (echo ɾ�����������ļ�
del cnf\temp 
GOTO OK)

:OK
echo.
echo ���ɳɹ����û�֤�鱣����baseCA\certs\%certname%.crt
echo ֤����Ч��3650�죬�����޸���Ч�ڣ���ֱ���޸Ľű���Ӧ�ֶΡ�
pause
exit

:error
echo.
ECHO ����
echo ɾ�����ɵ��ļ�
del baseCA\certs\%certname%.key
del baseCA\certs\%certname%.csr
del cnf\%certname%.cnf
Echo ����ca������������
pause
exit

