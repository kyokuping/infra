resource "helm_release" "nvidia_device_plugin" {
  name              = "nvidia-device-plugin"
  namespace         = "nvidia-device-plugin"
  create_namespace  = true
  chart             = "${path.module}/../chart/nvidia-device-plugin"
  version           = yamldecode(file("${path.module}/../chart/nvidia-device-plugin/Chart.yaml")).version
  values            = [file("${path.module}/../chart/nvidia-device-plugin/values.yaml")]
  atomic            = true
  dependency_update = true
  timeout           = 600

  depends_on = [helm_release.cilium]

  lifecycle {
    prevent_destroy = true
  }
}
