resource "helm_release" "flux_operator" {
  name             = "flux-operator"
  namespace        = "flux-system"
  create_namespace = true
  chart            = "${path.module}/chart/flux-system/flux-operator"
  atomic           = true
  upgrade_install  = true

  depends_on = [helm_release.cilium]
}

resource "helm_release" "flux" {
  name            = "flux"
  namespace       = "flux-system"
  chart           = "${path.module}/chart/flux-system/flux-instance"
  atomic          = true
  upgrade_install = true

  depends_on = [helm_release.flux_operator]
}
