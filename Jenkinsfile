pipeline {
//	agent { label 'private-net'}
	agent any
	environment {
		dnstest=true
		prodhost="derdapp004.abinsnetz.local"
		}
	stages {
		stage('Build'){
			steps {
				echo 'Bulding'
				}
			}
		stage('Test'){
				steps {
				echo 'Testing'
				}
			}
		stage('Deploy'){
			steps {
				withCredentials([sshUserPrivateKey(credentialsId: "3b3ce520-b118-4f18-95d3-60d903f96914", keyFileVariable: 'keyfile', usernameVariable: 'sshuser')]) {
					script {
						echo 'Testing if Server is reachable'
						try {
							echo 'Trying by DNS'
							sh 'ping -c 1 ${prodhost}'
							} catch (error) {
								script {
									dnstest=false
									echo 'FATAL: remote Host not reachable'
									exit 98
									}
								}

						//check and update known_hosts for ssh connection
						//lets see, if the host is known by now -yes we do this only for DNS name.
						echo 'Checking remote RSA ID'
						sshkeycheck = sh( script: '''#!/bin/sh \
							set -xel
							if [ ! -e ~/.ssh/known-hosts ]; then \
								touch ~/.ssh/known-hosts; \
								fi \
							HostIsKnown = $(grep "${prodhost}" ~/.ssh/known-hosts|wc -l) \
							KeyIsKnown = $(grep "$(ssh-keyscan -t rsa ${prodhost})" ~/.ssh/known-hosts|wc -l) \
							echo "KeyIsKnown= " $KeyIsKnown \
							echo "HostIsKnown= " $HostIsKnown \
							if [ $KeyIsKnown -ne $HostIsKnown ] || [ $(($KeyIsKnown * $HostIsKnown)) -gt 1 ]; then \
								return "99" \
							else \
								if [ $KeyIsKnown -eq 0 ]; then \
									ssh-keyscan -t rsa ${prodhost} >> ~/.ssh/known-hosts \
									return "1" \
								else \
									return "0" \
								fi \
							fi \
							''', returnStdout: true)
						switch (sshkeycheck) {
							case 0:
								echo 'SSH remote Key is ok';
							case 1:
								echo 'SSH remote key has been added';
							case 99:
								echo 'FATAL ERROR: SSH remote key mismatch.'
								exit 99
							}

						echo 'Deploying'
						echo 'pushing files using dns'
						sh 'scp -i ${keyfile} loopchat.ps1 ${sshuser}@${prodhost}:~'
						}
					}
				}
			}
		}
	}
