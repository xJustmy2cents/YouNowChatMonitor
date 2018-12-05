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
				println("Bulding")
				}
			}
		stage('Test'){
				steps {
				println("Testing")
				}
			}
		stage('Deploy'){
				println("Deploying")
				println("Testing if Server is reachable")
				try {
					println("Trying by DNS")
					sh 'ping -c 4 owncloud.abinsnetz.local'
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
				println("dnstest=" + dnstest)
				println("riptest=" + riptest)
			}
		}
	}
