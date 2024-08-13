MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

--==MYBOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash

#---------------------------
# DribbleData Project
# Created by Matvey Guralskiy
#---------------------------

# Update the instance
sudo yum update -y

# Install SSM Agent
sudo yum install -y amazon-ssm-agent

# Enable and start the SSM Agent service
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent

--==MYBOUNDARY==--