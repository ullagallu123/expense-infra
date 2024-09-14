pipeline {
    agent {
        label 'terraform'
    }
    parameters {
        choice(name: 'ACTION', choices: ['create', 'destroy'], description: 'Choose whether to create or destroy resources')
    }
    stages {
        stage('Terraform Init, Fmt, Validate, Plan, and Apply/Destroy') {
            steps {
                script {
                    def folders = [
                        "01.vpc/",
                        "02.sg/",
                        "02a.instances/",
                        "03.db/",
                        "04.internal-alb/",
                        "05.acm/",
                        "06.external-alb/",
                        "07.backend-asg/",
                        "08.frontend-asg/"
                    ]

                    if (params.ACTION == 'create') {
                        for (folder in folders) {
                            dir(folder) {
                                sh 'terraform init'
                                sh 'terraform fmt -recursive'
                                sh 'terraform validate'
                                sh 'terraform plan'
                                input message: "Proceed with 'terraform apply' for ${folder}?", ok: 'Apply'
                                sh 'terraform apply --auto-approve'
                            }
                        }
                    } else if (params.ACTION == 'destroy') {
                        for (folder in folders.reverse()) {  // Reverse the order for destruction
                            dir(folder) {
                                sh 'terraform init'
                                input message: "Proceed with 'terraform destroy' for ${folder}?", ok: 'Destroy'
                                sh 'terraform destroy --auto-approve'
                            }
                        }
                    }
                }
            }
        }
    }
}
