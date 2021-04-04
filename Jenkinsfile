pipeline {
    agent any
    stages {
        
        stage('Git Clone'){
            steps{
               git credentialsId: 'GIT_CREDENTIALS', url: 'https://github.com/oriyomibadmus/simple-Terraform.git' 
            }
            
        }
        
        stage('Terraform Init'){
            steps{
               sh 'terraform init' 
            }
            
        }
        
        stage('Terraform plan'){
            steps{
               sh 'terraform plan' 
            }
            
        }
        
        stage('Terraform Apply'){
            steps{
               sh 'terraform apply --auto-approve' 
            }
            
        }
    }
}

