import cleanup
import os
import pathlib
import testbench

from setup import setup
from stabalize import start
from requests import ConnectionError
from time import sleep


def set_rancher_token_url():
    tfstate = open(str(pathlib.Path(__file__).parent.absolute()) + "/../control-plane/rancher.tfstate").read()

    token = tfstate.split("\"token\": \"")[1]
    token = token.split("\",")[0]
    print("Token:", token)

    url = tfstate.split("\"url\": \"")[1]
    url = url.split("\",")[0]
    print("URL:", url)

    os.environ["RANCHER_SCALING_TOKEN"] = token
    os.environ["RANCHER_SCALING_URL"] = url
    os.environ["TF_VAR_rancher_api_url"] = url
    os.environ["TF_VAR_rancher_token_key"] = token


def run():
    setup()
    set_rancher_token_url()
    start()
    print("Will tests in 30 seconds...")
    sleep(30)
    print("Running tests...")
    testbench.run()
    cleanup.run()


for i in range(3):
    try:
        run()
        break
    except ConnectionError as e:
        continue
