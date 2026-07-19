pipeline {
    agent any

    environment {
        // Paste your private Render Deploy Hook URL here (From Render -> Settings -> Deploy Hook)
        RENDER_DEPLOY_HOOK = 'https://api.render.com/deploy/srv-d9dr8fmrnols73d1tesg?key=DeGFE_-m5rc'
    }

    stages {
        stage('Checkout Testing Code') {
            steps {
                echo 'Wiping old workspace data and pulling clean testing code...'
                cleanWs()
                // Downloads your dedicated automation script repo to execute against the server
                git url: 'https://github.com/AishParamadathil/parabank-selenium-tests.git', branch: 'main'
            }
        }

        stage('Install Dependencies') {
            steps {
                echo 'Setting up Python library environment...'
                sh 'pip install -r requirements.txt'
            }
        }

        stage('Execute Test Suite') {
            steps {
                echo 'Running API and Selenium automated UI checks...'
                sh 'pytest -v'
            }
        }

        stage('Deploy to Production') {
            steps {
                echo 'All tests passed cleanly! Signaling Render to update production...'
                // Sends a secure request directly to Render to deploy your newly pushed build
                sh "curl -X POST '${RENDER_DEPLOY_HOOK}'"
            }
        }
    }

    post {
        failure {
            echo '❌ Pipeline execution failed! Automation checks did not pass. Deployment aborted.'
        }
    }
}