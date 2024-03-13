minikube = {
  cluster_name       = "minikube"
  driver             = "docker" # Options: docker, podman, kvm2, qemu, hyperkit, hyperv, ssh
  kubernetes_version = "v1.28.3"  # See available options: "minikube config defaults kubernetes-version" or refer to: https://kubernetes.io/releases/
  container_runtime  = "containerd" # Options: docker, containerd, cri-o
  nodes              = "1"
}

# METALLB
metallb = {
  install           = true
  name              = "metallb-system"
  namespace         = "metallb-system"
  create_namespace  = true

  repository        = "https://metallb.github.io/metallb"
  chart             = "metallb"
  #version          = "4.9.1" # Chart version
  serviceMonitor_enabled = false
}


# ARGOCD
argocd = {
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true

  repository      = "https://argoproj.github.io/argo-helm"
  chart           = "argo-cd"
  #version        = "4.9.1"               # Chart version
  server_service_type  = "LoadBalancer"   # Values: ClusterIP, LoadBalancer, NodeIP
  timeout_reconciliation = "10s"          # Default: 180s. Reconciliation timeout (drift) how often it will sync ArgoCD with the Git repository.
}