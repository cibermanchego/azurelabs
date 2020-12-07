Credits: I based this in these 2 projects. All credit goes to them. 
* christophetd: https://github.com/christophetd/Adaz 
* clong: https://github.com/clong/DetectionLab

**This is still a work in progress.**
- Structure:
    1. Terraform:
        netowrk.tf - Network elements definitiions
        vars.tf - Variable definitions
        main.tf - Linux VM definition
        outputs.tf - Public IPs and passwords output
        windows.tf - All Windows VMs definitions
        terraform.tfvars - User controlled variable values
        linux.tf - Linux logger VM definition
    2. Ansible:
        Create domain and domain controller:
            ansible-playbook domain_controller.yml
        Join WEF server and WS to domain:
            ansible-playbook domain_controller.yml

- How to run:
    Copy the contents of terraform.tfvars.example to terraform.tfvars and edit it with your public IP and ssh key details to login to logger VM.
    Run terraform init and terraform apply.
    Generates 2 Windows servers and a Linux server (CentOS 7.8) in a subnet, and 1 or more Windows 10 WS in a different subnet.
    Connection is only allowed from the public ip defined in the terraform.tfvars file.
    
        