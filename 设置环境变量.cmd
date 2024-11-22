@echo off
setlocal EnableDelayedExpansion
chcp 65001
echo. Ver0.3a6
echo. 本脚本只需要运行一次，重复运行会造成程序异常！！！

set /p aa=是否继续（y/n):
if /i "%aa%"=="y" goto :bb
exit

:bb
echo.  输入1配置安装路径

//echo.  输入2配置CA默认设置

//暂不可用

//echo.  输入3配置证书默认设置

//暂不可用

set /p menu=请选择配置项目:

if /i "!menu!"=="1" goto path
if /i "!menu!"=="2" goto cacnf
if /i "!menu!"=="3" goto crtcnf


:path
echo. 设置安装路径，字段必须以\bin结尾。

set /p path=请输入openssl安装路径：

echo. 您输入的路径为%path%

cd  %path%

if exist openssl.exe (echo. 路径设置成功 ) else (echo. 当前路径下未找到openssl.exe，路径设置失败,请重新输入！

Pause>Nul&Goto :path)

:cacnf
echo. 配置CA默认设置

echo. 输入"."代表留空。

set /p  cacn=请输入签发组织（个人）名称（英文）：

set /p  cac =请输入国家名称（两位字母大写）：

set /p  cao =请输入公司/单位名称：

set /p  caou=请输入部门名称：

set /p  cast=请输入省份名称：

set /p  cal =请输入城市名称：

set /p  caem=请输入电子邮箱：

set casubj=/C=%cac%/ST=%cast%/L=%cal%/O=%cao%/OU=%caou%/CN=%cacn%/emailAddress=%caem%



:crtcnf
echo. 配置证书默认设置
echo. 输入"."代表留空。

set /p  crtcn=请输入域名（IP地址）：

set /p  crtc =请输入国家名称（两位字母大写）：

set /p  crto =请输入公司/单位名称：

set /p  crtu =请输入部门名称：

set /p  crtst=请输入省份名称：

set /p  crtl =请输入城市名称：

set /p  crtem=请输入电子邮箱：

set crtsubj=/C=%crtc%/ST=%crtst%/L=%crtl%/O=%crto%/OU=%crtou%/CN=%crtcn%/emailAddress=%crtem%

@echo. 创建证书根目录

mkdir baseCA
echo. 创建%path%\baseCA成功。

mkdir baseCA\certs
echo. 创建%path%\baseCA\certs成功。

mkdir baseCA\pemcerts
echo. 创建%path%\baseCA\pemcerts成功。

type nul >> baseCA\index.txt
echo. 创建%path%\baseCA\index.txt成功。

echo. 00 >> baseCA\serial
echo. 创建%path%\baseCA\serial成功。
echo. 复制配置文件到cnf文件夹。

mkdir cnf
copy %~dp0\openssl.cnf  cnf\
copy %~dp0\生成证书.cmd 生成证书.cmd

echo. 后续请在%path%运行“生成证书.cmd”

start %~dp0生成证书.cmd
pause
