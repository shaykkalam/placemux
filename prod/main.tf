module "dev_network" {
  source             = "../modules/vpc"
  env_name           = "prod"
  vpc_cidr           = "10.1.0.0/16"
  public_subnet_cidr = "10.1.1.0/24"
}
module "prod_secrets" {
  source   = "../modules/secrets"
  env_name = "prod"
}