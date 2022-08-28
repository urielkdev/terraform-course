export .env variables easly with command: `export $(cat .env | sed 's/#.*//g' | xargs)`

# Variables
You can use variables from system environment variables with `TF_VAR_` prefix, or by defining them in a `terraform.tfvars` file like the `terraform.tfvars.example`
Precedence order: `-var` or `-var-file` in command line > `terraform.tfvars` > environments variables with `TF_VAR_*` > default declaration

# Setup
- Create a ssh key-par, copy de path of public key and paste in the ssh_key_path variable