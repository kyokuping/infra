resource "tailscale_acl" "as_json" {
  acl = jsonencode({
    tagOwners : {
      "tag:server" : [],
      "tag:k8s-operator" : [],
      "tag:k8s" : ["tag:k8s-operator"],
      "tag:zpyo-deploy" : [],
      "tag:zpyo-host" : [],
    }
    acls : [
      {
        action : "accept"
        src : ["autogroup:member", "tag:server", "tag:k8s-operator", "tag:k8s"]
        dst : ["*:*"]
      },
      {
        action : "accept"
        src : ["tag:zpyo-deploy"]
        dst : ["tag:zpyo-host:22"]
        proto : "tcp"
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
        dst : ["tag:server", "tag:zpyo-host"]
        users : ["autogroup:nonroot", "root"]
      },
      {
        action : "accept"
        src : ["tag:zpyo-deploy"]
        dst : ["tag:zpyo-host"]
        users : ["zpyo-deploy"]
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
    tests : [
      {
        src : "tag:zpyo-deploy"
        proto : "tcp"
        accept : ["tag:zpyo-host:22"]
        deny : ["tag:zpyo-host:80", "tag:zpyo-host:443", "tag:k8s-operator:6443"]
      },
      {
        src : "tag:zpyo-deploy"
        proto : "udp"
        deny : ["tag:zpyo-host:22"]
      }
    ]
    sshTests : [
      {
        src : "tag:zpyo-deploy"
        dst : ["tag:zpyo-host"]
        accept : ["zpyo-deploy"]
        deny : ["root", "zpyo"]
      }
    ]
  })
}
