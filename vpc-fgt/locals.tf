locals {
  # ----------------------------------------------------------------------------------
  # Subnet cidrs (UPDATE IF NEEDED)
  # ----------------------------------------------------------------------------------
  subnet_public_cidr       = cidrsubnet(var.vpc-sec_cidr, 4, 0)
  subnet_proxy_cidr        = cidrsubnet(var.vpc-sec_cidr, 4, 1)
  subnet_onpremises_cidr   = cidrsubnet(var.vpc-sec_cidr, 4, 2)
  subnet_bastion_cidr      = cidrsubnet(var.vpc-sec_cidr, 4, 3)
  subnet_mgmt_cidr         = cidrsubnet(var.vpc-sec_cidr, 4, 4)
  subnet_private1_cidr     = cidrsubnet(var.vpc-sec_cidr, 4, 5)
  subnet_private2_cidr     = cidrsubnet(var.vpc-sec_cidr, 4, 6)
  subnet_private3_cidr     = cidrsubnet(var.vpc-sec_cidr, 4, 7)
  subnet_private4_cidr     = cidrsubnet(var.vpc-sec_cidr, 4, 8)
  # ----------------------------------------------------------------------------------
  # FGT IP (UPDATE IF NEEDED)
  # ----------------------------------------------------------------------------------
  fgt-1_ni_mgmt_ip     = cidrhost(local.subnet_mgmt_cidr, 10)
  fgt-1_ni_public_ip   = cidrhost(local.subnet_public_cidr, 10)
  fgt-1_ni_private1_ip  = cidrhost(local.subnet_private1_cidr, 10)
  fgt-1_ni_private2_ip  = cidrhost(local.subnet_private2_cidr, 10)
  fgt-1_ni_private3_ip  = cidrhost(local.subnet_private3_cidr, 10)
  fgt-1_ni_private4_ip  = cidrhost(local.subnet_private4_cidr, 10)

  fgt-2_ni_mgmt_ip    = cidrhost(local.subnet_mgmt_cidr, 11)
  fgt-2_ni_public_ip  = cidrhost(local.subnet_public_cidr, 11)
  fgt-2_ni_private1_ip = cidrhost(local.subnet_private1_cidr, 11)
  fgt-2_ni_private2_ip = cidrhost(local.subnet_private2_cidr, 11)
  fgt-2_ni_private3_ip = cidrhost(local.subnet_private3_cidr, 11)
  fgt-2_ni_private4_ip = cidrhost(local.subnet_private4_cidr, 11)
  # ----------------------------------------------------------------------------------
  # FAZ and FMG
  # ----------------------------------------------------------------------------------
  faz_ni_public_ip  = cidrhost(local.subnet_public_cidr, 12)
  faz_ni_private_ip = cidrhost(local.subnet_bastion_cidr, 12)
  fmg_ni_public_ip  = cidrhost(local.subnet_public_cidr, 13)
  fmg_ni_private_ip = cidrhost(local.subnet_bastion_cidr, 13)
  # ----------------------------------------------------------------------------------
  # iLB
  # ----------------------------------------------------------------------------------
  ilb_ip = cidrhost(local.subnet_private1_cidr, 9)
  # ----------------------------------------------------------------------------------
  # NCC
  # ----------------------------------------------------------------------------------
  ncc_private_ips = [
    cidrhost(local.subnet_private1_cidr, 5),
    cidrhost(local.subnet_private1_cidr, 6)
  ]
  ncc_public_ips = [
    cidrhost(local.subnet_public_cidr, 5),
    cidrhost(local.subnet_public_cidr, 6)
  ]
  # ----------------------------------------------------------------------------------
  # Bastion VM
  # ----------------------------------------------------------------------------------
  bastion_ni_ip = cidrhost(local.subnet_bastion_cidr, 10)
}