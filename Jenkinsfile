node {
 try  {
 notify('Job Started') 

     
  stage('Git-Checkout') {
   git 'https://github.com/Sandeepkr93/completedevops.git'
  }
  stage('Input to continue forther') {
   input('git checkout done Do you want to forther proceed?')  
  }
 def project_path=""
 
 dir(project_path) {
    
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
	 
 stage('Input for deploy in production server') {            
   input('Do you want to deploy into production server proceed?')
        }
  stage('Geting Ready For Ansible') {
  sh label: 'Jenkins', script: "echo '<h1> TASK BUILD ID: ${env.BUILD_DISPLAY_NAME}</h1>' > index.html"
}  
   
   stage('Prod Deployment on AWS'){
   sh label: 'terraform', script: '/bin/terraform  init'
   sh label: 'terraform', script: '/bin/terraform  apply -input=false -auto-approve'
   }
}

notify('Job Completed')   
} catch (err) {
  notify("Error ${err}")
  currentBuild.result = 'FAILURE'
}
}

def notify(status){
    emailext (
	to: "chakradhar1998@outlook.com",
	subject: "${status}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
	 body: """<p>${status}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
	<p>Check console output at <a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a></p>""",
		)
	}
