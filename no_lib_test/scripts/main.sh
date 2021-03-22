#!/bin/bash

CONFIGFILES=files

gcloud compute networks describe sample --format=yaml > $CONFIGFILES/vpc_actual.yaml
gcloud compute networks subnets describe --region asia-northeast1 sample --format=yaml > $CONFIGFILES/subnetwork_actual.yaml
gcloud compute firewall-rules describe ingress-sample --format=yaml > $CONFIGFILES/firewall_actual.yaml
gcloud compute instances describe --zone=asia-northeast1-b sample --format=yaml > $CONFIGFILES/instance_actual.yaml
gcloud compute disks describe --zone=asia-northeast1-b sample --format=yaml > $CONFIGFILES/disk_actual.yaml
