#############################
### Create Public DNS
#############################
resource "aws_route53_record" "public" {
  zone_id = data.aws_route53_zone.dns_zone.zone_id
  name    = "${var.subdomain}.${var.domain}"
  type    = "CNAME"
  ttl     = 30
  records = [module.aws_infra_rke2.lb_dns]
}

