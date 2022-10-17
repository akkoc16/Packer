# Packer Golden Image
This repository provides a hardened ubuntu based linux image for the kubernetes nodes.
 
 ### After cloning this repo and editing the scripts, run the following commands:

 > **packer init .** # Initialize your packer configuration

 > **packer fmt .**  # Format your packer configuration

 > **packer validate .** # Validate your packer configuration

 > **packer build --var-file=vars.pkr.hcl main.pkr.hcl** # Build your packer image

