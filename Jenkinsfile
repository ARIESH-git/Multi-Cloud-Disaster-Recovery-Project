pipeline {
    agent any

    environment {
        AWS_HOST = '98.84.74.9'
        AZURE_HOST = '20.102.69.169'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    credentialsId: 'github-credentials',
                    url: 'https://github.com/ARIESH-git/Multi-Cloud-Disaster-Recovery-Project.git'
            }
        }

        stage('Deploy to AWS') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'aws-ssh-key', keyFileVariable: 'SSH_KEY')]) {
                    sh '''
                        scp -o StrictHostKeyChecking=no -i $SSH_KEY ansible/files/index-aws.html ubuntu@$AWS_HOST:/var/www/html/index.html
                        ssh -o StrictHostKeyChecking=no -i $SSH_KEY ubuntu@$AWS_HOST "sudo cp /tmp/index.html /var/www/html/index.html && sudo systemctl restart nginx"
                    '''
                }
            }
        }

        stage('Deploy to Azure') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'azure-ssh-key', keyFileVariable: 'SSH_KEY')]) {
                    sh '''
                        scp -o StrictHostKeyChecking=no -i $SSH_KEY ansible/files/index-azure.html azureuser@$AZURE_HOST:/var/www/html/index.html
                        ssh -o StrictHostKeyChecking=no -i $SSH_KEY azureuser@$AZURE_HOST "sudo cp /tmp/index.html /var/www/html/index.html && sudo systemctl restart nginx"
                    '''
                }
            }
        }
    }
}
