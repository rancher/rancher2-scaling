import boto3
import os
import pathlib
import subprocess


def cleanup_ec2():
    ec2_client = boto3.client(
        'ec2',
        region_name="us-east-2",
        aws_access_key_id=os.environ["AWS_ACCESS_KEY_ID"],
        aws_secret_access_key=os.environ["AWS_SECRET_ACCESS_KEY"])

    tag_value = os.getenv("TF_VAR_cluster_name", "load-testing")
    reservations = ec2_client.describe_spot_instance_requests(
        Filters=[
            {
               "Name": "tag:RancherScaling",
               "Values": [
                   tag_value
               ]
            }])

    for sir in reservations["SpotInstanceRequests"]:
        try:
            instance_id = sir["InstanceId"]
            ec2_client.terminate_instances(
                InstanceIds=[instance_id]
            )
        except Exception as e:
            print("Failed to delete instance ", instance_id, ":", e)
        try:
            sir_id = sir["SpotInstanceRequestId"]
            ec2_client.cancel_spot_instance_requests(
                [sir_id])
        except Exception as e:
            print("Failed to delete spot request", sir_id, ":", e )


def cleanup_host():
    path = str(pathlib.Path(__file__).parent.absolute()) + "/../control-plane"
    os.chdir(path)
    subprocess.call("terraform destroy -input=false -auto-approve", shell=True)


def cleanup_states():
    clusters_state_path = str(pathlib.Path(__file__).parent.absolute()) + "/../clusters/terraform.tfstate.d"
    backup_clusters_path = str(pathlib.Path(__file__).parent.absolute()) + "/../clusters/backup_terraform.tfstate.d"
    subprocess.call("mv " + clusters_state_path + " " + backup_clusters_path, shell=True)


def run():
    cleanup = os.getenv("RANCHER_SCALING_CLEANUP", False)
    if cleanup != "true" and cleanup != "True":
        return
    print("Cleaning up resource...")
    cleanup_ec2()
    cleanup_host()
    cleanup_states()
    print("Finished cleaning up.")
