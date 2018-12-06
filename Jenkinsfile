pipeline {
//	agent { label 'private-net'}
	agent any
	environment {
		dnstest=true
		riptest=true
		prodhost="derdapp004.abinsnetz.local"
		prodip="10.10.10.240"
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
						//set -x
						//check and update known_hosts for ssh connection
						//lets see, if the host is known by now -yes we do this only for DNS name, not for raw IP.
						sh 'if [ ! -e ~/.ssh/known-hosts ]; then touch ~/.ssh/known-hosts; fi'
						def HostIsKnown = sh(script: 'grep ${prodhost} ~/.ssh/known-hosts|wc -l', returnStdout: true)
						def KeyIsKnown = sh(script: 'grep "$(ssh-keyscan -t rsa ${prodhost})" ~/.ssh/known-hosts|wc -l', returnStdout: true)
						echo 'KeyIsKnown= ' + KeyIsKnown
						echo 'HostIsKnown= ' + HostIsKnown

						if (KeyIsKnown != HostIsKnown || (int) KeyIsKnown * (int) HostIsKnown > 1) {
							echo 'FATAL ERROR: SSH KEY AUTHENTICATION CORRUPTED'
							exit 99
							}
						if (KeyIsKnown == 0) {
							sh 'ssh-keyscan -t rsa ${prodhost} >> ~/.ssh/known-hosts'
							echo 'RSA Key of ' + prodhost + ' added to local store'
							}

						echo 'Deploying'
						echo 'Testing if Server is reachable'
						try {
							echo 'Trying by DNS'
							sh 'ping -c 4 ${prodhost}'
							} catch (error) {
								script {
									dnstest=false
									}
								}
						try {
							sh 'ping -c 4 ${prodip}'
							} catch (error) {
								script {
									riptest=false
									}
								}
						if ( dnstest ) {
							echo 'pushing files using dns'
							sh 'scp -i ${keyfile} loopchat.ps1 ${sshuser}@${prodhost}:~'
							} else {
							if ( riptest ) {
								echo 'pushing files using raw ip'
								sh 'scp -i ${keyfile} loopchat.ps1 ${sshuser}@${prodip}:~'
								}
							}
						}
					}
				}
			}
		}
	}
