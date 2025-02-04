resource "tailscale_acl" "as_json" {
  acl = jsonencode({
    tagOwners : {
      "tag:server" : [],
      "tag:k8s-operator" : [],
      "tag:k8s" : ["tag:k8s-operator"],
    }
    acls : [
      {
        action : "accept"
        src : ["*"]
        dst : ["*:*"]
      }
    ]
    groups : {
      "group:admin" : var.tailscale_admins
    }
    ssh : [
      {
        action : "check"
        src : ["autogroup:member"]
        dst : ["autogroup:self"]
        users : ["autogroup:nonroot", "root"]
      },
      {
        action : "check"
        src : ["group:admin"]
        dst : ["tag:server"]
        users : ["autogroup:nonroot", "root"]
      }
    ]
    grants : [
      {
        src : ["group:admin"]
        dst : ["tag:k8s-operator"]
        app : {
          "tailscale.com/cap/kubernetes" : [{
            impersonate : {
              groups : ["system:masters"]
            }
          }]
        }
      }
    ]
    nodeAttrs : [
      {
        target : ["autogroup:member"]
        attr : ["funnel"]
      }
    ]
  })
}
