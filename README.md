# magento-iac

# Magento and Varnish
Infrastructure as a code with Terraform

## main.tf
Used to build the 2 instances, one for Varnish server and one for Magento using LEMP stack. It also assigns elastic IPs to both of the instances.

## variables.tf
Assign default values to all the variables.


## security-groups.tf
Creating the 3 security groups -for Magento, Varnish, and the load balancer- and defining the inbound and outbound rules.


## network.tf
Creates the custom VPC, creates 2 subnets for the load balancer, associates them with the route table, and assigns the internet gateway.

## load-balancer.tf
It imports the certificate created with my account for the HTTPS listener. I created a hosted zone and a Route 53 record to validate my certificate. 
This is an application balancer, that routes all requests to the Varnish server, and the ones that contain /media or /static in the path go directly to Magento.
It has 2 listeners, one HTTP who is responsible for redirecting HTTP to HTTPS requests, and one HTTPS which is responsible for the correct routing depending on the path of the requests.
