resource "tailscale_acl" "as_json" {
  acl = jsonencode({
    tagOwners : {
      "tag:server" : [],
      "tag:k8s-operator" : [],
      "tag:k8s" : ["tag:k8s-operator"],
      "tag:zpyo-deploy" : [],
      "tag:zpyo-host" : [],
    }
    hosts : {
      "dongodb-mac-mini" : "100.117.17.121",
    }
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
        src : ["autogroup:member"]
        dst : ["*"]
        ip : ["*"]
      },
      {
        src : ["tag:server", "tag:k8s-operator", "tag:k8s"]
        dst : ["tag:server", "tag:k8s-operator", "tag:k8s"]
        ip : ["*"]
      },
      {
        src : ["tag:k8s"]
        dst : ["dongodb-mac-mini"]
        ip : ["tcp:18000"]
      },
      {
        src : ["tag:zpyo-deploy"]
        dst : ["tag:zpyo-host"]
        ip : ["tcp:22"]
      },
      {
        src : ["group:admin"]
        dst : ["tag:k8s-operator"]
        ip : ["tcp:443"]
        app : {
          "tailscale.com/cap/kubernetes" : [{
            impersonate : {
              groups : ["system:masters"]
            }
          }]
        }
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
      },
      {
        src : "group:admin"
        proto : "tcp"
        accept : ["tag:k8s-operator:443"]
      },
      {
        src : "kyokuping@github"
        proto : "tcp"
        accept : ["tag:k8s:80", "tag:server:22"]
      },
      {
        src : "tag:k8s"
        proto : "tcp"
        accept : ["dongodb-mac-mini:18000"]
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
