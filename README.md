# terraform-provider-metal-examples

This is a working example for [terraform-provider-metal](https://github.com/metal-stack-cloud/terraform-provider-metal) which sets up a Kubernetes cluster on [metalstack.cloud](https://metalstack.cloud) and thereafter applies an Nginx deployment including a Service type LoadBalancer.

The `main.tf` acts as a glue between the `metal-infra` module, that manages the cluster, and the module `metal-app`, that
owns Kubernetes resources. In order to be able to configure the [kubernetes provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs) a valid kubeconfig must exist. Therefore applying needs two steps:

```bash
# 1. create cluster and retrieve valid kubeconfig
# Only needs to be run if current kubeconfig is expired or missing
terraform apply -target local_sensitive_file.kubeconfig # -auto-approve

# 2. deploy kubernetes resources
terraform apply # -auto-approve
```

## Extract using Output

In case you only need the kubeconfig, you can also add an output for it:

```hcl
output "kubeconfig" {
  value = data.metal_kubeconfig.app_kubeconfig.raw
}
```

```bash
terraform refresh
terraform output -raw kubeconfig > app.kubeconfig
```
