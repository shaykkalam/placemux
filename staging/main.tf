module "dev_network" {
  source             = "../modules/vpc"
  env_name           = "staging"
  vpc_cidr           = "10.2.0.0/16"
  public_subnet_cidr = "10.2.1.0/24"
}
module "staging_secrets" {
  source   = "../modules/secrets"
  env_name = "staging"
}