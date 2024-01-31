module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"

  name = "candycrush-eks"

  cidr = var.vpcCIDR
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = [var.privSub1CIDR, var.privSub2CIDR, var.privSub3CIDR]
  public_subnets  = [var.pubSub1CIDR, var.pubSub2CIDR, var.pubSub3CIDR]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}