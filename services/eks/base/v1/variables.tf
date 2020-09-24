variable "context" {
  type = object({

    app_name = string
    env_name = string
    location = string

  })
}

variable "eks_cluster_settings" {
    type = object({

    subnet_ids = list(string)
    public_access_cidrs = list(string)
    custom_tags = map(string)
    
  })
}

variable "nodegroup_settings" {
    type = object({

    ami_type = string
    disk_size = number
    instance_types = list(string)
    desired_size = number
    max_size = number
    min_size = number
    custom_tags = map(string)
  })
  default = {
    ami_type = "AL2_x86_64"
    disk_size = 20
    instance_types = ["t3.medium"]
    desired_size = 2
    max_size = 3
    min_size = 2
    custom_tags = {}
  }
}