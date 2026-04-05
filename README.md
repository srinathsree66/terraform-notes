# What is terraform?

terraform is an infrastructure as code tool that lets you build, change, and version infrastructure safely and efficiently. This includes low-level components like compute instances, storage, and networking; and high-level components like DNS entries and SaaS features.

# Providers

we can provide multiple providers at a time

ex:-

```t
terraform{
    required_providers{
local={
    source="hashicorp/local"
    version="2.5.1"
}
aws={
    source="hashicorp/aws"
    version="5.65.0"
}
    }
}
```

## To initialize terraform run the following cmd

```bash
terraform init
```

This cmd creates following
**terraform.lock.hcl** is the metadata related to the provider

**.terraform** directory is toolbox to store all information related to infrastructure and thing downloaded to maintain infrastructure.

# Resources

Defines the Actual components of the infrastructure.

syntax:-

` resource "type" "local_name" {}`

Ex:- different providers have different types of resources.

// AWS

```t
resource "aws_instance" "web"{
    ami           = "ami-alb2c4d4"
    instance_type = "t2.micro"
}

```

# terraform plan (cmd)

when you run this it will tell exact action the terraform is going to perform.

**terraform plan** cmd will show the changes will be added or removed before applying.

If you're happy with changes then we can apply those changes with following cmd

**terraform apply**

It will show again the plan and ask for confirmation if were happy just type **yes** here also we can review the changes before typing **yes**.

## local_sensitive_file -> to store sensitive information

```t
resource "local_sensitive_file" "foo" {
    filename     = "${path.module}/sensitive.txt"
    content       = "this is a sensitive info"
}
```

if we want to destroy all sources/component cmd is. -> **terraform destroy**

```t
resource "local_file" "tf_example1" {
  #   filename = "01_basics/example1.txt"
  filename = "${path.module}/example1.txt"
  content  = "This is updated content for example1.txt created by Terraform using local provider."
}

resource "local_sensitive_file" "tf_example1" {
  filename = "${path.module}/example2.txt"
  content  = "This is updated content for example2.txt created by Terraform using local provider."
}
```

**tf_example1** this has to be unique for each resource type in the above it works fine cuz local_file and local_sensitive_file is different resources.

## terraform plan -out=./plan

tf will generate plan and it will store on plan file. And if we want to apply those changes in plan folder we can run the following cmd **terraform apply "./plan"**

## terraform destroy -auto-approve this will destroy without asking for confimation/approval.

# Terraform State

Terraform state is record of everything we provision/create/manage/delete

terraform state is maintains by itself. and way that it keep track of all the current infrastructure that is already created.

current state -> After running apply cmd, it will compare with desired state, if things doesn't exist if will match with that.
Desired state -> .tf or config files, where we will create resources(EC2, RD,EKS,...)

It will create file called `terraform.tfstate` here everything will recorded. It will update whenever we perform any operation (apply, destroy)

**Simply:-**

**Desired State ---> current State <---> terraform.tfstate(JSON FORMAT)**

```bash
When we run **terraform apply** basically it does two things
    1) created infra
    2) writes to the state files.
```

## Delete resources

we can delete in two ways:-

1. By commenting the that specific resource
2. **terraform destroy -target=type.local_name**

` ex:- terraform destroy -target=local_sensitive_file.tf_sensitive`

## Terraform State CMD

`t terraform state -h ` it lists subcommands

```t SubCommands:-
           list               list resources in the state
           mv                 Move an item in the state
           pull               Pull current state and output to stdout
           push               Update remote state from local state file
           replace-provider   Replace provider in the state
           rm                 Remove instances from state
           show               Show a resource in the state

```

**Usage**
. terraform state list
. terraform state show local_file.example1

## State Drift (\*\*\*)

`Actual infra !== terraform.tfstate`
which means if the actual infra is not equal to the terraform.tfstate file

How is that possible?
what if someone from team manually delete some resources from AWS UI just assume (EC2) instance deleted.

How to fix this?
we can fix it by two ways

1. tf plan, tf apply:- when we run these cmds if the resource not exists on the current state(AWS or AZURE) it will create new one(it will prompt us).
2. tf refresh **(Not recommended)** :- let's say the change made on AWS UI is intentional.
   when we run this it will compare state with actual infra. in actual EC2 deleted it will delete in terraform state.

** terraform plan is best way to handle state drift **

## Even if we create resource as local_sensitive_file on terraform.tfstate we can see the content just assume we stored the login creds on the resource, if the person has access to the terraform state they can easily acces the creds by looing the terraform.tfstate file.

To overcome this issue we have to hide the sensitive data

## Backend Configuration

. A backend defines where terraform stores its state data files. Where we mentioned providers there we can have one more block called backend on that we can specify where we can store our state file.

```t
terraform {

    backend "s3"{
        bucket = "mybucket"
        key ="path/to/mykey"
        region = "us-east-1"

    }

    required_providers{
        local={
            source:"hashicorp/local"
            version:"2.5.1"
        }
    }
}

```

by defult it will be store on local.

If we specify as **s3** the terraform.tfstate will be stored on the s3 with versioning whenver u apply the changes those will be stored in s3 with versioning like v1.0 v1.1 like that (we have to enable bucket versioning in s3).

### Optimization's

optimization of code is ntg but writing code in a best way on .tf files

1. variables and outputs
2. create a terraform module

## Variables and Outputs

Types:-
**Input variables**

```t
variable "aws_region"{
    description = "Aws region"
    type        = string
    default     = "us-west-2"
}

```

**Output variable**

```t
output "instance_ip_address"{
    value = aws_instance.server.private_ip
}

```

**Local variables**

```t
local {
    service_name = "form"
    owner        = "community team"
}
```

we can give values of variables via cli as well

`tf plan -var="aws_region=ap-south-1"`
