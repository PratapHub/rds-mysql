pipeline {
    agent {label "Your agent name"}
    
    stages{
       
        stage ('Checkout SCM'){
        steps {
         git branch: 'YOUR BRANCH NAME', changelog: false, credentialsId: '16018dc6-ea16-43ca-85bf-62617092eca9', poll: false, url: 'REPO-URL'
        }
      }      
      stage("terraform init") {
            steps 
                 {
                dir ("eks") {
                sh ("terraform init") 
                
            } }
        }
        
         stage("terraform workspaces"){
            steps{
                dir ("dms"){
                
                sh "terraform workspace select ${workspace} || terraform workspace new ${workspace}"
                
            }}
        }

        

        stage("terraform action") {
            steps {
                dir ("dms") {
                echo "Terraform action is --> ${action}"
                sh ("terraform ${action} --auto-approve")
            } }
           
        }
    }
}
