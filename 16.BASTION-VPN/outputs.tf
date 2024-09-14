output "bastion" {
  value = "ssh -i \"siva.pem\" ec2-user@${module.bastion.public_dns}"
}
output "vpn" {
  value = "ssh -i \"siva.pem\" openvpnas@${module.vpn.public_dns}"
}
