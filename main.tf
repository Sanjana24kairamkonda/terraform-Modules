/*module "instance_group" {
  source         = "./instance-group"
  region         = var.region
  instance_count = var.instance_count
}*/

module "load_balancer" {
  source         = "./load-balancer"
  instance_group = "my-mig"
}

output "load_balancer_ip" {
  value = module.load_balancer.lb_ip
}
