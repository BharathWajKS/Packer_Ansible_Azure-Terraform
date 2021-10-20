Azure DevOps Demo - CI/CD using Packer,Terraform, Ansible and Shared Image Gallery (SIG)

==================================================================

Building Immutable Infrastructure using Azure DevOps
At a high level this repository contains code for "Building Immutable Infrastructure Demo", it demonstrates how to build a Golden VM Image and version control it using Shared Image Gallery in Azure and optionally deploy infra and application using Terraform using same image.

Use Case(s)
This address 2 use cases.

How do you automate the deployment of example Java Application end-to-end without using GUI.
How do you automate a VM patching on-going basis.
Following is the high level flow:

Azure DevOps Build gets and packages artifacts from github
Azure DevOps Release invokes packer to build image from Azure Marketplace RHEL 7.3 image and save into ManagedDisk
Packer uses ansible-local provisioner to install Tomcat and a Java application code into the image.
Packer build an Image and it's Pushed to Shared Image Gallery for Version Control and replicated to 2 region to keep a local copy for Developers/Infra Team to download from closet Azure Region bsed on their geo location.
Azure DevOps release invokes terraform to provision infrastructure (VMSS, LB, NSG) and point VMSS to image stored by packaer in ManagedDisks -Terraform State is stored in a Azure Storage Account.


High Level Steps
Step1) Developer(s) commit code or configuration change in their Github Repo

Step2) Azure DevOps CI Builds and packages application

Step3) Azure DevOps Release invokes Packer to build a Linux image.

Step4) Packer invokes the Ansible Playbook provisioner to install JDK, Tomcat and SpringBoot application, captures VM as Golden Image and save it as Azure Managed Image.

Step5) AzureDevOps pushes same Managed image build by Packer to Shared Image Gallery for version control and replicates to 2 addtional regions.

Step6) AzureDevOps Release invokes Terraform to provision Infrastructure (ALB,VMSS) and uses same managed image build by Packer.

Step7) Browse URL given by Terraform to Validate your Application is deployed using Infrastructure as Code.

Packer
Packer template for Azure Image is located at packer/app.json. It stores prepared image in managed disks in Resource group provided by environment variable ARM_RESOURCE_GROUP_DISKS, this resource group should be created before the build (TODO: add creation to pipeline)

Packer will invoke ansible-local provisioner that will copy required files and invoke apache.yml Ansible playbook

Ansible
Ansible playbookpacker/apache.yml installs and congigures Apache and copies application files (HTMLs, Images) (TODO: wire more sophisticated playbook)

Terraform
Terraform template is located at terraform/azure. It creates VM Scale Set based on Packer prepared imagestored in Managed disks Azure DevOps uses Azure Storage backend to store state file. Storrge account and Container should be created before staring the build. (Defaults are in backend.tfvars)
