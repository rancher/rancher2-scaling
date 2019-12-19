import base64
import yaml
import urllib3
import requests
import time

from rancher import Client as RancherClient
from kubernetes.client.rest import ApiException
from kubernetes.client import ApiClient, Configuration, CustomObjectsApi
from kubernetes.config.kube_config import KubeConfigLoader
from common import random_str, wait_for


class Auth:
    def __init__(self, token, url="https://localhost"):
        self.url = url + "/v3"
        self.k8s_proxy_url = url + "/k8s/clusters/local/"
        self.k8s_url = url + ":6443"
        self.token = token
        self.k8s_token = token

    def set_k8s_token(self, token):
        self.k8s_token = token


class Client:
    def __init__(self, auth):
        urllib3.disable_warnings()

        self.Auth = auth
        self.rancher_client = rancher_api_client(self.Auth)

        self.k8s_client = k8s_api_client(self, "local")
        session = requests.Session()
        session.verify = False
        self.session = session

    def rancher_secrets(self):
        return self._list_rancher("k8s/clusters/local/api/v1/secrets")

    def timed_list_k8s_clusters_no_resp(self):
        return self._timed_list_k8s("clusters")

    def timed_list_k8s_projects_no_resp(self):
        return self._timed_list_k8s("projects")

    def timed_list_rancher_clusters(self):
        return self._timed_list_rancher("clusters")

    def timed_list_rancher_projects_no_resp(self):
        return self._timed_list_rancher("projects")

    def timed_crud_rancher_cluster(self):
        feature_name = "kd-" + random_str()

        create_time = self.timed_create_rancher_cluster(feature_name)

        def wait_for_kd_list():
            try:
                return self._list_rancher("kontainerdrivers")["data"]
            except ApiException:
                return None
        kds = wait_for(wait_for_kd_list)
        kd_id = None
        for kd in kds:
            if kd["name"] == feature_name:
                kd_id = kd["id"]
        if kd_id is None:
            return {}

        get_time = self._timed_get_rancher("kontainerdrivers", kd_id)
        update_time = self._timed_update_rancher("kontainerdrivers", kd_id, {"url": random_str()})
        delete_time = self._timed_delete_rancher("kontainerdrivers", kd_id)

        times = {
            "rancher_create_time": create_time,
            "rancher_get_time": get_time,
            "rancher_update_time": update_time,
            "rancher_delete_time": delete_time
        }
        return times

    def timed_create_rancher_cluster(self, name):
        return self._timed_create_rancher("kontainerdriver", body={"name": name, "url": random_str(), "type": "kontainerdriver"})

    def _timed_list_k8s(self, resource_plural):
        start = time.time()
        resp = self.k8s_client.call_api(
            '/apis/{group}/{version}/{plural}',
            "GET",
            {
                'group': 'management.cattle.io',
                'version': 'v3',
                'plural': resource_plural
            },
            header_params={
                'Accept': 'application/json',
                'Authorization': 'Bearer ' + self.Auth.token
            },
            auth_settings=['BearerToken'],
            _return_http_data_only=True,
            _preload_content=False,
        )
        if resp.status == 200:
            return time.time() - start
        else:
            return None

    # was using rancher client for this before but there appeared to be an issue with one request, no matter how many
    # were sent, not returning. Appeared to be an issue with rancher api's 'send'
    def _list_rancher(self, resource):
        """gets rancher resource"""
        resp = self.rancher_client.call_api(
            "/" + resource,
            "GET",
            header_params={
                'Accept': 'application/json',
                'Authorization': 'Bearer ' + self.Auth.token
            },
            _return_http_data_only=True,
            response_type='object'
        )
        return resp

    def _list_k8s_proxy(self, version, resource):
        client_configuration = type.__call__(Configuration)
        client_configuration.host = self.Auth.k8s_proxy_url
        client_configuration.verify_ssl = False
        rancher_client = ApiClient(configuration=client_configuration)
        resp = rancher_client.call_api(
            "api/" + version + "/" + resource,
            "GET",
            header_params={
                'Accept': 'application/json',
                'Authorization': 'Bearer ' + self.Auth.token
            },
            _return_http_data_only=True,
            response_type='object'
        )
        return resp

    def list_k8s(self, resource):
        resp = self.k8s_client.call_api(
            '/apis/{group}/{version}/{plural}',
            "GET",
            {
                'group': 'management.cattle.io',
                'version': 'v3',
                'plural': resource
            },
            header_params={
                'Accept': 'application/json',
                'Authorization': 'Bearer ' + self.Auth.k8s_token
            },
            auth_settings=['BearerToken'],
            _return_http_data_only=True,
            _preload_content=True,
            response_type='object'
        )
        return resp

    def list_proxy_secrets(self):
        return self._list_k8s_proxy("v1", "secrets")

    def create_default_sa_crb(self):
        client_configuration = type.__call__(Configuration)
        client_configuration.host = self.Auth.k8s_proxy_url
        client_configuration.verify_ssl = False
        rancher_client = ApiClient(configuration=client_configuration)
        resp = rancher_client.call_api(
            '/apis/{group}/{version}/{plural}',
            "POST",
            {
                'group': "rbac.authorization.k8s.io",
                'version': "v1beta1",
                'plural': "clusterrolebindings",
            },
            header_params={
                'Accept': 'application/json',
                'Authorization': 'Bearer ' + self.Auth.token
            },
            body={
                "metadata": {
                    "name": "crb-" + random_str()
                },
                "roleRef": {
                    "apiGroup": "rbac.authorization.k8s.io",
                    "kind": "ClusterRole",
                    "name": "cluster-admin"
                },
                "subjects": [{"kind": "ServiceAccount", "name": "default", "namespace": "default"}]
            },
            _return_http_data_only=True,
            response_type='object'
        )
        return resp

    def _timed_create_rancher(self, resource, body):
        """creates a rancher resource"""
        start = time.time()
        resp = self.rancher_client.call_api(
            "/" + resource,
            "POST",
            header_params={
                'Accept': 'application/json',
                'Authorization': 'Bearer ' + self.Auth.token
            },
            body=body,
            _return_http_data_only=True,
            _preload_content=False,
        )
        if resp.status == 201:
            return time.time() - start
        else:
            return None

    def _timed_get_rancher(self, resource, name):
        """gets rancher resource"""
        start = time.time()
        resp = self.rancher_client.call_api(
            "/" + resource + "/" + name,
            "GET",
            header_params={
                'Accept': 'application/json',
                'Authorization': 'Bearer ' + self.Auth.token
            },
            _return_http_data_only=True,
            _preload_content=False,
        )
        if resp.status == 200:
            return time.time() - start
        else:
            return None

    def _timed_update_rancher(self, resource, name, body):
        """updates rancher resource"""
        start = time.time()
        resp = self.rancher_client.call_api(
            "/" + resource + "/" + name,
            "PUT",
            header_params={
                'Accept': 'application/json',
                'Authorization': 'Bearer ' + self.Auth.token
            },
            body=body,
            _return_http_data_only=True,
            _preload_content=False,
        )
        if resp.status == 200:
            return time.time() - start
        else:
            return None

    def _timed_delete_rancher(self, resource, name):
        """deletes rancher resource"""
        start = time.time()
        resp = self.rancher_client.call_api(
            "/" + resource + "/" + name,
            "DELETE",
            header_params={
                'Accept': 'application/json',
                'Authorization': 'Bearer ' + self.Auth.token
            },
            _return_http_data_only=True,
            _preload_content=False,
        )
        if resp.status == 200:
            return time.time() - start
        else:
            return None

    def _timed_list_rancher(self, resource):
        start = time.time()
        resp = self.rancher_client.call_api(
            "/" + resource,
            "GET",
            header_params={
                'Accept': 'application/json',
                'Authorization': 'Bearer ' + self.Auth.token
            },
            _return_http_data_only=True,
            _preload_content=False,
        )
        time_elapsed = time.time() - start
        if resp.status == 200:
            return time_elapsed
        else:
            return None


