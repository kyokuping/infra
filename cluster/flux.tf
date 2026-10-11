resource "helm_release" "flux_operator" {
  name              = "flux-operator"
  namespace         = "flux-system"
  create_namespace  = true
  chart             = "${path.module}/../chart/flux-system/flux-operator"
  version           = yamldecode(file("${path.module}/../chart/flux-system/flux-operator/Chart.yaml")).version
  values            = [file("${path.module}/../chart/flux-system/flux-operator/values.yaml")]
  atomic            = true
  dependency_update = true

  depends_on = [helm_release.cilium]

  lifecycle {
    prevent_destroy = true
  }
}

resource "helm_release" "flux" {
  name              = "flux"
  namespace         = "flux-system"
  chart             = "${path.module}/../chart/flux-system/flux-instance"
  version           = yamldecode(file("${path.module}/../chart/flux-system/flux-instance/Chart.yaml")).version
  values            = [file("${path.module}/../chart/flux-system/flux-instance/values.yaml")]
  atomic            = true
  dependency_update = true
  timeout           = 600

  depends_on = [helm_release.flux_operator]

  lifecycle {
    prevent_destroy = true
  }
}
