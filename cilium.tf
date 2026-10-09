resource "helm_release" "cilium" {
  name              = "cilium"
  namespace         = "kube-system"
  chart             = "${path.module}/chart/cilium"
  version           = "0.1.0"
  atomic            = true
  dependency_update = true
  timeout           = 900
}
