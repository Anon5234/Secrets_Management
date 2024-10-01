storage "consul" {
  address       = "https://consul-server:8501"
  scheme        = "https"  
  service       = "vault"
  path          = "vault/"

  tls_ca_file   = "/vault/config/certs/dc1.consul-agent-ca.pem"
  tls_cert_file = "/vault/config/certs/dc1-client-consul-0.pem"
  tls_key_file  = "/vault/config/certs/dc1-client-consul-0-key.pem"
}

listener "tcp" {
  address       = "0.0.0.0:8200"
  tls_cert_file = "/etc/certs/vault.crt"  
  tls_key_file  = "/etc/certs/vault.key" 
}

seal "awskms" {
  region     = "${AWS_REGION}"
  access_key = "${AWS_ACCESS_KEY_FILE}"
  secret_key = "${AWS_SECRET_KEY_FILE}"
  kms_key_id = "${VAULT_AWSKMS_SEAL_KEY_ID}"
}


api_addr             = "https://vault-main-server:8200"
disable_mlock        = true
log_level            = "info"
ui = true

