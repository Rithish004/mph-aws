#!/bin/bash
export AWS_REGION="us-east-1"
export KEY_PAIR_NAME="aws-instances-key"
export KEY_FILE="./outputs/${KEY_PAIR_NAME}.pem"

export AMI_AMAZON_LINUX="ami-0c02fb55956c7d316"
export AMI_UBUNTU="ami-0557a15b87f6559cf"
export AMI_WINDOWS="ami-0f9c44e98edf38a2b"

export INSTANCE_TYPE_UNIX="t3.micro"
export INSTANCE_TYPE_WINDOWS="t3.medium"

export SG_UNIX_NAME="unix-instances-sg"
export SG_WINDOWS_NAME="windows-instances-sg"

export UNIX_INSTANCE_1_NAME="linux-amazon-01"
export UNIX_INSTANCE_2_NAME="linux-ubuntu-01"
export UNIX_INSTANCE_3_NAME="linux-ubuntu-02"
export WINDOWS_INSTANCE_1_NAME="windows-server-01"
export WINDOWS_INSTANCE_2_NAME="windows-server-02"
