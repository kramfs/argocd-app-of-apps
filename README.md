# Pre-requisites
Before you dive in, make sure the following tools are set up and ready to go: minikube needs to spin up clusters smoothly, and docker must handle container creation without a hitch. This automated setup relies on them playing their parts flawlessly.

- `Taskfile` - Follow the [installation](https://taskfile.dev/installation/) instruction
- `Minikube` - Follow the [installation](https://minikube.sigs.k8s.io/docs/start/) instruction
- `Terraform` - Follow the [installation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) instruction
- `Docker Engine` - Follow the [installation](https://docs.docker.com/engine/install/) instruction
- `kubectl` - Follow the [installation](https://kubernetes.io/docs/tasks/tools/) instruction
- `jq` - Follow the [installation](https://jqlang.github.io/jq/download/) instruction
- `git` - Follow the [installation](https://github.com/git-guides/install-git) instruction

# Usage

## TASK UP
To bring up the cluster:
```
task up
```

Example:
```
❯ task up
task: [init] terraform init -upgrade

Initializing the backend...
Upgrading modules...
Downloading git::https://github.com/kramfs/tf-minikube-cluster.git for minikube_cluster...
- minikube_cluster in .terraform/modules/minikube_cluster

Initializing provider plugins...
- Finding latest version of hashicorp/helm...
- Finding latest version of hashicorp/kubernetes...
- Finding scott-the-programmer/minikube versions matching "~> 0.3"...
- Installing hashicorp/kubernetes v2.26.0...
- Installed hashicorp/kubernetes v2.26.0 (signed by HashiCorp)
- Installing scott-the-programmer/minikube v0.3.10...
- Installed scott-the-programmer/minikube v0.3.10 (self-signed, key ID 336AB9C62499A32D)
- Installing hashicorp/helm v2.12.1...
- Installed hashicorp/helm v2.12.1 (signed by HashiCorp)

....

Terraform has been successfully initialized!

.....

task: [apply] terraform apply $TF_AUTO

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # helm_release.argocd will be created
  + resource "helm_release" "argocd" {
      + atomic                     = false
      + chart                      = "argo-cd"
      + cleanup_on_fail            = false
      + create_namespace           = true
      + dependency_update          = false
      + disable_crd_hooks          = false
      + disable_openapi_validation = false
      + disable_webhooks           = false
      + force_update               = false
      + id                         = (known after apply)
      + lint                       = false
      + manifest                   = (known after apply)
      + max_history                = 0
      + metadata                   = (known after apply)
      + name                       = "argocd"
      + namespace                  = "argocd"
      + pass_credentials           = false
      + recreate_pods              = false
      + render_subchart_notes      = true
      + replace                    = false
      + repository                 = "https://argoproj.github.io/argo-helm"
      + reset_values               = false
      + reuse_values               = false
      + skip_crds                  = false
      + status                     = "deployed"
      + timeout                    = 300

...

 # module.minikube_cluster.minikube_cluster.docker will be created
  + resource "minikube_cluster" "docker" {
      + addons                     = [
          + "default-storageclass",
          + "metrics-server",
          + "storage-provisioner",
        ]
      + apiserver_ips              = (known after apply)
      + apiserver_name             = "minikubeCA"
      + apiserver_names            = (known after apply)
      + apiserver_port             = 8443
      + auto_pause_interval        = 1
      + auto_update_drivers        = true
      + base_image                 = "gcr.io/k8s-minikube/kicbase:v0.0.42@sha256:d35ac07dfda971cabee05e0deca8aeac772f885a5348e1a0c0b0a36db20fcfc0"
      + cache_images               = true
      + cert_expiration            = 1576800
  ...
  }

Plan: 2 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + minikube_domain = "cluster.local"
  + minikube_ip     = (known after apply)
  + minikube_name   = "minikube"
module.minikube_cluster.minikube_cluster.docker: Creating...
module.minikube_cluster.minikube_cluster.docker: Still creating... [10s elapsed]
module.minikube_cluster.minikube_cluster.docker: Still creating... [20s elapsed]
module.minikube_cluster.minikube_cluster.docker: Still creating... [30s elapsed]
module.minikube_cluster.minikube_cluster.docker: Creation complete after 31s [id=minikube]
helm_release.argocd: Creating...
helm_release.argocd: Still creating... [10s elapsed]
helm_release.argocd: Still creating... [20s elapsed]
helm_release.argocd: Still creating... [30s elapsed]
helm_release.argocd: Still creating... [40s elapsed]
helm_release.argocd: Still creating... [50s elapsed]
helm_release.argocd: Still creating... [1m0s elapsed]
helm_release.argocd: Still creating... [1m10s elapsed]
helm_release.argocd: Still creating... [1m20s elapsed]
helm_release.argocd: Creation complete after 1m22s [id=argocd]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

minikube_domain = "cluster.local"
minikube_ip = "https://192.168.49.2:8443"
minikube_name = "minikube"

To view the ArgoCD UI, open https://10.98.36.248
Username is admin
YpP1CmhN-nGjWqAN

application.argoproj.io/control-app created

```

Once the `minikube_cluster` is created indicated by the following:
```
module.minikube_cluster.minikube_cluster.docker: Creation complete after 31s [id=minikube]
```

Run the minikube tunnel service so the services set with `LoadBalancer` type can get an IP assigned
```
minikube tunnel
```
otherwise it will be stuck in pending state and the message with keep repeating until the Terraform timeout is reached and eventually the deployment will fail.
```
helm_release.argocd: Still creating...
```

## APPLICATION WORKFLOW

To deploy the app:
```
task deploy-app
```
To remove the app:
```
task destroy-app
```


## TASK CLEANUP
To destroy and clean up the cluster:
```
task cleanup
```

Example:

```
❯ task cleanup
task: [destroy] terraform destroy $TF_AUTO
module.minikube_cluster.minikube_cluster.docker: Refreshing state... [id=minikube]
helm_release.argocd: Refreshing state... [id=argocd]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # helm_release.argocd will be destroyed
  - resource "helm_release" "argocd" {
  ...
  }

  # module.minikube_cluster.minikube_cluster.docker will be destroyed
  - resource "minikube_cluster" "docker" {
  ...
  }

Plan: 0 to add, 0 to change, 2 to destroy.

Changes to Outputs:
  - minikube_domain = "cluster.local" -> null
  - minikube_ip     = "https://192.168.49.2:8443" -> null
  - minikube_name   = "minikube" -> null
helm_release.argocd: Destroying... [id=argocd]
helm_release.argocd: Destruction complete after 1s
module.minikube_cluster.minikube_cluster.docker: Destroying... [id=minikube]
module.minikube_cluster.minikube_cluster.docker: Destruction complete after 3s
╷
│ Warning: Helm uninstall returned an information message
│ 
│ These resources were kept due to the resource policy:
│ [CustomResourceDefinition] applications.argoproj.io
│ [CustomResourceDefinition] applicationsets.argoproj.io
│ [CustomResourceDefinition] appprojects.argoproj.io
│ 
╵

Destroy complete! Resources: 2 destroyed.
task: [cleanup] find . -name '*terraform*' -print | xargs rm -Rf
```

Typing `task` will show up the available options
