import client as c
import os
import subprocess
import time

# this is the percentage of cluster that should be ready
# from a batch before continuing to the next
minimum_viable_clusters = .9

batch_size = 10


def stabalize(client):
    rancher_client = client.rancher_api_client()
    clusters = rancher_client.list_cluster()

    total_clusters = len(clusters)
    already_activate_clusters = num_active_clusters(client)
    active_clusters = 0
    start = time.time()

    # keep waiting until one of the following is true:
    # 1. its been 5 minutes since last cluster went activate
    # 2. minimum new activate clusters have been reached and its been at least 5 mins since last cluster went active
    # 3. all clusters are active

    percent = 0
    while (active_clusters - already_activate_clusters < (total_clusters - already_activate_clusters) * minimum_viable_clusters
           and time.time() - start < 300) or (time.time() - start < 180 and active_clusters != total_clusters):
        prev_active_clusters = active_clusters
        active_clusters = num_active_clusters(client)

        # goal has been reached
        if active_clusters == total_clusters:
            break
        if prev_active_clusters < active_clusters:
            # this is used to track how long its been since last cluster went activate
            start = time.time()
        time.sleep(1)
        if active_clusters/total_clusters > percent + .15:
            percent = active_clusters/total_clusters
            print("CLUSTER LOAD PROGRESS: %", percent * 100, "of", total_clusters, "ready.")
    print(active_clusters/total_clusters)


def launch_cluster(num_clusters):
    os.chdir("../clusters")
    subprocess.call("ls", shell=True)
    subprocess.call("./provision_clusters.sh " + str(num_clusters), shell=True)


def clean_nonactive_clusters(client):
    rancher_client = client.rancher_api_client()
    clusters = rancher_client.list_cluster()
    for cluster in clusters:
        if cluster.state != "active":
            print("Deleting cluster " + cluster.id)
            rancher_client.delete(cluster)


def load_clusters(client, num_clusters):
    clusters_launching = 0
    while len(client.rancher_api_client().list_cluster()) < num_clusters:
        clusters_launching += batch_size
        launch_cluster(clusters_launching)
        stabalize(client)
        clean_nonactive_clusters(client)


def num_active_clusters(client):
    rancher_client = client.rancher_api_client()

    clusters = rancher_client.list_cluster()
    active_clusters = 0
    for cluster in clusters:
        if cluster.state == "active":
            active_clusters += 1
    return active_clusters


def start():
    token = os.getenv("RANCHER_SCALING_TOKEN")
    url = os.getenv("RANCHER_SCALING_URL")
    cluster_goal = int(os.getenv("RANCHER_SCALING_GOAL", "300"))
    a = c.Auth(token, url)
    client = c.Client(a)
    load_clusters(client, cluster_goal)

