<div align="center">

  <img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Project/Main-Logo.png?raw=true" alt="logo" width="500" height="auto" />

<h1>DribbleData Project</h1>
  
  <p>
    Exemplifies modern DevOps practices by efficiently managing complex infrastructure with automated testing, secure deployments, AWS service integration, scaling strategies, and downtime prevention to handle real-world challenges</strong>
  </p>
</div>

 &nbsp; &nbsp; &nbsp; &nbsp; ![Flask](https://img.shields.io/badge/flask-%23000.svg?style=for-the-badge&logo=flask&logoColor=white) &nbsp; ![Grafana](https://img.shields.io/badge/grafana-%23F46800.svg?style=for-the-badge&logo=grafana&logoColor=white) &nbsp; ![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=Prometheus&logoColor=white) &nbsp; ![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white) &nbsp; ![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)  &nbsp;  ![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white) ![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white) &nbsp; ![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white) &nbsp; ![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white) &nbsp; ![CSS3](https://img.shields.io/badge/css3-%231572B6.svg?style=for-the-badge&logo=css3&logoColor=white) &nbsp; ![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54) &nbsp; ![JavaScript](https://img.shields.io/badge/javascript-%23323330.svg?style=for-the-badge&logo=javascript&logoColor=%23F7DF1E) &nbsp; ![HTML5](https://img.shields.io/badge/html5-%23E34F26.svg?style=for-the-badge&logo=html5&logoColor=white)  &nbsp;

<h2>🔍 About the Project</h2>

The project, named DribbleData, is built using a microservices architecture, meaning it is composed of several smaller, independent services rather than one large application. These microservices are created using Flask, a popular Python web framework known for its simplicity and flexibility.

Data storage and management are key aspects of the project, leveraging various Amazon Web Services (AWS) solutions. Amazon S3 buckets are utilized to store files such as images and documents, while DynamoDB, a fast and flexible NoSQL database, handles structured data, ensuring quick access and scalability.

The project makes efficient use of serverless computing through AWS Lambda, allowing specific functions to execute only when needed, thereby conserving resources and reducing costs. To orchestrate different events and actions within the system, Amazon EventBridge is employed, functioning as a sophisticated event scheduler.

Containerization is integral to the project's architecture. Docker is used to package the application and its dependencies, ensuring consistent environments across different stages of development. Kubernetes, specifically Amazon's EKS service, manages these containers, ensuring they run smoothly and can be easily scaled up or down as required. Helm, a package manager for Kubernetes, simplifies the deployment and management of these containerized applications.

The development workflow is streamlined through continuous integration and delivery (CI/CD) pipelines, powered by GitHub Actions. This setup ensures that code changes are automatically tested and, if successful, seamlessly deployed to the production environment.

To monitor the health and performance of the system, the project utilizes Prometheus for collecting metrics, and Grafana for visualizing these metrics in intuitive dashboards. Fluent Bit plays a crucial role in gathering and forwarding logs, which is vital for troubleshooting and understanding system behavior.

Security is paramount in the project. Adhering to security best practices, the project employs data encryption, secure secrets management, and robust authentication and authorization mechanisms to protect sensitive information and prevent unauthorized access.

Additionally, the project incorporates other AWS services, such as Route 53 for domain management and CloudFront for the efficient global delivery of static content, enhancing the project's global reach and performance.

In summary, the DribbleData project represents a state-of-the-art approach to building scalable, secure, and efficient cloud applications. It leverages a wide array of modern tools and practices to deliver a robust, flexible, and high-performing system.


<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Project/Project-Scheme.jpeg?raw=true">

<hr style="border: 2px solid #FF9966;">

## ☁️ Full Scheme of Project in AWS

This diagram represents the AWS architecture used in the DribbleData project. It highlights the key components and their interactions:

VPC (Virtual Private Cloud) DribbleData Virginia:

Within the VPC, public and private subnets are created to ensure resource isolation and security.
Public Subnets (A and B):

A Bastion Host is placed in one of the public subnets but if something happens with Subnet in Datacenter A, Auto-Scaling will create it in Datacenter B in public subnet B, serving as a secure gateway for remote access to private subnets.

An Application Load Balancer (ALB) is set up to distribute incoming traffic across the EKS cluster nodes.

Private Subnets:

The private subnets host the EKS Cluster (Elastic Kubernetes Service) with nodes running t3.medium instances, where the application workloads are deployed.

An AWS ALB Controller is used to manage application load balancing.

Network Configuration:


NAT Gateway and Elastic IP are configured to allow outbound internet access for resources in private subnets.

Security:

Security Groups are assigned to resources to control inbound and outbound traffic.

SSL Certificates managed by AWS Certificate Manager are used to secure the domain names like dribbledata.matveyguralskiy.com, grafana.matveyguralskiy.com, and prometheus.matveyguralskiy.com

Route 53 is configured to manage DNS records for these domains.

Monitoring and Logging:

Fluent Bit is deployed within the EKS cluster to forward logs to CloudWatch Logs

A Lambda function is configured to automatically update nodes and apply patches

Backup and Storage:

An S3 Bucket is used to store Terraform remote state and media content, with CloudFront set up for CDN distribution

The AWS Backup service is configured to back up DynamoDB tables and S3 bucket contents, with a backup plan managed through EventBridge


<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Project/AWS-Scheme.jpeg?raw=true">

<hr style="border: 2px solid #FF9966;">

## 🛠️ Continuous Integration

Continuous Integration (CI) process for the DribbleData project involves the developer making changes to Flask microservices, which then go through a series of automated steps using GitHub Actions. These steps include building Docker images, testing them for vulnerabilities, and finally ensuring that all microservices work together properly

Steps of CI:

1. Developer: The process begins with a developer working on Flask microservices, which are divided into four separate services: Main, Players, Users, and Training.

2. Change Image Version: After making changes to the microservices, the developer updates the image version file.

3. Git Commit: The updated code, along with the version file, is committed to the GitHub repository.

4. GitHub Repository: The code is pushed to the GitHub repository, which triggers the Continuous Integration (CI) process using GitHub Actions.

5. GitHub Actions (CI): The CI process involves several steps:

- Setup GitHub Actions: GitHub Actions are configured to automate the CI pipeline.

- Create .env File: An environment file is created or updated to configure and connect to the microservices.

- Unit Tests: Unit tests are executed to ensure that the code is functioning correctly.

- Update Image Version for Helm: The updated image version is applied in Helm charts.

- Build Docker Images: Docker images are built for each microservice.

- Push to DockerHub: The newly built Docker images are pushed to DockerHub.

- Test Containers with Aqua Trivy: The Docker containers are scanned for vulnerabilities using Aqua Trivy.

- Docker-Compose Test: A final test is conducted using Docker Compose to ensure the containers work together as expected.

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Project/CI-Scheme.jpeg?raw=true">

<hr style="border: 2px solid #FF9966;">

## 🚀 Continuos Deployment

Continuous Deployment (CD) process for the DribbleData project begins after the successful execution of the CI pipeline, leading to a series of automated steps managed by GitHub Actions. These steps include configuring Kubernetes with AWS credentials, installing the ALB Controller, and updating Helm files, ensuring the proper deployment of service

Steps of CD:

1. GitHub Actions CI Pipeline: The Continuous Deployment (CD) process starts only if the Continuous Integration (CI) pipeline is successfully executed

2. GitHub Actions (CD): If the CI pipeline succeeds, the CD pipeline is triggered using GitHub Actions

3. Setup GitHub Actions: GitHub Actions are configured to handle the deployment process.

4. Update Kubeconfig: The kubeconfig file is updated to interact with the Kubernetes cluster.

5. Associate IAM OIDC Provider: An IAM OpenID Connect (OIDC) provider is associated with the Kubernetes cluster to manage authentication.

6. Install Policy for ALB Controller: A policy is installed to allow the AWS ALB (Application Load Balancer) Controller to manage load balancers.

7. Create ServiceAccount for ALB Controller with CloudFormation: A ServiceAccount is created for the ALB Controller using AWS CloudFormation.

8. Install and Update Helm Repository: The Helm repository is installed and updated to manage Kubernetes packages.

9. Install ALB Controller: The ALB Controller is installed in the Kubernetes cluster.

10. Wait until ALB Controller Starts Working: The process waits until the ALB Controller is fully operational.

11. Create Namespace: A namespace is created within the Kubernetes cluster for organizing resources.

12. Create AWS Credentials Secrets: AWS credentials are stored as secrets within Kubernetes for secure access.

13. Generate Kubernetes Secrets File: A secrets file is generated within Kubernetes, containing the necessary credentials and configurations.

14. Install and Update Helm Files: Helm files are installed and updated based on the latest configurations.

15. Verify All Kubernetes Helm Files: The final step involves verifying that all Kubernetes Helm files are correctly configured and operational.

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Project/CD-Scheme.jpeg?raw=true">

<hr style="border: 2px solid #FF9966;">

## 💵 Project Cost Overview

I used AWS Calculator to estimate summary generated AWS Resources. Inside directory *FinOps* I got the file named *Project - AWS Pricing Calculator.pdf* The file contains all monetary calculations of resources.  

It outlines the expected costs for various AWS services, including clusters, storage, serverless functions, and domains, based on specific configurations for the user's project. A monthly cost of **$516.09**, and a total 12-month cost of **$6,373.08​**

<hr style="border: 2px solid #FF9966;">

## 📺 Video Demonstration

[![Demonstration Video](https://img.youtube.com/vi/ZUP0Qz46HkY/maxresdefault.jpg)](https://youtu.be/ZUP0Qz46HkY)

<hr style="border: 2px solid #FF9966;">

## Screens

### Screens of Application:

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Website/Website-Main.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Website/Website-Players-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Website/Website-Training-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Website/Website-Register-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Website/Website-Chat-3.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Website/Redirect-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Website/Website-Login-2.png?raw=true">

### Screens of CI/CD:

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/GitHub-Actions/GitHub-Actions-CI-3.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/GitHub-Actions/GitHub-Actions-CI-5.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/GitHub-Actions/GitHub-Actions-CD-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/GitHub-Actions/GitHub-Actions-CD-5.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/GitHub-Actions/GitHub-Actions-CD-7.png?raw=true">

### Screens of Grafana:

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Dashboard-Result-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Dashboard-Result-3.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Dashboard-Result-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Alert-Rules-Results-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Grafana/Alert-Rules-Results-3.png?raw=true">

### Screens of Prometheus:

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Prometheus/Prometheus-3.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/Prometheus/Prometheus-4.png?raw=true">

### Screens of AWS Services:

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/DynamoDB/DynamoDB-5.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/Lambda/Delete-Old-Messages-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/Lambda/Update-Nodes-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/CloudWatch/CloudWatch-Logs-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/System-Manager/SSM-Fleet-Manager.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/LoadBalancer/LoadBalancer-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/LoadBalancer/LoadBalancer-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/VPC/VPC-1.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/DribbleData/blob/main/Screens/Demo/AWS-Console/S3/S3-Bucket-Project-4.png?raw=true">

<hr style="border: 2px solid #FF9966;">

## 👣 Documentation Part with Detailed Steps

For complete documentation and steps to implement the project please follow the documentation folder

[Documentation Directory](https://github.com/MatveyGuralskiy/DribbleData/tree/main/Documentation)

<hr style="border: 2px solid #FF9966;">

<h2>📂 Repository</h2>
<p>
  |-- .github/workflows
  
  |-- /Application

  |-- /Docker

  |-- /Documentation

  |-- /DynamoDB

  |-- /FinOps

  |-- /Kubernetes

  |-- /Lambda

  |-- /SSM

  |-- /Screens

  |-- /Static

  |-- /Terraform

  |-- .gitignore

  |-- IMAGE_VERSION

  |-- LICENSE

  |-- README.md

</p>

## 📚 Acknowledgments
Documentations for you to make the project

* [AWS for begginers](https://aws.amazon.com/getting-started/)
* [Terraform work with AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
* [Docker Build Images](https://docs.docker.com/build/)
* [DockerHub Registry](https://docs.docker.com/docker-hub/)
* [Git Control your code](https://git-scm.com/doc)
* [HTML to build Application](https://developer.mozilla.org/en-US/docs/Web/HTML)
* [CSS to style Application](https://developer.mozilla.org/en-US/docs/Web/CSS)
* [SSH connect to Instances](https://www.ssh.com/academy/ssh/command)
* [AWS Load Balancer Controller](https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html)
* [EKS Cluster](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html)

<h2>📢 Additional Information</h2>
<p>
  I hope you liked my project, don’t forget to rate it and if you notice a code malfunction or any other errors.
  
  Don’t hesitate to correct them and be able to improve your project for others
</p>

## 🗨️ Contacts

<p align="center">
  <a href="https://github.com/MatveyGuralskiy/DribbleData">
    <img src="https://img.shields.io/badge/Clone-Project-FF9966?style=for-the-badge&logo=github" alt="Clone Project"/>
  </a>
  
  <a href="https://www.linkedin.com/in/matveyguralskiy/">
    <img src="https://img.shields.io/badge/LinkedIn-Profile-003366?style=for-the-badge&logo=linkedin" alt="LinkedIn Profile"/>
  </a>

  <a href="mailto:mathewguralskiy@gmail.com">
    <img src="https://img.shields.io/badge/Gmail-Contact-b80b06?style=for-the-badge&logo=gmail" alt="Gmail"/>
  </a>

  <a href="https://matveyguralskiy.com">
    <img src="https://img.shields.io/badge/My-Website-76db6d?style=for-the-badge" alt="Website"/>
  </a>
</p>
<br>

<h2>© License</h2>
<p>
Distributed under the MIT license. See LICENSE.txt for more information.
</p>
