import os
import sys
import requests
import subprocess


def download_terraform():
    os.chdir("../control-plane")
    url = "https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_" + sys.platform + "_amd64.zip"
    requests.get(url)
    subprocess.call("unzip terraform.zip", shell=True)
    subprocess.call("mv terraform /usr/local/bin", shell=True)


def setup_host():
    subprocess.call("terraform init", shell=True)
    subprocess.call("terraform apply -input=false -auto-approve", shell=True)
    subprocess.call("cat rancher.tfstate", shell=True)


def setup():
    download_terraform()
    setup_host()

