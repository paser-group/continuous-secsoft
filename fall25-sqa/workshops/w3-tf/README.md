## Docker-based Infrastructure Management with Terraform 

The goal of this workshop is to provide students hands-on experience on Terraform, a popular tool to manage configurations of computing infrastructure, such as AWS EC2 instances and Docker containers. 

### Pre-lab Content Dissemination 

Infrastructure as code (IaC) is the practice of creating and managing computing infrastructure at scale. Practitioners implement IaC with tools such as Terraform. Use of Terraform has yielded benefits for organizations. For example, using Terraform, Asian Development Bank reduced its provisioning time for virtual machines from 4 days to less than 5 minutes. As another example, use of Terraform helped GitHub to reduce its time to perform load balancing by 96%. 


Terraform is syntactically defined using HashiCorp Configuration Language (HCL). There are two constructs in Terraform: arguments and blocks. Arguments are used for value assignments. Blocks are used to describe infrastructure-related entities (e.g., resource, variable). 


### In-class Activity 

We will perform three major activities:  

- Installation 
- Scripting 
- Command execution 


##### Installation (OSX)

- `brew tap hashicorp/tap` 
- `brew install hashicorp/tap/terraform` 
- `brew update` 
- `brew upgrade hashicorp/tap/terraform` 
- `terraform -help` 


##### Installation (Windows)

- See `https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli`

##### Scripting to create Docker-based infrastructure 

- Install and enable Docker 
- `touch simple.tf` 
- copy the following code into simple.tf
```
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {
   host ="/Users/akondrahman/.docker/run/docker.sock"
}


resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "tutorial"
  ports {
    internal = 80
    external = 8000
  }
}
```
- `terraform init`
- `terraform fmt`
- `terraform validate` 
- `terraform apply`
- type in `yes` when prompted 
- inspect state with `terraform show` 
- verify with `docker ps -a`


##### Scripting to update Docker-based infrastructure (Relevant for Post-class Activity)

- change port number 
- `terraform validate` 
- `terraform apply`
- type in `yes` when prompted 
- inspect state with `terraform show` 
- verify with `docker ps -a`

##### Command to delete Docker-based infrastructure 

- `terraform destroy` 
- verify with `docker ps -a` 


### Post-class Activity 

- Update the created image with new ports 443 and 3000 respectively for `internal` and `external`
- Export all output of `terraform validate`, `terraform show`, and `docker ps -a` command into a separate text file called `output.txt`
- Export all output of `terraform destroy` into a separate text file called `destroy.txt`
- Deadline: Sep 23 2025, 11:59 PM CST  


### Rubric 

- `output.txt` and `destroy.txt` files with necessary content: 60%
- Terraform script: 40%