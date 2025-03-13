module "instance_group" {
  source         = "./modules/instance-group"
  region         = var.region
  instance_count = var.instance_count
}

module "load_balancer" {
  source         = "./modules/load-balancer"
  instance_group = module.instance_group.instance_group_name
}

output "load_balancer_ip" {
  value = module.load_balancer.lb_ip
}
