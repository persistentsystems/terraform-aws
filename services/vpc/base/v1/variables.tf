
variable "context" {
  type = object({

    app_name = string
    env_name = string
    location = string

  })
}

variable "vpc_settings" {
  type = object({

    cidr_block = string                         ## "Primary CIDR block for the VPC"
    instance_tenancy = string                   ## "Tenancy option type for instances launched inside the VPC"
    enable_ipv6 = bool                          ## "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC"
    additional_cidr_blocks = list(string)       ## "List of additional CIDR blocks to associate with the VPC later on to extend the IP Address pool"
    custom_tags = map(string)                   ## "Extra tags to attach to the VPC resources on top of what we will always add"
    priv-sub_custom_tags = map(string)          ## To be used for EKS node groups to launch worked nodes in private subnets only
    pub-sub_custom_tags = map(string)           ## To be used for EKS node groups to launch ingress controllers in public subnets
  })
  default = {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_ipv6 = false
    additional_cidr_blocks = []
    custom_tags = {}
    priv-sub_custom_tags = {}
    pub-sub_custom_tags = {}
  }
  
}

variable "subnet_settings" {
    type = object({

        private_subnet_cidr_blocks = list(string)
        public_subnet_cidr_blocks = list(string)
#        availability_zones = list(string)
     })
    default = {
        private_subnet_cidr_blocks = ["10.1.0.0/24", "10.2.0.0/24"]
        public_subnet_cidr_blocks = ["10.3.0.0/24", "10.4.0.0/24"]
        availability_zones = ["us-east-1a", "us-east-1b"]
    }

}
