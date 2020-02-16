node {
 try  {
 notify('Job Started') 

     
  stage('Git-Checkout') {
   git 'https://github.com/Sandeepkr93/Microservice2.git'
  }
  stage('Input to continue forther') {
   input('git checkout done Do you want to forther proceed?')  
  }
 
  stage('Maven-Clean') {
   sh label: 'CLEAN', script: 'mvn clean'
  }
    
 stage('Maven-Compile') {
   sh label: 'COMPILE', script: 'mvn compile'
  }
  stage('Sonar Analysis'){
        withSonarQubeEnv('Sonarqube'){
         sh 'mvn sonar:sonar'
        }
        }
  
   stage('Maven-Test') {
   sh label: 'TEST', script: 'mvn test'
  }
  
   stage('Maven-Package') {
   sh label: 'PACKAGE', script: 'mvn package'
  }
  
   stage('Archive-Artifacts') {
   archiveArtifacts 'target/*.war'
  }
  
   stage('Archive Package in jfrog') {
def server= Artifactory.server 'jfrog'
                    def uploadSpec= """{
                        "files": [{
                        "pattern": "target/*.war",
                        "target": "devopsweb"}]
                    }"""
                    server.upload (uploadSpec)
}  
    
  stage('Input for deploy in test server') {  
   input('Do you want to test server proceed?')      
        }
   stage('Docker-Stage-Deployment') {
   sh label: 'DOCKER DEPLOYMENT', script: 'docker-compose up -d --build'
  }
 

notify('Job Completed')   
} catch (err) {
  notify("Error ${err}")
  currentBuild.result = 'FAILURE'
}
}

def notify(status){
    emailext (
	to: "sandeepkumar.kiit@gmail.com",
	subject: "${status}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
	 body: """<p>${status}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
	<p>Check console output at <a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a></p>""",
		)
	}
