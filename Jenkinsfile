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
		stage('Deploy'){
			steps {
				script {
					echo 'Deploying'
					echo 'Testing if Server is reachable'
					try {
						echo 'Trying by DNS'
						sh 'ping -c 4 ownclud.abinsnetz.local'
						} catch (error) {
							script {
								dnstest=false
								}
							}
					try {
						sh 'ping -c 4 10.10.10.242'
						} catch (error) {
							script {
								riptest=false
								}
							}
					echo 'dnstest=' + dnstest
					echo 'riptest=' + riptest
					}
				}
			}
		}
	}
