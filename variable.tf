variable "webserver_region" {default = "us-east-1"}
variable "webserver_instanceType" {default = "t2.micro"}
variable "webserver_ami" {default = "ami-042e8287309f5df03"}
variable "webserver_vpc_block" {default = "10.0.0.0/16"}
variable "webserver_subnet_block" {default = "10.0.1.0/24"}
