variable "label" {
  type        = string
  description = "This Firewall's unique label"
}

variable "disabled" {
  type        = bool
  default     = false
  description = "If true, the Firewall's rules are not enforced"
}

variable "inbound_rules" {
  type = list(object({
    label    = string
    action   = string
    protocol = string
    ports    = string
    ipv4     = list(string)
    ipv6     = list(string)
  }))
  default     = null
  description = "A list of firewall rules (as maps) that specifies what inbound network traffic is allowed"
}

variable "inbound_policy" {
  type        = string
  nullable    = false
  description = "The default behavior for inbound traffic. This setting can be overridden by updating the inbound.action property of the Firewall Rule"
  validation {
    condition     = contains(["ACCEPT", "DROP"], var.inbound_policy)
    error_message = "Please pass in a string equal to one of the following: [\"ACCEPT\", \"DROP\"]."
  }
}

variable "outbound_rules" {
  type = list(object({
    label    = string
    action   = string
    protocol = string
    ports    = string
    ipv4     = list(string)
    ipv6     = list(string)
  }))
  default     = null
  description = "A list of firewall rules (as maps) that specifies what outbound network traffic is allowed"
}

variable "outbound_policy" {
  type        = string
  nullable    = false
  description = "The default behavior for inbound traffic. This setting can be overridden by updating the inbound.action property of the Firewall Rule"
  validation {
    condition     = contains(["ACCEPT", "DROP"], var.outbound_policy)
    error_message = "Please pass in a string equal to one of the following: [\"ACCEPT\", \"DROP\"]."
  }
}

variable "linodes" {
  type        = list(string)
  nullable    = false
  description = "A list of IDs of Linodes this Firewall should govern it's network traffic for"
}

variable "tags" {
  type        = list(string)
  description = "A list of tags applied to the Kubernetes cluster. Tags are for organizational purposes only"
}