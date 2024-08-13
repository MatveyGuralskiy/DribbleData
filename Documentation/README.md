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

<hr style="border: 2px solid #FF9966;">


### Configure secrets of CI/CD GitHub Actions
- [x] Configure secrets of CI/CD GitHub Actions



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

Now go to IMAGE_VERSION file and enter new version of Application and make git commit and push to GitHub

```
git status
git add *
git commit -m "Add new version"
git push
```

<hr style="border: 2px solid #FF9966;">

### Check your CI/CD GitHub Actions
- [x] Check your CI/CD GitHub Actions

Go to GitHub --> Actions and verify that all your GitHub Actions successfully completed and check Load Balancer in AWS Console

After CI Pipeline if it was successfull CD Pipeline will start automatically and Deploy everything

<hr style="border: 2px solid #FF9966;">

### Attach Route53 Records to ALB
- [x] Attach Route53 Records to ALB

Go to AWS Console to Route53 Service

Now Add New Records for Application, Grafana and Prometheus attach them with Record type A with Alias to Ingress Load Balancer

Go to the DNS Names and check if everything works correctly, also the redirection from HTTP to HTTPS

<hr style="border: 2px solid #FF9966;">

### Configure Grafana
- [x] Configure Grafana

The Last step of Project to configure our Monitoring Grafana

Please check in Prometheus Service (Website Application) if in Targets you have all EKS Nodes

If you have all EC2 Instances (Nodes) with Node Exporter on them go to Grafana Service (Website Application)

Let's Connect first of all Prometheus to Grafana

Connections --> Data sources --> Add new data source --> Prometheus --> in URL to Prometheus enter: *http://prometheus-service:80* and Save

Now Let's Check if SMTP works correctly with our Email

Alerting --> Contact points --> Add contact point --> Click on Test --> Send test notification

If your SMTP works correctly you will get an email and success message in Grafana

Now we may start to work with Grafana

Let's Import Dashboard *Node-exporter-full*

Dashboards --> New --> Import --> 1860 --> Load --> Choose Prometheus --> Import

Check if every Node works correctly

<hr style="border: 2px solid #FF9966;">
