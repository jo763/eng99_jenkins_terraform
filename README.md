- Install Terraform plugin on Jenkins
- Go to Manage Jenkins --> Global Tool Configuration
-

- Go to terraform.io, copy the link address for the amd64 Linux
```
sudo apt install unzip
```
- type wget <and paste the link>
`unzip` <name of zipped file>
- Adding Terraform to path
```
sudo mv terraform /usr/bin
```
- Check if terraform has been added to path
```
terraform --version
```
- Place `/usr/bin` into the Jenkins Install directory form

```

```
- Go to Manage Jenkins --> Configure System
- Global Properties --> Environment Variables

- Name: AWS_ACCESS_KEY_ID


- Name: AWS_SECRET_ACCESS_KEY


- Name: AWS_DEFAULT_REGION
- Value: eu-west-1

- Go to Manage Jenkins --> Credentials
- Add Credentials
- Kind: AWS Credentials
- Type in AWS credentials

```
pipeline{
    agent any
    tools {
        terraform 'terraform-11'
    }
    stages{
        stage("Git Checkout"){
            steps{
                git branch: 'main', url: 'https://github.com/jo763/eng99_jenkins_terraform'
            }
        }
        stage("Terraform Init"){
            steps{
                sh 'terraform init'
            }
        }
        stage("Terraform Apply"){
            steps{
                sh 'terraform apply --auto-approve'
            }
        }
    }
}

```
