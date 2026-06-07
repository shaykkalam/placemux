module "dev_network" {
  source             = "../modules/vpc"
  env_name           = "dev"
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
}
module "dev_secrets" {
  source   = "../modules/secrets"
  env_name = "dev"
}