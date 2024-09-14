output "bastion" {
  value = module.bastion.sg_id
}
output "vpn" {
  value = module.vpn.sg_id
}
output "db" {
  value = module.db.sg_id
}
output "backend" {
  value = module.backend.sg_id
}
output "frontend" {
  value = module.frontend.sg_id
}
output "internal_alb" {
  value = module.internal_alb.sg_id
}
output "external_alb" {
  value = module.external_alb.sg_id
}