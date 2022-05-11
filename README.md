# Polygon Edge AWS Terraform deployment

This is a fully automated Terraform AWS deployment. 
After running `terrraform apply` you'll be able to use the JSON-RPC provided in the output 
and immediately start using the Polygon Edge blockchain.

## How to use

* clone this repo
* in repo root run `terraform init` to initialize modules
* make *terraform.tfvars* file and define your secrets
  * `ssh_key_name` - the name for your ssh public key.
  * `ssh_public_key` - your public ssh key which will be used to authenticate to Bastion host.
  * `admin_ip` - your public ip address which will be set in Security Group to allow ssh connection to Bastion host. 
  CIDR format is required even for a single IP address.
  * `account_id` - the AWS Account ID
  * `premine` - accounts and amount of funds to premine in format `<account>:<ammount>` as per 
  [docs premine cli command](https://edge-docs.polygon.technology/docs/get-started/cli-commands#genesis-flags)


## Considerations

This deployment exposes JSON-RPC API via AWS Application Load Balancer, but on http protocol which is not encrypted.
For this API to be used in full production the user will need to configure and properly set up 
the SSL certificate on ALB. 
