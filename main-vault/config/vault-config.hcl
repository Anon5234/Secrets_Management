storage "consul" {
  address       = "http://consul-server:8500"
  scheme        = "http"  
  service       = "vault"
  path          = "vault/"
}

listener "tcp" {
  address       = "0.0.0.0:8200"
  tls_disable   = 1
}

seal "transit" {
  address            = "http://vault-transit-server:8350" 
  token              = "REPLACE_WITH_TOKEN"
  key_name           = "autounseal"
  mount_path         = "transit/"
  tls_skip_verify    = true
}

api_addr      = "http://vault-main-server:8200"
disable_mlock        = true
log_level            = "info"
ui = true
