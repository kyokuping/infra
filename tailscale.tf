resource "tailscale_acl" "as_json" {
  acl = jsonencode({
    tagOwners : {
      "tag:server" : []
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
    nodeAttrs : [
      {
        target : ["autogroup:member"]
        attr : ["funnel"]
      }
    ]
  })
}
