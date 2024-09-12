storage "consul" {
  address       = "http://consul-server:8500"
  scheme        = "http"
  service       = "vault-transit"
  path          = "vault-transit/"
}

listener "tcp" {
  address       = "0.0.0.0:8350"
  tls_disable   = 1
}

api_addr = "http://vault-transit-server:8350"
disable_mlock = true
ui = true
