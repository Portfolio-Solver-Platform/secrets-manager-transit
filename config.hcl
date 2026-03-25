ui = false

storage "file" {
  path = "/openbao/data"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  
  # WARNING: TLS is disabled here to get you up and running quickly.
  # In a real production environment, you should provision a certificate 
  # for this VM and set tls_disable = 0, providing the tls_cert_file and tls_key_file.
  tls_disable = 1 
}

