variable "config_path" {
  type = string
  description = "value of the config path"
}
variable "host" {
  type = string
  description = "value of the host"
}

variable "grafana_admin_user" {
  type = string
  description = "value of the grafana admin user"
}
variable "grafana_admin_password" {
  type = string
  description = "value of the grafana admin password"
}

variable "grafana_node_port" {
  type = number
  description = "value of the grafana node port"
}
variable "prometheus_node_port" {
  type = number
  description = "value of the prometheus node port"
}