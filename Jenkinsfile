pipeline {
	agent any 
    /* insert Declarative Pipeline here */
	stages {
		stage('Build') {
			steps {
				echo 'Building'
				}
			}
		stage('Test') {
			steps {
				echo 'Testing'
				}
			}
		stage('Deploy') {
			steps {
				echo 'Deploying'
				echo 'is target reachable'
				sh 'ping -c 4 owncloud.abinsnetz.local'
				}
			}
		}
	}
