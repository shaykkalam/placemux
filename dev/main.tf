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
module "dev_postgres" {
  source    = "../modules/postgres"
  env_name  = "dev"
  vpc_id    = module.dev_network.vpc_id
  subnet_ids = module.dev_network.subnet_ids
}
module "dev_container_runtime" {
  source   = "../modules/ecs"
  env_name = "dev"
}