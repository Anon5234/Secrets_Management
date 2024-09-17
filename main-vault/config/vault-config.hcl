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

seal "awskms" {
  region     = "${AWS_REGION}"
  access_key = "${AWS_ACCESS_KEY_FILE}"
  secret_key = "${AWS_SECRET_KEY_FILE}"
  kms_key_id = "${VAULT_AWSKMS_SEAL_KEY_ID}"
}


api_addr      = "http://vault-main-server:8200"
disable_mlock        = true
log_level            = "info"
ui = true
