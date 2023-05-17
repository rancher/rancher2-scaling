variable "label" {
  type        = string
  default     = null
  description = "The label of the Linode NodeBalancer"
}

variable "region" {
  type        = string
  description = "The region where this NodeBalancer will be deployed.  Examples are \"us-east\", \"us-west\", \"ap-south\", etc. See all regions [here](https://api.linode.com/v4/regions).  *Changing `region` forces the creation of a new Linode NodeBalancer.*"
}

variable "tags" {
  type        = list(string)
  default     = null
  description = "A list of tags applied to this object. Tags are for organizational purposes only."
}

variable "node_count" {
  type        = number
  description = "Number of linodes to add to the nodebalancer"
}

variable "linodes" {
  type = list(object({
    label              = string
    private_ip_address = string
  }))
  description = "A list of objects containing the label and private_ip_address of each linode to be added to the nodebalancer. Can pass a list of data.linode_instances as well"
}
