pipeline {
//	agent { label 'private-net'}
	agent any
	environment {
		dnstest=true
		prodhost="derdapp004.abinsnetz.local"
		credentialid="3b3ce520-b118-4f18-95d3-60d903f96914"
		sshuser="jenkinsuser"
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
				sshagent(credentials: [credentialid]) {
					script {
						echo 'Testing if Server is reachable'
						try {
							echo 'Trying by DNS'
							sh 'ping -c 1 ${prodhost}'
							} catch (error) {
								dnstest=false
								echo 'FATAL: remote Host not reachable'
								return 97
								}
						echo 'Deploying'
						echo 'pushing files using dns'
						sh 'scp -r $WORKSPACE/files/* ${sshuser}@${prodhost}:~/monitor'
						}
					}
				}
			}
		}
	}
