node_name = "consul-server"
data_dir    = "/consul/data"  
bind_addr   = "0.0.0.0"     
client_addr = "0.0.0.0"
server = true
bootstrap_expect = 1
datacenter = "dc1"

ui_config {
  enabled = false
}

ports {
  http  = -1  
  https = 8501  
}

tls {
   defaults {
      ca_file = "/etc/consul.d/certs/dc1.consul-agent-ca.pem"
      cert_file = "/etc/consul.d/certs/dc1-server-consul-0.pem"
      key_file = "/etc/consul.d/certs/dc1-server-consul-0-key.pem"

      verify_incoming = true
      verify_outgoing = true
   }
   internal_rpc {
      verify_server_hostname = true
   }
}

auto_encrypt {
  allow_tls = true
}

