import os
import sys
import requests
import subprocess

from common import wait_for


def download_terraform():
    os.chdir("../control-plane")
    url = "https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_" + sys.platform + "_amd64.zip"
    requests.get(url)
    subprocess.call("unzip terraform.zip", shell=True)
    subprocess.call("mv terraform /usr/local/bin", shell=True)


def setup_host():
    subprocess.call("terraform init", shell=True)
    try:
        subprocess.check_output("terraform apply -input=false -auto-approve", shell=True)
    except subprocess.CalledProcessError as e:
        if "[ERROR] Updating Admin token:" in e.stdout:
            print("Admin token not available yet...")
            return False
    subprocess.call("cat rancher.tfstate", shell=True)
    return True


def setup():
    download_terraform()
    print("Attempting to setup rancher host... May take a while due to spot instance  availability...")
    wait_for(setup_host)

