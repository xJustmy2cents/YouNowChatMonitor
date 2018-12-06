#!/bin/sh  

prodhost=$1

if [[ "$prodhost" -eq "" ]]; then
	return 98
	fi
	
if [ ! -e ~/.ssh/known-hosts ]; then  
	touch ~/.ssh/known-hosts;  
	fi  
	
HostIsKnown=$(grep "$prodhost" ~/.ssh/known-hosts|wc -l)  
KeyIsKnown=$(grep "$(ssh-keyscan -t rsa $prodhost)" ~/.ssh/known-hosts|wc -l)  

echo "KeyIsKnown= "  $KeyIsKnown  
echo "HostIsKnown= "  $HostIsKnown  
if [  $KeyIsKnown -ne  $HostIsKnown ] || [  $(( $KeyIsKnown *  $HostIsKnown)) -gt 1 ]; then  
	return "99"  
else  
	if [  $KeyIsKnown -eq 0 ]; then  
		ssh-keyscan -t rsa $prodhost >> ~/.ssh/known-hosts  
		return "1"  
	else  
		return "0"  
	fi  
fi  