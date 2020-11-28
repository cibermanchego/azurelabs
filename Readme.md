Credits: I based this in these 2 projects. All credit goes to them. 
* christophetd: https://github.com/christophetd/Adaz 
* clong: https://github.com/clong/DetectionLab

- Structure:
    1. Terraform:
        netowrk.tf - Network elements definitiions
        vars.tf - Variable definitions
        main.tf - Linux VM definition
        outputs.tf - Public IPs and passwords output
        windows.tf - All Windows VMs definitions
        terraform.tfvars - User controlled variable values
    2. Ansible:

- How to run:
    Just run terraform init and terraform apply.
    Generates 2 Windows servers and a Linux server (CentOS 7.8) in a subnet, and 1 Windows 10 WS in a different subnet.
    Connection is only allowed from the public ip defined in the terraform.tfvars file.
    Define in terraform.tfvars your local public and private SSH keys, that then you can use to login to the logger machine.
        