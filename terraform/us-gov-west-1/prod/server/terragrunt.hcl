# This file sets up the RKE2 cluster servers in AWS using an autoscale group

locals {
  env = merge(
    yamldecode(file(find_in_parent_folders("region.yaml"))),
    yamldecode(file(find_in_parent_folders("env.yaml")))
  )
image_id = run_cmd("sh", "-c", "aws ec2 describe-images --owners 'aws-marketplace' --filters 'Name=product-code,Values=cynhm1j9d2839l7ehzmnes1n0' --query 'sort_by(Images, &CreationDate)[-1].[ImageId]' --output 'text'")
}

terraform {
  source = "git::https://repo1.dso.mil/platform-one/distros/rancher-federal/rke2/rke2-aws-terraform.git//?ref=v2.1.0"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id = "vpc-mock"
    private_subnet_ids = ["mock_priv_subnet1", "mock_priv_subnet2", "mock_priv_subnet3"]
  }
}

dependency "ssh" {
  config_path = "../ssh"
  mock_outputs = {
    public_key = "mock_public_key"
  }
}

inputs = {
  cluster_name  = local.env.name
  vpc_id        = dependency.vpc.outputs.vpc_id
  subnets       = dependency.vpc.outputs.private_subnet_ids
  ami           = local.image_id
  servers       = local.env.cluster.server.replicas
  instance_type = local.env.cluster.server.type
  download      = true
  enable_ccm    = true
  rke2_version  = local.env.cluster.rke2_version
  iam_instance_profile = "InstanceOpsRole"

  block_device_mappings = {
    size = local.env.cluster.server.storage.size
    encrypted = local.env.cluster.server.storage.encrypted
    type = local.env.cluster.server.storage.type
  }

  ssh_authorized_keys = [dependency.ssh.outputs.public_key]

  pre_userdata = local.env.cluster.init_script

  tags = merge(local.env.region_tags, local.env.tags, {})

  # Big Bang uses Istio instead of NGINX
  # https://docs.rke2.io/advanced/#disabling-server-charts/
  rke2_config = <<EOF
disable:
  - rke2-ingress-nginx
EOF

}
