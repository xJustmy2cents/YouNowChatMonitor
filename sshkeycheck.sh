#!/bin/sh  

prodhost=$1

if [ -z "$prodhost" ]; then
	return 98
	fi
	
if [ ! -e ~/.ssh/known-hosts ]; then  
	touch ~/.ssh/known-hosts;  
	fi  
	
HostIsKnown=$(grep "$prodhost" ~/.ssh/known-hosts|wc -l)  
KeyIsKnown=$(grep "$(ssh-keyscan -t rsa $prodhost)" ~/.ssh/known-hosts|wc -l)  

#echo "KeyIsKnown= "  $KeyIsKnown  
#echo "HostIsKnown= "  $HostIsKnown  
if [  $KeyIsKnown -ne  $HostIsKnown ] || [  $(( $KeyIsKnown *  $HostIsKnown)) -gt 1 ]; then  
	echo "99"  
	return "99"  
else  
	if [  $KeyIsKnown -eq 0 ]; then  
		ssh-keyscan -t rsa $prodhost >> ~/.ssh/known-hosts  
		echo "1"  
		return "1"  
	else  
		echo "0"  
		return "0"  
	fi  
fi
##script should never come so far.
echo 57
return 57