pipeline {
//	agent { label 'private-net'}
	agent any
	environment {
		dnstest=true
		riptest=true
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
		withCredentials([sshUserPrivateKey(credentialsId: "3b3ce520-b118-4f18-95d3-60d903f96914", keyFileVariable: 'keyfile', usernameVariable: 'sshuser')]) {
			stage('Deploy'){
				steps {
					script {
						set -x
						echo 'Deploying'
						echo 'Testing if Server is reachable'
						try {
							echo 'Trying by DNS'
							sh 'ping -c 4 derdapp004.abinsnetz.local'
							} catch (error) {
								script {
									dnstest=false
									}
								}
						try {
							sh 'ping -c 4 10.10.10.240'
							} catch (error) {
								script {
									riptest=false
									}
								}
						if [ dnstest ]; then
							echo 'pushing files using dns'
							sh 'scp -i ${keyfile} loopchat.ps1 ${sshuser}@derdapp004.abinsnetz.local:~'
						elif [ riptest ]; then
							echo 'pushing files using raw ip'
							sh 'scp -i ${keyfile} loopchat.ps1 ${sshuser}@10.10.10.240:~'
							fi
						}
					}
				}
			}
		}
	}
