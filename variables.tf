variable "tailscale_oauth_client_id" {
  type      = string
  sensitive = true
}

variable "tailscale_oauth_client_secret" {
  type      = string
  sensitive = true
}

variable "tailscale_tailnet" {
  type = string
}

variable "tailscale_admins" {
  type = list(string)
}
