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
				sshagent(credentials: ['3b3ce520-b118-4f18-95d3-60d903f96914']) {
					withCredentials([sshUserPrivateKey(credentialsId: '3b3ce520-b118-4f18-95d3-60d903f96914', usernameVariable: 'sshuser')]) {
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

							//check and update known_hosts for ssh connection
							//lets see, if the host is known by now -yes we do this only for DNS name.
							echo 'Checking remote RSA ID'
							sh "chmod 755 $WORKSPACE/sshkeycheck.sh"
							sshkeycheck = sh(script: "$WORKSPACE/sshkeycheck.sh ${prodhost}", returnStdout: true)
							switch (sshkeycheck) {
								case "0":
									echo 'SSH remote Key is ok';
									break;
								case "1":
									echo 'SSH remote key has been added';
									break;
								case "98":
									echo 'FATAL ERROR: prodhost not set.';
									return 98
									break;
								case "99":
									echo 'FATAL ERROR: SSH remote key mismatch.';
									return 99
									break;
								default:
									echo 'Something went wrong.';
									echo 'Return value= ' + sshkeycheck;
									return
									break;
								}

							echo 'Deploying'
							echo 'pushing files using dns'
							sh 'scp -vvv loopchat.ps1 ${sshuser}@${prodhost}:~'
							}
						}
					}
				}
			}
		}
	}
