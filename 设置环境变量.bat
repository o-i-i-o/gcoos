@echo off
setlocal EnableDelayedExpansion
echo Ver0.3a2
echo ���ű�ֻ��Ҫ����һ�Σ��ظ����л���ɳ����쳣������
set /p aa=�Ƿ������y/n):
if /i "!aa!"=="y" goto bb
exit

echo  ����1���ð�װ·��
echo  ����2����CAĬ������
echo  ����3����֤��Ĭ������
set /p menu=��ѡ��������Ŀ:
if /i "!menu!"=="1" goto path
if /i "!menu!"=="2" goto cacnf
if /i "!menu!"=="3" goto crtcnf


:path
echo ���ð�װ·�����ֶα�����\bin��β��
set /p path=������openssl��װ·����
echo �������·��Ϊ%path%
cd  %path%
if exist openssl.exe (echo ·�����óɹ� ) else (echo ��ǰ·����δ�ҵ�openssl.exe��·������ʧ�ܣ������˳���
exit)

:cacnf
echo ����CAĬ������
echo ����"."�������ա�
set /p  cacn=������ǩ����֯�����ˣ����ƣ�Ӣ�ģ���
set /p  cac =������������ƣ���λ��ĸ��д����
set /p  cao =�����빫˾/��λ���ƣ�
set /p  caou=�����벿�����ƣ�
set /p  cast=������ʡ�����ƣ�
set /p  cal =������������ƣ�
set /p  caem=������������䣺
set casubj=/C=%cac%/ST=%cast%/L=%cal%/O=%cao%/OU=%caou%/CN=%cacn%/emailAddress=%caem%



:crtcnf
echo ����֤��Ĭ������
echo ����"."�������ա�
set /p  crtcn=������������IP��ַ����
set /p  crtc =������������ƣ���λ��ĸ��д����
set /p  crto =�����빫˾/��λ���ƣ�
set /p  crtu =�����벿�����ƣ�
set /p  crtst=������ʡ�����ƣ�
set /p  crtl =������������ƣ�
set /p  crtem=������������䣺
set crtsubj=/C=%crtc%/ST=%crtst%/L=%crtl%/O=%crto%/OU=%crtou%/CN=%crtcn%/emailAddress=%crtem%

@echo ����֤���Ŀ¼
mkdir baseCA
echo ����%path%\baseCA�ɹ���
mkdir baseCA\certs
echo ����%path%\baseCA\certs�ɹ���
mkdir baseCA\newcerts
echo ����%path%\baseCA\newcerts�ɹ���
type nul >> baseCA\index.txt
echo ����%path%\baseCA\index.txt�ɹ���
echo 00 >> baseCA\serial
echo ����%path%\baseCA\serial�ɹ���
echo ���������ļ���cnf�ļ��С�
mkdir cnf
copy %~dp0\openssl.cnf  cnf\
copy %~dp0\����֤��.cmd ����֤��.cmd
echo ��������%path%���С�����֤��.cmd��
start %~dp0����֤��.cmd
pause
