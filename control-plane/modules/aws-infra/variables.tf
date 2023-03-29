variable "server_image_id" {
  type        = string
  default     = null
  description = "AMI to use for rke1 server instances"
}

variable "volume_size" {
  type        = string
  default     = "50"
  description = "Size of shared EBS volume allocated for the nodes"
}

variable "ssh_keys" {
  type        = list(any)
  default     = []
  description = "SSH keys to inject into Rancher instances"
}

variable "ssh_key_path" {
  default     = null
  type        = string
  description = "Path to the ssh_key file to be used for connecting to the nodes"
}

variable "name" {
  type        = string
  default     = "rancher-scaling"
  description = "Name used for various resources, used as a prefix for individual instance names"
}

variable "subdomain" {
  default     = null
  type        = string
  description = "subdomain to host rancher on, instead of using `var.name`"
}

variable "domain" {
  type    = string
  default = ""
}

variable "r53_domain" {
  type        = string
  default     = ""
  description = "DNS domain for Route53 zone (defaults to domain if unset)"
}

variable "server_instance_type" {
  type    = string
  default = "m5.large"
}

variable "server_node_count" {
  type        = number
  default     = 1
  description = "Number of server nodes to launch"
}

variable "server_instance_ssh_user" {
  type        = string
  default     = "ubuntu"
  description = "Username for sshing into instances"
}

variable "install_docker_version" {
  type        = string
  default     = "20.10"
  description = "Version of Docker to install"
}

variable "vpc_id" {
  type        = string
  default     = null
  description = "The vpc id that Rancher should use"
}

variable "public_subnets" {
  default     = []
  type        = list(any)
  description = "List of public subnet ids."
}

variable "private_subnets" {
  default     = []
  type        = list(any)
  description = "List of private subnet ids."
}

variable "create_rancher_security_group" {
  type        = bool
  default     = true
  description = "Boolean flag defining if the included rancher server-specific security group should be created"
}

variable "extra_security_groups" {
  default     = []
  type        = list(any)
  description = "List of IDs for additional security groups to attach to rke1 server instances"
}

variable "aws_azs" {
  default     = null
  type        = list(any)
  description = "List of AWS Availability Zones in the VPC"
}

variable "private_subnets_cidr_blocks" {
  default     = []
  type        = list(any)
  description = "List of cidr_blocks of private subnets"
}

variable "s3_instance_profile" {
  default     = ""
  type        = string
  description = "Optional: String that defines the name of the IAM Instance Profile that grants S3 access to the EC2 instances"
}

variable "create_internal_nlb" {
  default     = true
  type        = bool
  description = "Boolean that defines whether or not to create an internal load balancer"
}

variable "create_external_nlb" {
  default     = true
  type        = bool
  description = "Boolean that defines whether or not to create an external load balancer"
}

variable "use_route53" {
  default     = true
  type        = bool
  description = "Configures whether to use route_53 DNS or not"
}

variable "user" {
  type = string
}

variable "user_data_parts" {
  default = []
  type = list(object({
    filename     = string
    content_type = string
    content      = string
    })
  )
  description = "A list of maps defining parts of a multi-part `cloudinit_config` resource. Each `part` should be a valid user_data file that can be run at boot"
}
