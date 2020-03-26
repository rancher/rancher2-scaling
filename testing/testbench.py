import client as c
import os
import time
import random
import tests
import pathlib
import pandas

from options import Options
from collections import OrderedDict


results = {}
label_to_index = OrderedDict()


class Metric:
    def __init__(self, fn, labels):
        self.fn = fn
        self.labels = labels


class TestBench:
    def __init__(self, metrics, options):
        token = os.getenv("RANCHER_SCALING_TOKEN")
        url = os.getenv("RANCHER_SCALING_URL")
        a = c.Auth(token, url)
        client = c.Client(a)

        global results
        # Setup state
        for metric in metrics:
            for label in metric.labels:
                label_to_index[label] = len(label_to_index.keys())

        first_write = True
        last_save = time.time()
        for i in range(options.iterations):
            results[i] = [None for _ in range(len(label_to_index.keys()))]
            for metric in metrics:
                result = metric.fn(client, i)
                log_dict(result)
            time.sleep(options.pulse + random.uniform(0, options.jitter))
            if time.time() - last_save > options.save_every:
                print("results", results)
                print("saving...")
                save(results, first_write)
                results = {}
                last_save = time.time()
                first_write = False
        pandas.set_option('display.width', 200)
        current = save(results, first_write)
        print("METRICS RESULTS:")
        print(current)
        tests.run_tests(current)


def log_dict(result):
    global results
    if result is None:
        return
    row_key = result.get("row_key", None)
    if row_key is None:
        return
    del result["row_key"]
    for key in result.keys():
        col_index = label_to_index.get(key, None)
        if col_index is not None:
            results[row_key][col_index] = result[key]


def test_k8s_cluster_list(client, row_index):
    k8s_cluster_test_data = {"row_key": row_index}
    k8s_cluster_test_data.update(client.timed_list_k8s_clusters_no_resp())
    return k8s_cluster_test_data


def test_rancher_cluster_list(client, row_index):
    cluster_test_data = {"row_key": row_index}
    cluster_test_data.update(client.timed_list_rancher_clusters())
    return cluster_test_data


def test_rancher_project_list(client, row_index):
    project_test_data = {"row_key": row_index}
    project_test_data.update(client.timed_list_rancher_projects_no_resp())
    return project_test_data


def test_k8s_project_list(client, row_index):
    k8s_project_test_data = {"row_key": row_index}
    k8s_project_test_data.update(client.timed_list_k8s_projects_no_resp())
    return k8s_project_test_data


def test_rancher_crud(client, row_index):
    data = {"row_key": row_index}
    try:
        crud_times = client.timed_crud_rancher_cluster()
        data.update(crud_times)
    except Exception as e:
        print("ERROR crud", e)
    return data


def save(current, write_columns):
    df = pandas.DataFrame.from_dict(current, orient="index", columns=label_to_index.keys())
    header = write_columns
    path = str(pathlib.Path(__file__).parent.absolute()) + "/scale_test.csv"
    df.to_csv(path_or_buf=path, mode="a", header=header)
    return df


metrics = [
    Metric(test_rancher_cluster_list, ["rancher_cluster_list_time", "num_clusters"]),
    Metric(test_rancher_project_list, ["rancher_project_list_time", "num_projects"]),
    Metric(test_k8s_cluster_list, ["k8s_cluster_list_time", "num_k8s_clusters"]),
    Metric(test_k8s_project_list, ["k8s_project_list_time", "num_k8s_projects"]),
    Metric(test_rancher_crud, ["rancher_create_time", "rancher_get_time",
                               "rancher_update_time", "rancher_delete_time"])
]


def run():
    opts = Options()
    TestBench(metrics, opts)


if __name__ == "__main__":
    run()
