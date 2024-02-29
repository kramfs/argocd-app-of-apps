##############
## MINIKUBE ##
##############

module "minikube_cluster" {
  source              = "github.com/kramfs/tf-minikube-cluster"
  cluster_name        = lookup(var.minikube, "cluster_name", "minikube")
  driver              = lookup(var.minikube, "driver", "docker")                 # # Options: docker, podman, kvm2, qemu, hyperkit, hyperv, ssh
  kubernetes_version  = lookup(var.minikube, "kubernetes_version", null)         # See options: "minikube config defaults kubernetes-version" or refer to: https://kubernetes.io/releases/
  container_runtime   = lookup(var.minikube, "container_runtime", "containerd")  # Default: containerd. Options: docker, containerd, cri-o
  nodes               = lookup(var.minikube, "nodes", "1")
}


################
## KUBERNETES ##
################

provider "kubernetes" {
  #config_path = "~/.kube/config"
  host = module.minikube_cluster.minikube_cluster_host

  client_certificate     = module.minikube_cluster.minikube_cluster_client_certificate
  client_key             = module.minikube_cluster.minikube_cluster_client_key
  cluster_ca_certificate = module.minikube_cluster.minikube_cluster_ca_certificate
}

/*
resource "time_sleep" "wait_15_seconds" {
  depends_on = [minikube_cluster.docker]
  create_duration = "15s"
}
*/

##################
## HELM SECTION ##
##################

# HELM PROVIDER
provider "helm" {
  kubernetes {
    host = module.minikube_cluster.minikube_cluster_host
    client_certificate     = module.minikube_cluster.minikube_cluster_client_certificate
    client_key             = module.minikube_cluster.minikube_cluster_client_key
    cluster_ca_certificate = module.minikube_cluster.minikube_cluster_ca_certificate
  }
}


# HELM RELEASE
# REF: https://artifacthub.io/packages/helm/bitnami/nginx
# HELM: helm upgrade ingress-nginx ingress-nginx/ingress-nginx -n ingress-nginx --dry-run
# https://artifacthub.io/packages/helm/bitnami/nginx

resource "helm_release" "argocd" {
  name             = var.argocd.name
  namespace        = var.argocd.namespace
  create_namespace = var.argocd.create_namespace

  repository = var.argocd.repository
  chart      = var.argocd.chart
  version    = lookup(var.argocd, "version", null) # Chart version

  #values = [
  #  file("./values.yaml")
  #]

  values = [templatefile("values.yaml", {
    server_service_type = var.argocd.server_service_type
  })]
}