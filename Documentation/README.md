# 👣 Documentation for the Project
## Steps for the Project:
- [ ] Clone Repository
- [ ] Create IAM Account with Access key and Secret key
- [ ] Create S3 Bucket with Terraform
- [ ] Run Terraform Database
- [ ] Run Python script to configure Players DynamoDB Table
- [ ] Create .env file
- [ ] Run SSM script to upload SSM Parameter Store Secrets
- [ ] Change links of CloudFront in HTML pages
- [ ] Run Terraform Project
- [ ] Configure secrets of CI/CD GitHub Actions
- [ ] Change values.yaml file and IMAGE_VERSION
- [ ] Check your CI/CD GitHub Actions
- [ ] Attach Route53 Records to ALB
- [ ] Configure Grafana
- [ ] Update new version to check automation

<hr style="border: 2px solid #FF9966;">

### Clone Repository
- [x] Clone Repository
Install Git to your PC [Git](https://git-scm.com/downloads)
```git
git clone https://github.com/MatveyGuralskiy/FlaskPipeline.git
```

<hr style="border: 2px solid #FF9966;">

### Create IAM Account with Access key and Secret key
- [x] Create IAM Account with Access key and Secret key

Go to IAM AWS Console and create IAM user, after that create to him Credentials and save them to your PC

Install AWSCLI to your PC [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

Now check if you get awscli

```
aws --version
aws configure
# Now enter your credentials, default region: us-east-1 and output format json
```

<hr style="border: 2px solid #FF9966;">

### Create S3 Bucket with Terraform
- [x] Create S3 Bucket with Terraform

Install Terraform to your PC [Terraform](https://developer.hashicorp.com/terraform/install?product_intent=terraform)

```
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

Go to My Repository on your PC to Terraform/S3-Bucket

You should change in file *variables.tf* bucket names to unique values

Now run Terraform commands:

```terraform
terraform init
terraform plan -out=tfplan
terraform apply -auto-approve
```

After Apply you have 2 S3 Buckets with Versioning, Media files and Static Files for Application. Terraform Also creates for you CloudFront distribution with unique URL (please save this output somewhere)

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/S3/S3-Buckets-List.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/S3/S3-Bucket-Project-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/S3/S3-Bucket-Project-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/S3/S3-Bucket-Project-3.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/S3/S3-Bucket-Project-4.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/S3/S3-Bucket-Remote-State-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/S3/S3-Bucket-Remote-State-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/S3/S3-Bucket-Remote-State-3.png?raw=true">

<hr style="border: 2px solid #FF9966;">

### Run Terraform Database
- [x] Run Terraform Database

Let's create DynamoDB Tables for our project

Go to My Repository on your PC to Terraform/Database

Change Backend to your unique S3 Bucket Name

This Terraform files also create Lambda function to delete old messages from Chat of Application, if there older that 24 hours (you can choose also to delete every 5 minutes for testing)

If you don't have Archive of Lambda Function please copy it from directory Lambda/delete_old_messages.py and compress it

```terraform
terraform init
terraform plan -out=tfplan
terraform apply -auto-approve
```

After Apply you get in your AWS account Lambda Function with EventBridge rule and DynamoDB Tables: Users, Players, Messages

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/DynamoDB/DynamoDB-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/DynamoDB/DynamoDB-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/DynamoDB/DynamoDB-7.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/Lambda/Delete-Old-Messages-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/Lambda/Delete-Old-Messages-2.png?raw=true">

<hr style="border: 2px solid #FF9966;">

### Run Python script to configure Players DynamoDB Table
- [x] Run Python script to configure Players DynamoDB Table

In DynamoDB we get Table Players, to fill it out let's run a Python script

python script located at DynamoDB directory

Verify you get Python on your PC before you start Python script

```python
python --version
python player.py
```

Now check your DynamoDB AWS Console Players Table

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/DynamoDB/DynamoDB-5.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/DynamoDB/DynamoDB-6.png?raw=true">

<hr style="border: 2px solid #FF9966;">

### Create .env file
- [x] Create .env file

In Application directory of My Repository create file called *.env*

```bash
touch .env
nano .env
# .env file have to be with there environment variables:
AWS_DEFAULT_REGION=us-east-1
SECRET_KEY=YOUR-SECRET-KEY
SESSION_COOKIE_SECURE=True
SESSION_COOKIE_HTTPONLY=True
SESSION_COOKIE_SAMESITE=Lax
USER_EMAIL=YOUR-EMAIL
PASSWORD_EMAIL=YOUR-GOOGLE-APP-PASSWORD
BASE_URL_SERVICE_1=http://localhost:5000
BASE_URL_SERVICE_2=http://localhost:5001
BASE_URL_SERVICE_3=http://localhost:5002
BASE_URL_SERVICE_4=http://localhost:5003
```

<hr style="border: 2px solid #FF9966;">

### Run SSM script to upload SSM Parameter Store Secrets
- [x] Run SSM script to upload SSM Parameter Store Secrets

When you get .env file you can upload your secrets to AWS System Manager Parameter Store

Go to My Repository on your PC to directory SSM and run *application.py* script

```python
python application.py
```

Check your SSM AWS Console to verify you upload all secrets

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/System-Manager/SSM-Parameter-Store.png?raw=true">

<hr style="border: 2px solid #FF9966;">

### Change links of CloudFront in HTML pages
- [x] Change links of CloudFront in HTML pages

Please go to Application and modified CSS and JavaScript links to your CloudFront url:

- main/index.html

- players/players.html

- training/training.html

- users/chat.html

- users/login.html

- users/register.html

After every changes your Application will used CloudFront CSS and JavaScript files to minimize upload time of Application

You can do it also with Media files as Logo and Main-Image

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/CloudFront/CloudFront-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/CloudFront/CloudFront-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/CloudFront/CloudFront-3.png?raw=true">

<hr style="border: 2px solid #FF9966;">

### Run Terraform Project
- [x] Run Terraform Project

Modified Main Terraform file in Terraform/Project:

- Change Backends S3 Bucket Remote State

- Change Route53 Hosted Zone

- Change all Route53 Records to your Domains

- Configure EKS-VPC module if you want

- Verify you get inside directory archive with Lambda function to Update Nodes

After all changes you will create 50+ AWS resources

```terraform
terraform init
terraform plan -out=tfplan
terraform apply -auto-approve
```

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Terraform/Terraform-init.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Terraform/Terraform-Plan-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Terraform/Terraform-Plan-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Terraform/Terraform-Plan-3.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Terraform/Terraform-Plan-4.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Terraform/Terraform-Plan-5.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Terraform/Terraform-Plan-6.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Terraform/Terraform-Plan-7.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Terraform/Terraform-Plan-8.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Terraform/Terraform-Apply-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Terraform/Terraform-Apply-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Terraform/Terraform-Apply-3.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Terraform/Terraform-Apply-4.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Terraform/Terraform-Apply-5.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Terraform/Terraform-Apply-6.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Terraform/Terraform-Apply-7.png?raw=true">

AWS Resources:

SSM:

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/System-Manager/SSM-Fleet-Manager.png?raw=true">

VPC:

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/VPC/VPC-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/VPC/VPC-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/VPC/VPC-3.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/VPC/Subnets.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/VPC/Route-Tables-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/VPC/Route-Tables-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/VPC/NAT-Gateway.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/VPC/Internet-Gateway.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/VPC/Elastic-IP.png?raw=true">

EC2:

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/EC2/EC-2-Instances.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/EC2/Security-Groups.png?raw=true">

Certificate Manager:

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/Certificate-Manager/SSL-List.png?raw=true">

EventBridge:

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/EventBridge/EventBridge-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/EventBridge/EventBridge-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/EventBridge/EventBridge-3.png?raw=true">

Lambda:

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/Lambda/Functions-List.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/Lambda/Update-Nodes-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/Lambda/Update-Nodes-2.png?raw=true">

Backup:

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/Backup/Backup-Plan-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/Backup/Backup-Plan-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/Backup/Backup-Selection.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/Backup/Daily-Backup.png?raw=true">

<hr style="border: 2px solid #FF9966;">

### Configure secrets of CI/CD GitHub Actions
- [x] Configure secrets of CI/CD GitHub Actions

Before we start, we should create token for GitHub Actions to get him access to push commits to our Repository

Profile Settings --> Developer Settings --> Personal access tokens --> Tokens(classic) --> Generate new token (please save it)

Now go to your Repository of Project to Settings --> Secrets and variables --> Actions --> New repository secret --> Called him *MY_GITHUB_TOKEN*

Add a few more different secrets:

- AWS_ACCESS_KEY_ID = Your AWS IAM User Access Key

- AWS_SECRET_ACCESS_KEY = Your IAM User Access Key

- DOCKER_PASSWORD = Your DockerHub Password

- DOCKER_USERNAME = Your DockerHub Username

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/GitHub-Actions/GitHub-Secrets.png?raw=true">

<hr style="border: 2px solid #FF9966;">

### Change values.yaml file and IMAGE_VERSION
- [x] Change values.yaml file and IMAGE_VERSION

When Terraform Project finished his work copy his outputs and enter to Kubernetes/Helm/values.yaml file:

- Enter VPC ID to line 250

- Enter Public Subnet A to line 266

- Enter Public Subnet B to line 270

- Enter Application ARN to line 292

- Enter Prometheus ARN to line 296

- Enter Grafana ARN to line 300

You should also change Images to your value for your project in 4 places from values.yaml

Now go to IMAGE_VERSION file and enter new version of Application and make git commit and push to GitHub

```
git status
git add *
git commit -m "Add new version"
git push
```

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Terraform/Change-Helm.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/GitHub-Actions/Start-GitHub.png?raw=true">

<hr style="border: 2px solid #FF9966;">

### Check your CI/CD GitHub Actions
- [x] Check your CI/CD GitHub Actions

Go to GitHub --> Actions and verify that all your GitHub Actions successfully completed and check Load Balancer in AWS Console

After CI Pipeline if it was successfull CD Pipeline will start automatically and Deploy everything

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/GitHub-Actions/GitHub-Actions-CI-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/GitHub-Actions/GitHub-Actions-CI-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/GitHub-Actions/GitHub-Actions-CI-3.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/GitHub-Actions/GitHub-Actions-CI-4.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/GitHub-Actions/GitHub-Actions-CI-5.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/GitHub-Actions/GitHub-Actions-CI-6.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/GitHub-Actions/GitHub-Actions-CD-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/GitHub-Actions/GitHub-Actions-CD-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/GitHub-Actions/GitHub-Actions-CD-3.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/GitHub-Actions/GitHub-Actions-CD-4.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/GitHub-Actions/GitHub-Actions-CD-5.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/GitHub-Actions/GitHub-Actions-CD-6.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/GitHub-Actions/GitHub-Actions-CD-7.png?raw=true">

DockerHub after CI/CD Pipeline

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/DockerHub/DockerHub-List.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/DockerHub/DockerHub-Main.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/DockerHub/DockerHub-Players.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/DockerHub/DockerHub-Training.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/DockerHub/DockerHub-Users.png?raw=true">

New AWS Updates for Resources:

CloudFormation:

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/CloudFormation/CloudFormation.png?raw=true">

CloudWatch Logs:

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/CloudWatch/CloudWatch-Logs-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/CloudWatch/CloudWatch-Logs-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/CloudWatch/CloudWatch-Logs-3.png?raw=true">

Application LoadBalancer:

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/LoadBalancer/LoadBalancer-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/LoadBalancer/Listener-Rules.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/LoadBalancer/Target-Groups.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/LoadBalancer/LoadBalancer-2.png?raw=true">

<hr style="border: 2px solid #FF9966;">

### Attach Route53 Records to ALB
- [x] Attach Route53 Records to ALB

Go to AWS Console to Route53 Service

Now Add New Records for Application, Grafana and Prometheus attach them with Record type A with Alias to Ingress Load Balancer

Go to the DNS Names and check if everything works correctly, also the redirection from HTTP to HTTPS

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/Route53/Application-Record.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/Route53/Grafana-Record.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/Route53/Prometheus-Record.png?raw=true">

My Application:

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Website/Website-Main.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Website/Redirect-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Website/Redirect-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Website/Redirect-3.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Website/Website-Players-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Website/Website-Players-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Website/Website-Players-3.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Website/Website-Players-4-Wiki.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Website/Website-Players-5.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Website/Website-Register-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Website/Website-Register-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Website/Website-Login-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Website/Website-Login-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Website/Website-Training-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Website/Website-Training-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Website/Website-Training-3.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Website/Website-Training-4.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Website/Website-Chat-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Website/Website-Chat-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Website/Website-Chat-3.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Website/Website-Chat-4-Logout.png?raw=true">

To make sure that everthing works correctly I test Lambda and checked DynamoDB Table

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Website/Lambda-Test-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Website/DynamoDB-Test-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Website/DynamoDB-Test-2.png?raw=true">

<hr style="border: 2px solid #FF9966;">

### Configure Grafana
- [x] Configure Grafana

The Last step of Project to configure our Monitoring Grafana

Please check in Prometheus Service (Website Application) if in Targets you have all EKS Nodes

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Prometheus/Prometheus-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Prometheus/Prometheus-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Prometheus/Prometheus-3.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Prometheus/Prometheus-4.png?raw=true">

If you have all EC2 Instances (Nodes) with Node Exporter on them go to Grafana Service (Website Application)

Let's Connect first of all Prometheus to Grafana

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Grafana-Website-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Grafana-Website-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Grafana-Website-3.png?raw=true">

Connections --> Data sources --> Add new data source --> Prometheus --> in URL to Prometheus enter: *http://prometheus-service:80* and Save

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Connect-Prometheus.png?raw=true">

Now Let's Check if SMTP works correctly with our Email

Alerting --> Contact points --> Add contact point --> Click on Test --> Send test notification

If your SMTP works correctly you will get an email and success message in Grafana

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/SMTP-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/SMTP-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/SMTP-3.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/SMTP-4-Gmail.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/SMTP-5.png?raw=true">

Now we may start to work with Grafana

Let's Import Dashboard *Node-exporter-full*

Dashboards --> New --> Import --> 1860 --> Load --> Choose Prometheus --> Import

Check if every Node works correctly

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Import-Dashboard-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Import-Dashboard-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Import-Dashboard-3.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Dashboard-Result-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Dashboard-Result-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Dashboard-Result-3.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Dashboard-Result-4.png?raw=true">

To create Alerts from your Dashboard Go to the Dashboard

Choose some metric you want to check --> Edit --> More --> New alert rule --> Change Threshold --> Click Preview (If everything Normal continue) --> Set evaluation behavior (Create Folder and Group) --> Contact email (Choose your configured SMTP email) --> Save rule and exit

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Alert-Rule-CPU-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Alert-Rule-CPU-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Alert-Rule-CPU-3.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Alert-Rule-CPU-4.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Alert-Rule-CPU-5.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Alert-Rule-CPU-6.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Alert-Rule-CPU-7.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Alert-Rule-CPU-8.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Alert-Rule-CPU-9.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Alert-Rule-CPU-10.png?raw=true">

I added 3 different Alert Rules for the Project: CPU, Disk Space, Memory (RAM)

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Alert-Rule-Disk-Space-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Alert-Rule-Disk-Space-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Alert-Rule-Disk-Space-3.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Alert-Rule-Disk-Space-4.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Alert-Rule-Disk-Space-5.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Alert-Rule-Disk-Space-6.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Alert-Rule-Memory-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Alert-Rule-Memory-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Alert-Rule-Memory-3.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Alert-Rule-Memory-4.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Alert-Rule-Memory-5.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Alert-Rule-Memory-6.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Alert-Rule-Memory-7.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Alert-Rules-Results-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Alert-Rules-Results-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Alert-Rules-Results-3.png?raw=true">

<hr style="border: 2px solid #FF9966;">

### Update new version to check automation
- [x] Update new version to check automation

Check in Main index.html number of version or something else and change version number in IMAGE_VERSION and push the new commit

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Update_Version/GitHub-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Update_Version/GitHub-2.png?raw=true">

Now see Zero-Downtime deployment from my Project's Application

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Update_Version/Website.png?raw=true">

<hr style="border: 2px solid #FF9966;">
