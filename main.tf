# Create the namespaces for each cluster
resource "kubernetes_namespace" "emr_namespaces" {
  for_each = var.emr_virtual_cluster
  metadata {
    name = each.key
  }
}

# Set values limits for namespaces
resource "kubernetes_resource_quota" "emr_ns_quota" {
  for_each = var.emr_virtual_cluster
  metadata {
    name      = each.key
    namespace = each.key
  }
  spec {
    hard = {
      cpu    = each.value.max_cpu
      memory = each.value.max_memory
    }
  }
  depends_on = [
    kubernetes_namespace.emr_namespaces
  ]
}

# Create fargate profile for each cluster
resource "aws_eks_fargate_profile" "emr_profiles" {
  for_each = var.emr_virtual_cluster
  cluster_name           = data.aws_eks_cluster.this.name
  fargate_profile_name   = each.key
  pod_execution_role_arn = data.aws_iam_role.this.arn
  subnet_ids             = var.subnets_ids

  selector {
    namespace = each.key
  }
}

resource "aws_emrcontainers_virtual_cluster" "emr_vc" {
  for_each = var.emr_virtual_cluster
  container_provider {
    id   = data.aws_eks_cluster.this.name
    type = "EKS"

    info {
      eks_info {
        namespace = each.key
      }
    }
  }

  name = each.key
  depends_on = [
    kubernetes_namespace.emr_namespaces,
    aws_eks_fargate_profile.emr_profiles
  ]
}

