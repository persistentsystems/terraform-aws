variable "context" {
  type = object({

    app_name = string
    env_name = string
    location = string

  })
}

variable "ecr_settings" {
     type = object({

    repository_name = string
    attach_lifecycle_policy = bool
    tag_mutability = string
    scan_on_push = bool
    untagged_days = number
    custom_tags = map(string)
    
  })
     default = {
    repository_name = "ecr_repo"
    attach_lifecycle_policy = true
    tag_mutability = "MUTABLE"
    scan_on_push = false
    untagged_days = 10
    custom_tags = {}
     }
}



