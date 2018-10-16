# YouNowChatMonitor
A small routine to monitor, log and respond to current chats of a running broadcast

This is written in Powershell 5.
You got 2 files

speakthis.ps1
This one contains the TTS API to Cortana
The TTS also contains a rule to surpress emojicons -it's not nice, to hear 5 minutes of "red heart, read heart, red heart,....

loopchatDB.ps1
This monitors a given Broadcast Chat and triggers the TTS.
It also takes care about storeing the data to files -each per stream and user.
The Data is base64 encoded to get rid of some issues when parsing special charakters



You do NOT need an account at Younow, to run this tool.
Put both files in one directory.
Open a powershell in the folder ([shift] + RM) and start like this:

loopchatDB.ps1 -YNUSER username [-READALL] [-NOTALK] [-WAIT4STREAM]
where 
-YNUSER is the real stream user name
-READALL is a switch, if You want to read all comments on startup
-NOTALK to just put the comments to the file and text output
-WAIT4STREAM to wait for the stream, if it is not online, or wait for the next stream, if one has ended.

Inside loopchatDB.ps1 there is one variable, You might want to configure:
$MYLOGPATH
-this is set to one folder up relative to the scriptfiles. eg: c:\temp\myscript\loopchatdb.ps1 is the script. So the logs will be at c:\temp\myscripts

Inside the function "newtalk" there is a small ruleset for changing what to say. I think it is self explaining.

TODO:
Write a small reloadchat to read a logged chat -decode base64 and display.

Remark: Younow only returns the last 20 comments on a running broadcast. So if You start somewhen in the middle of the stream, you will not get the past comments before the last 20 in display.
It is always possible to restart the script on a running chat. The buffer is -as You might guess; 20 comments ;-)

