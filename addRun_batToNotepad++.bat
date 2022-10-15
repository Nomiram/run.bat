@set "file='%USERPROFILE%\AppData\Roaming\Notepad++\shortcuts.xml'"
@IF NOT EXIST "%file:~1,-1%" (
@echo shortcuts.xml doesn't exist on standard path. Set it manually in this script on "file="
@pause
exit
)
@set "regex='</UserDefinedCommands>'"
@set "newname=<Command name=\"run\" Ctrl=\"no\" Alt=\"no\" Shift=\"no\" Key=\"120\">&quot;run.bat&quot; &quot;$(FULL_CURRENT_PATH)&quot;</Command></UserDefinedCommands>"
powershell "%file%|%%{(cat $_) -replace %regex%,'%newname%' |out-file $_ -Enc default}"
@pause
@exit /B 1