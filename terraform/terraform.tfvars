# https://azure.microsoft.com/en-us/global-infrastructure/locations/
region = "westus2" 
#public_key_name = "id_logger" # This can be changed to whatever you want
# These values must point to a valid keypair. 
# You'll log into the logger host via: ssh -i /home/user/.ssh/id_logger vagrant@<public_logger_ip>
#public_key_path = "/home/user/.ssh/id_logger.pub" 
#private_key_path = "/home/user/.ssh/id_logger" 
# Replace the IP address below with the IP address(es) you'll be using
# to connect to DetectionLab
ip_whitelist = ["212.68.250.102/32"] 