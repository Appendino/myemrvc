variable "pod_exec_role" {
  default = "eksctl-fargate-tutorial-cl-FargatePodExecutionRole-9BL20CFD3N4H"
  type = string
}

variable "subnets_ids" {
  type = list
  default = ["subnet-0c0210702378609d3","subnet-08907d1710b63340d","subnet-0c267f6126ae37790","subnet-0dbca33d924eceb45"]
}

variable "cluster_name" {
  type = string
  default = "fargate-tutorial-cluster-2"
}

variable "emr_virtual_cluster" {
  type = map
  default = {
      "cluster01" = {
        "max_memory" = "3Gi"
        "max_cpu" = "3"
      },
      "cluster02" = {
        "max_memory" = "10Gi"
        "max_cpu" = "1"
      },
      "cluster03" = {
        "max_memory" = "14Gi"
        "max_cpu" = "80"
      },
      "cluster04" = {
        "max_memory" = "17Gi"
        "max_cpu" = "8"
      }
    }
}

