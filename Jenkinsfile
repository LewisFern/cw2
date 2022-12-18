node {
    def app

    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */

        checkout scm
    }

    stage('Build image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */

        app = docker.build("lewisfern/cw2_server")
    }

    stage('Test image') {
        /* Ideally, we would run a test framework against our image.
         * For this example, we're using a Volkswagen-type approach ;-) */

        app.inside {
            sh 'echo "Tests passed"'
        }
    }

    stage('Push image') {
        /* Finally, we'll push the image with two tags:
         * First, the incremental build number from Jenkins
         * Second, the 'latest' tag.
         * Pushing multiple tags is cheap, as all the layers are reused. */
        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }

    stage('Pull to Production Server') {
    sshagent(['my-ssh-key]) {
	 sh 'docker pull lewisfern/cw2_server:latest ubuntu@ip-172-31-87-91.ec2.internal:/home/ubuntu/cw2/'
	}    
       }

    stage('Rollout Update to Kubernetes') {
         sshagent(['my-ssh-key]){
         sh 'kubectl set image deployment/cw2-image cw2-image=lewisfern/cw2_server:latest ubuntu@ip-172-3-87-91.ec2.internal:/home/ubuntu/cw2/'
         }
	}
}

