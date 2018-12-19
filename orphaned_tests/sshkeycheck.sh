#!/bin/sh  

prodhost=$1
rm -f ~/.ssh/known*

if [ -z "$prodhost" ]; then
	return 98
	fi
	
if [ ! -e ~/.ssh/known_hosts ]; then  
	touch ~/.ssh/known_hosts;  
	fi  
	
HostIsKnown=$(grep "$prodhost" ~/.ssh/known_hosts|wc -l)  
KeyIsKnown=$(grep "$(ssh-keyscan -t rsa $prodhost)" ~/.ssh/known_hosts|wc -l)  

#echo "KeyIsKnown= "  $KeyIsKnown  
#echo "HostIsKnown= "  $HostIsKnown  
if [  $KeyIsKnown -ne  $HostIsKnown ] || [  $(( $KeyIsKnown *  $HostIsKnown)) -gt 1 ]; then  
	echo -n "99"  
	return "99"  
else  
	if [  $KeyIsKnown -eq 0 ]; then  
		ssh-keyscan -t rsa $prodhost >> ~/.ssh/known_hosts  
		echo -n "1"  
		return "0"  
	else  
		echo -n "0"  
		return "0"  
	fi  
fi
##script should never come so far.
echo -n "57"
return "57"