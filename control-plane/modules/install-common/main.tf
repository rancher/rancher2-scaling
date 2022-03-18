terraform {
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
    }
    helm = {
      source = "hashicorp/helm"
    }
    null = {
      source = "hashicorp/null"
    }
    template = {
      source = "hashicorp/template"
    }
  }
}

resource "helm_release" "cert_manager" {
  count            = var.install_certmanager ? 1 : 0
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = var.certmanager_version
  namespace        = "cert-manager"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "null_resource" "wait_for_cert_manager" {
  count = var.install_certmanager ? 1 : 0
  provisioner "local-exec" {
    command = <<-EOT
    timeout --preserve-status 5m sh -c -- 'until [ "$${pods}" = "3" ]; do
      sleep 5
      pods="$(kubectl get pods --namespace cert-manager | grep Running | wc -l | awk '\''{$1=$1;print}'\'')"
      echo "cert-manager pods: $${pods}"
    done'
    sleep 60
    EOT
    environment = {
      KUBECONFIG = "${var.kube_config_path}"
    }
  }

  depends_on = [
    helm_release.cert_manager
  ]
}

resource "helm_release" "rancher" {
  count            = var.install_rancher ? 1 : 0
  name             = "rancher"
  repository       = var.helm_rancher_repo
  chart            = "rancher"
  version          = var.rancher_version
  devel            = true
  namespace        = "cattle-system"
  create_namespace = true
  values = [
    templatefile("${var.helm_rancher_chart_values_path}", {
      letsencrypt_email         = var.letsencrypt_email
      rancher_image             = var.rancher_image
      rancher_image_tag         = var.rancher_image_tag
      rancher_password          = var.rancher_password
      use_new_bootstrap         = var.use_new_bootstrap
      rancher_node_count        = var.rancher_node_count
      rancher_hostname          = "${var.subdomain}.${var.domain}"
      install_certmanager       = var.install_certmanager
      install_byo_certs         = length(var.byo_certs_bucket_path) > 0 ? true : false
      private_ca                = length(var.private_ca_file) > 0 ? true : false
      cattle_prometheus_metrics = var.cattle_prometheus_metrics
      }
    )
  ]
  depends_on = [
    null_resource.wait_for_cert_manager
  ]
}

resource "null_resource" "wait_for_rancher" {
  count = var.install_rancher ? 1 : 0
  provisioner "local-exec" {
    command = <<-EOT
    kubectl -n cattle-system rollout status deploy/rancher
    timeout --preserve-status 7m sh -c -- 'until echo "$${subject}" | grep -q "CN=${var.subdomain}.${var.domain}" || echo "$${subject}" | grep -q "CN=\*.${var.domain}" ; do
        sleep 5
        subject=$(curl -vk -m 2 "https://${var.subdomain}.${var.domain}/ping" 2>&1 | grep "subject:")
        echo "Subject: $${subject}"
    done'
    timeout --preserve-status 2m sh -c -- 'while [ "$${resp}" != "pong" ]; do
        resp=$(curl -sSk -m 2 "https://${var.subdomain}.${var.domain}/ping")
        echo "Rancher Response: $${resp}"
        if [ "$${resp}" != "pong" ]; then
          sleep 10
        fi
    done'
    EOT

    environment = {
      KUBECONFIG       = "${var.kube_config_path}"
      RANCHER_HOSTNAME = "${var.subdomain}.${var.domain}"
    }
  }

  depends_on = [
    helm_release.rancher
  ]
}

resource "rancher2_bootstrap" "admin" {
  count            = (var.install_rancher) ? 1 : 0
  initial_password = var.use_new_bootstrap ? var.rancher_password : null
  password         = var.rancher_password
  depends_on       = [null_resource.wait_for_rancher]
}
