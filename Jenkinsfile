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
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'awsCredentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    sh 'terraform init'
                    
                }
                
            }
            
        }
        
        stage('Terraform plan'){
            steps{
               withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'awsCredentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    sh 'terraform plan'
                    
                } 
            }
            
        }
        
        stage('Terraform Apply'){
            steps{
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'awsCredentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    sh 'terraform apply --auto-approve'
                    
                }
                
            }
            
        }
    }
}
