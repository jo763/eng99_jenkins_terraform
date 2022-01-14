# Create Jenkins Server
- Create a standard EC2 server (see other Repos)
## Install Java onto the Jenkins EC2 instance server
- https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-on-ubuntu-18-04#installing-specific-versions-of-openjdk
- Ubuntu 18.04 includes Open JDK 11, which is an open-source variant of the JRE and JDK.
- To install this version, first update the package index:
- `sudo apt update`
- check if Java is already installed:
- `java -version`
- If Java is not currently installed
- `sudo apt install default-jre`
- verify
- `java -version`
- install jdk
- `sudo apt install default-jdk`
- verify
- `javac -version`
## Install Jenkins onto the Jenkins EC2 instance server
- https://www.digitalocean.com/community/tutorials/how-to-install-jenkins-on-ubuntu-18-04
- Jenkins should now be working on the EC2 instance
- Get repository
- `wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -`
- Append the Debian package repository address to the server’s sources.list:
- `sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'`
- Update and install
- `sudo apt update`
- `sudo apt install jenkins`
- Start Jenkins
- `sudo systemctl start jenkins`
- verify status
- `sudo systemctl status jenkins`
- Opening firewall, open port 8080
- `sudo ufw allow 8080`
- Confirm status
- `sudo ufw status`
- if firewall inactive
```
sudo ufw allow OpenSSH
sudo ufw enable
```
- Go to http://your_server_ip_or_domain:8080
- get admin password, copy and paste into website
- `sudo cat /var/lib/jenkins/secrets/initialAdminPassword`
- Install suggested plugins
- Enter user details etc.
- Should be set up
- Install 'ssh', 'ssh-agent' and 'nodejs', 'Terraform' and 'Ansible' plugins

# Install Terraform
- Go to Manage Jenkins --> Global Tool Configuration
- Go to terraform.io, copy the link address for the amd64 Linux
```
sudo apt install unzip
```
- type wget <and paste the link>
`unzip` <name of zipped file>
- If zip doesn't exist
`sudo apt install unzip`
- Adding Terraform to path
```
sudo mv terraform /usr/bin
```
- Check if terraform has been added to path
```
terraform --version
```
- Place `/usr/bin` into the Jenkins Install directory form

## Install Ansible
# Create Playbook to create EC2 instance
- NOTE: All the lines should be entered one at a time (or use a provision script), copying multiple lines tend to not properly install systems
- Install dependencies
```
sudo apt-get update
sudo apt-get
install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible
sudo apt-get install tree
```
- Install Python
```
sudo apt install python
sudo apt install python-pip -y
sudo pip install --upgrade pip
sudo pip install boto
sudo pip install botocore
sudo pip install boto3
```

# Giving Terraform and Jenkins AWS credentials
- Return to the Jenkins server
- Go to Manage Jenkins --> Configure System
- Scroll down to: Global Properties --> Environment Variables
- Fill in the following

- Name: AWS_ACCESS_KEY_ID
- Value: <AWS ACCESS KEY>

- Name: AWS_SECRET_ACCESS_KEY
- Value: <AWS SECRET KEY>

- Name: AWS_DEFAULT_REGION
- Value: eu-west-1

- Go to Manage Jenkins --> Credentials
- Add Credentials
- Kind: AWS Credentials
- Type in AWS credentials


## Creating the Jenkins Build
- Create a pipeline build
- Enter the pipeline script and fill with the following
- Note "terraform-11" is the name for the terraform system we established earlier when configurating Jenkins in Global properties
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
## Creating the Ansible Build
- Create a pipeline build
- Enter the pipeline script and fill with the following
- Note "terraform-11" is the name for the terraform system we established earlier when configurating Jenkins in Global properties
- To create more ansible jobs, you can either use more builds or just create extra lines with `ansiblePlaybook....`
```
pipeline{
    agent any
    stages{
        stage("SCM Checkout"){
            steps{
                git branch: 'main', url: 'https://github.com/jo763/eng99_jenkins_terraform'
            }
        }
        stage("Execute Playbook"){
            steps{
                ansiblePlaybook credentialsId: 'eng99', disableHostKeyChecking: true, installation: 'ansible', inventory: 'dev.inv', playbook: 'install_nginx.yml'
            }
        }
    }
}
```
# fsd
