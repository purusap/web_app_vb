set publishDir=%~dp0publish
cd /d %publishDir% || goto err 

del Web.config
rmdir /s /q Images
rmdir /s /q Manual

cd ..

powershell "$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'; Compress-Archive publish publish_${timestamp}.zip"

goto end 
:err
echo err occured

:end 
timeout 60
ping localhost