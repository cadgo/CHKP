# GWLB-Lab-Generator

PendingWhat is this for:

A Terraform template to create a simple and fast GWLB architecture for customer demo

Lab general overview:

Use cases:

1.	Security protection for Public VPC using edge association and GWLBe
2.	Protection between two vpcs
3.	Internet traffic inspection

VPC1 and 2
•	Two public subnets
•	Two private subnets
•	Two GLWBe subnets for edge association
•	Two transit subnet for attachments
•	RT to route traffic
•	Two public and private Ec2

![screenshot](https://github.com/cadgo/CHKP/blob/recursos/Terraform/labs/gwlb-lab-creator/recursos/recurso1.png)

Variables

![screenshot](https://github.com/cadgo/CHKP/blob/recursos/Terraform/labs/gwlb-lab-creator/recursos/recurso2.png)

If is needed change the VPC1 and 2 cidr, and modify endpoint and twgconnection with their 3rd octet

It is optional the Ec2 deployment the default value is true


Steps:

First, deploy your security vpc to fill the variables 


![screenshot](https://github.com/cadgo/CHKP/blob/recursos/Terraform/labs/gwlb-lab-creator/recursos/recurso3.png)

For a terraform deployment, use the Check Point official CloudGuard IAAS 

https://github.com/CheckPointSW/CloudGuardIaaS/tree/master/terraform/aws/tgw-gwlb-master

After the creation for the GWLB subnet execute the Lab Template


Todo:

All is done by the terraform for use cases 2 and 3, case number 1 needs to create route tables for public subnets and point it to the gwlbe, the module use for this lab doesn’t allow to modify a default RT for a subnet, require for fix


