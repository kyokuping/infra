resource "helm_release" "cilium" {
  name              = "cilium"
  namespace         = "kube-system"
  chart             = "${path.module}/../chart/cilium"
  version           = yamldecode(file("${path.module}/../chart/cilium/Chart.yaml")).version
  values            = [file("${path.module}/../chart/cilium/values.yaml")]
  atomic            = true
  dependency_update = true
  timeout           = 900

  lifecycle {
    prevent_destroy = true
  }
}
