# terraform-aws-modules

A collection of useful Terraform modules for the AWS cloud.

This repository is in two main categories:

### Components

A component is a module in the Terraform terminology that contains a small building block of a larger cloud infrastructure setup. Components are usually built arount one resource extended by opinionated defaults and best practices. An example of a typical component is a private S3 bucket with encryption enabled and public access disabled by default.
Components are meant to compose well with other components and modules to fullfill more complex, less generic use cases.

### Modules

Modules are complex compositions of components and other modules to fullfill specific use cases.
Modules do not necessarily need to complose well, their main focus is to solve a recuring problem well. An example for a typical module is 


A list of all components and modules can be found below. See the components / modules Readme for details on specifics and usage.

All components and modules in this repository make use of the [terraform-space-context](https://github.com/spaceteams/terraform-space-context)

## Components

  * [**ecr-private**](components/ecr-private)
  
    A private ECR container registry with encryption and lifetime policies by default. 

  * [**s3-bucket-private**](components/s3-bucket-private)
  
    A private and secure S3 bucket with encryption transport policies by default.

## Modules
