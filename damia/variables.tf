module "build_wildRydes" {
  # globals
  source   = "../modules"
  app_name = "wildrydes-ddamia2"
  env      = "damia"
  region   = "us-east-2"
  lambda_name = "RequestUnicorn-ddamia2"
}



