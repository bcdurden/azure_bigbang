# Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.1]

### Changed
- Security groups between internet facing network load balancer and agent's node ports updated to fix ingress

## [1.1.0]

### Added

- Upload of private SSH to encrypted S3 bucket
- Rename of `default` Kubernetes profile to environment name
- Change permissions of local Kubernetes config file to read/write of owner only

### Changed

- Migrated terraform classic load balancer to regular load balancer

## [1.0.1]

### Changed

- Terraform cache S3 bucket created off of name in environment

## [1.0.0]

### Added

- Base/shared configuration with ...
  - Big Bang version
  - Location of Big Bang base/chart
  - Iron Bank pull credentials placeholder
- Dev configuration with ...
  - Reduced polling interval
  - Minimized replicas for Gatekeeper
  - Minimized disk, cpu, and memory resources
  - Anonymous authorization for Kiali
  - Secrets placeholder
- Prod configuration with ...
  - Hostname placeholder
  - Secrets placeholder
- Basic documentation
  - [README.md](README.md)
  - [CHANGELOG.md](CHANGELOG.md)
  - [CODEOWNERS](CODEOWNERS)
  - [CONTRIBUTING.md](CONTRIBUTING.md)
- Terraform template for AWS with...
  - Multi-environment support
  - High-availability (cross-zone) and auto-scaling
  - Private and public subnets
  - Load balancer
  - Bastion server
