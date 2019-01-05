# YouNowChatMonitor
A small routine to monitor, log and respond to current chats of a running broadcast.  
For the Streamer: In addidion it is now possible to control OBS Output via a WebSocket.  
Contributs go to https://ianmorrish.wordpress.com/2017/05/20/automating-obs-from-powershell-script/ for this idea!  

This is written in Powershell 5.  
You got 1 main file  

**loopchatDB.ps1**  
This monitors a given Broadcast Chat and triggers the TTS.  
It also takes care about storeing the data to files -each per stream and user.  
The Data is base64 encoded to get rid of some issues when parsing special charakters.  

You do NOT need an account at Younow, to run this tool.  
Copy the file and ths folder **functions** to some location.  
Open a powershell in the folder ([shift] + RM) and start like this:  

loopchatDB.ps1 -YNUSER username [-PROFILE profilname] [-READALL] [-NOTALK] [-WAIT4STREAM] [-WRITELOG] [-SAYALL]  
where  
**-YNUSER** is the real stream user name  
**-PROFILE** names the file with the ruleset for Cortana how to answer.  
**-READALL** is a switch, if You want to read all comments on startup  
**-NOTALK** supress TTS -it'll get very silent ;-)  
**-WRITELOG** to output text anyway  
**-WAIT4STREAM** to wait for the stream, if it is not online, or wait for the next stream, if one has ended.  
**-SAYALL** to repeat all, that has been written -not only welcomes and thanks as defined in the "newtalk"-rules  
**-OBS to connect to a OBS Websocket  

Inside *loopchatDB.ps1* there is one variable, You might want to configure:  
**$MYLOGPATH**  
-this is set to one folder up relative to the scriptfiles. eg: c:\temp\myscript\loopchatdb.ps1 is the script. So the logs will be at c:\temp  

Inside the function "newtalk" there is a small ruleset for changing what to say. I think it is self explaining.  
You can create different files with the function *newtalk* and address them using the **-PROFILE** value.  

### TODO:
Write a small reloadchat to read a logged chat -decode base64 and display.  

### Remark:
Younow only returns the last 20 comments on a running broadcast.  
So if You start somewhen in the middle of the stream, you will not get the past comments before the last 20 in display.  
It is always possible to restart the script on a running chat. The buffer is -as You might guess; 20 comments ;-)  
  