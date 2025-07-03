#!/bin/bash

kubectl create ns app
kubectl -n app run app1 --image=nginx:alpine -l id=app
kubectl -n app run app2 --image=nginx:alpine -l id=app
kubectl -n app run manager1 --image=nginx:alpine -l id=manager
kubectl -n app run manager2 --image=nginx:alpine -l id=manager
kubectl -n app run controller1 --image=nginx:alpine -l id=controller
kubectl -n app run controller2 --image=nginx:alpine -l id=controller


kubectl create ns data
kubectl -n data run data-001 --image=nginx:alpine -l id=data
kubectl -n data run data-002 --image=nginx:alpine -l id=data
kubectl -n data run processor-a100 --image=nginx:alpine -l id=processor
kubectl -n data run processor-a200 --image=nginx:alpine -l id=processor

kubectl wait -n app --for=condition=ready pod --all --timeout 30s
kubectl wait -n data --for=condition=ready pod --all --timeout 30s

k expose pod -n app app1 --type=ClusterIP --port=80 --protocol=TCP --name app
k expose pod -n app manager1 --type=ClusterIP --port=80 --protocol=TCP --name manager
k expose pod -n app controller1 --type=ClusterIP --port=80 --protocol=TCP --name controller

k expose pod -n data data-001 --type=ClusterIP --port=80 --protocol=TCP --name data
k expose pod -n data processor-a100 --type=ClusterIP --port=80 --protocol=TCP --name processor
echo
echo Pods in Namespace app
kubectl -n app get pod -o wide --show-labels | sed 's/NOMINATED NODE/NOMINATED_NODE/g' | sed 's/READINESS GATES/READINESS_GATES/g' | awk '{print $1,$3,$5,$6,$10}' | column -t

echo
echo Pods in Namespace data
kubectl -n data get pod -o wide --show-labels | sed 's/NOMINATED NODE/NOMINATED_NODE/g' | sed 's/READINESS GATES/READINESS_GATES/g' | awk '{print $1,$3,$5,$6,$10}' | column -t