# should just add this to rancher client, exists in a
# few projects using rancher client
def k8s_api_client(client, cluster_name, kube_path=None):
    rancher_client = RancherClient(
        url=client.Auth.url,
        token=client.Auth.token,
        verify=False)

    kube_path = None
    if kube_path is not None:
        kube_file = open(kube_path, "r")
        kube_config = kube_file.read()
        kube_file.close()
    else:
        cluster = rancher_client.by_id_cluster(cluster_name)
        kube_config = cluster.generateKubeconfig().config

    loader = KubeConfigLoader(config_dict=yaml.full_load(kube_config))

    client_configuration = type.__call__(Configuration)
    loader.load_and_set(client_configuration)
    client_configuration.api_key = {}
    client_configuration.verify_ssl = False
    k8s_client = ApiClient(configuration=client_configuration)
    return CustomObjectsApi(api_client=k8s_client).api_client


def real_k8s_api_client(client, cluster_name):
    secrets = client.list_proxy_secrets()
    for secret in secrets["items"]:
        if secret["metadata"]["namespace"] == "default":
            token = base64.b64decode(secret["data"]["token"]).decode("utf-8")
    print(token)
    client.Auth.set_k8s_token(token)
    client.create_default_sa_crb()

    rancher_client = RancherClient(
            url=client.Auth.url,
            token=client.Auth.token,
            verify=False)
    cluster = rancher_client.by_id_cluster(cluster_name)
    kube_config = cluster.generateKubeconfig().config

    loader = KubeConfigLoader(config_dict=yaml.full_load(kube_config))

    client_configuration = type.__call__(Configuration)
    client_configuration.host = client.Auth.k8s_url
    client_configuration.verify_ssl = False
    k8s_client = ApiClient(configuration=client_configuration)

    return CustomObjectsApi(api_client=k8s_client).api_client


# create rancher client using k8s client modules
def rancher_api_client(auth):
    client_configuration = type.__call__(Configuration)
    client_configuration.host = auth.url
    client_configuration.verify_ssl = False
    return ApiClient(configuration=client_configuration)
