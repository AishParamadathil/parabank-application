pipeline {
    agent any

    environment {
        RENDER_DEPLOY_HOOK = 'https://api.render.com/deploy/srv-d9dr8fmrnols73d1tesg?key=DeGFE_-m5rc'
    }

    stages {
        stage('Checkout Testing Code') {
            steps {
                echo 'Wiping old workspace data and pulling clean testing code...'
                cleanWs()
                git url: 'https://github.com/AishParamadathil/parabank-selenium-tests.git', 
                    branch: 'main', 
                    credentialsId: 'github-token-auth'
            }
        }

        stage('Install Dependencies') {
            steps {
                echo 'Setting up Python library environment...'
                bat 'pip install -r requirements.txt'
            }
        }

        stage('Execute Test Suite') {
            steps {
                echo 'Running API and Selenium automated UI checks...'
                bat 'pytest -v'
            }
        }

        stage('Deploy to Production') {
            steps {
                echo 'All tests passed cleanly! Signaling Render to update production...'
                bat "curl -X POST \"${RENDER_DEPLOY_HOOK}\""
            }
        }
    }

    post {
        failure {
            echo '❌ Pipeline execution failed! Automation checks did not pass. Deployment aborted.'
        }
    }
}