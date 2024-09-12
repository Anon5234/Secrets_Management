node_name = "consul-server"
data_dir    = "/consul/data"  
bind_addr   = "0.0.0.0"     
client_addr = "0.0.0.0"
server = true
bootstrap_expect = 1


# Enable the Consul Web UI using the new syntax
ui_config {
  enabled = true  # Enable the Consul Web UI
}

ports {
  http  = 8500  # Enable HTTP on port 8500 (disable HTTPS for now)
  https = -1    # Disable HTTPS
}
