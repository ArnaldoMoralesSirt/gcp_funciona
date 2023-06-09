#------------------------------------------------------------------------------------------------------------
# Create VPCs Fortigate
# - VPC for MGMT and HA interface
# - VPC for Public interface
# - VPC for Private interface  
#------------------------------------------------------------------------------------------------------------
# Create MGMT-HA VPC
resource "google_compute_network" "vpc_mgmt" {
  name                    = "${var.prefix}-vpc-mgmt"
  auto_create_subnetworks = false
}
# Create public VPC
resource "google_compute_network" "vpc_public" {
  name                    = "${var.prefix}-vpc-public"
  auto_create_subnetworks = false
  //  routing_mode            = "GLOBAL"
}
# Create onpremises VPC
resource "google_compute_network" "vpc_onpremises" {
  name                    = "${var.prefix}-vpc-onpremises"
  auto_create_subnetworks = false
  //  routing_mode            = "GLOBAL"
}
# Create private1 VPC
resource "google_compute_network" "vpc_private1" {
  name                    = "${var.prefix}-vpc-private1"
  auto_create_subnetworks = false
  //  routing_mode            = "GLOBAL"
}
# Create private2 VPC
resource "google_compute_network" "vpc_private2" {
  name                    = "${var.prefix}-vpc-private2"
  auto_create_subnetworks = false
  //  routing_mode            = "GLOBAL"
}
# Create private3 VPC
resource "google_compute_network" "vpc_private3" {
  name                    = "${var.prefix}-vpc-private3"
  auto_create_subnetworks = false
  //  routing_mode            = "GLOBAL"
}
# Create private4 VPC
resource "google_compute_network" "vpc_private4" {
  name                    = "${var.prefix}-vpc-private4"
  auto_create_subnetworks = false
  //  routing_mode            = "GLOBAL"
}

#------------------------------------------------------------------------------------------------------------
# Create subnets
# - VPC public: subnet_public, subnet_proxy
# - VPC private: subnet_private, subnet_bastion
# - VPC mgmt: subnet_mgmt
#------------------------------------------------------------------------------------------------------------
### Public Subnet ###
resource "google_compute_subnetwork" "subnet_public" {
  name          = "${var.prefix}-subnet-public"
  region        = var.region
  network       = google_compute_network.vpc_public.name
  ip_cidr_range = local.subnet_public_cidr
}
### Proxy Subnet ###
resource "google_compute_subnetwork" "subnet_proxy" {
  name          = "${var.prefix}-subnet-proxy"
  region        = var.region
  network       = google_compute_network.vpc_public.name
  ip_cidr_range = local.subnet_proxy_cidr
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
}
### Onpremises Subnet ###
resource "google_compute_subnetwork" "subnet_onpremises" {
  name          = "${var.prefix}-subnet-onpremises"
  region        = var.region
  network       = google_compute_network.vpc_onpremises.name
  ip_cidr_range = local.subnet_onpremises_cidr
}
### Private1 Subnet ###
resource "google_compute_subnetwork" "subnet_private1" {
  name          = "${var.prefix}-subnet-private1"
  region        = var.region
  network       = google_compute_network.vpc_private1.name
  ip_cidr_range = local.subnet_private1_cidr
}
### Private2 Subnet ###
resource "google_compute_subnetwork" "subnet_private2" {
  name          = "${var.prefix}-subnet-private2"
  region        = var.region
  network       = google_compute_network.vpc_private2.name
  ip_cidr_range = local.subnet_private2_cidr
}
### Private3 Subnet ###
resource "google_compute_subnetwork" "subnet_private3" {
  name          = "${var.prefix}-subnet-private3"
  region        = var.region
  network       = google_compute_network.vpc_private3.name
  ip_cidr_range = local.subnet_private3_cidr
}
### Private4 Subnet ###
resource "google_compute_subnetwork" "subnet_private4" {
  name          = "${var.prefix}-subnet-private4"
  region        = var.region
  network       = google_compute_network.vpc_private4.name
  ip_cidr_range = local.subnet_private4_cidr
}
### Bastion Subnet ###
resource "google_compute_subnetwork" "subnet_bastion" {
  name          = "${var.prefix}-subnet-bastion"
  region        = var.region
  network       = google_compute_network.vpc_private1.name
  ip_cidr_range = local.subnet_bastion_cidr
}
### HA MGMT SYNC Subnet ###
resource "google_compute_subnetwork" "subnet_mgmt" {
  name                     = "${var.prefix}-subnet-mgmt"
  region                   = var.region
  network                  = google_compute_network.vpc_mgmt.name
  ip_cidr_range            = local.subnet_mgmt_cidr
  private_ip_google_access = true
}

#------------------------------------------------------------------------------------------------------------
# Create firewalls rules
#------------------------------------------------------------------------------------------------------------
# Firewall Rule External MGMT
resource "google_compute_firewall" "allow-mgmt-fgt" {
  name    = "${var.prefix}-allow-mgmt-fgt"
  network = google_compute_network.vpc_mgmt.name

  allow {
    protocol = "all"
  }

  source_ranges = [var.admin_cidr]
  target_tags   = ["${var.prefix}-t-fwr-fgt-mgmt"]
}

# Firewall Rule External PUBLIC
resource "google_compute_firewall" "allow-public-fgt" {
  name    = "${var.prefix}-allow-public-fgt"
  network = google_compute_network.vpc_public.name

  allow {
    protocol = "udp"
    ports    = ["500", "4500", "4789", "${var.backend-probe_port}"]
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080", "8000", "${var.backend-probe_port}"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.prefix}-t-fwr-fgt-public"]
}

# Firewall Rule Internal FGT PRIVATE
resource "google_compute_firewall" "allow-private-fgt" {
  name    = "${var.prefix}-allow-private-fgt"
  network = google_compute_network.vpc_private1.name

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.prefix}-t-fwr-fgt-private"]
}

# Firewall Rule Internal Bastion
resource "google_compute_firewall" "allow-bastion-vm" {
  name    = "${var.prefix}-allow-bastion-vm"
  network = google_compute_network.vpc_private1.name

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.prefix}-t-fwr-bastion"]
}
