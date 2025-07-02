#!/bin/bash

kubectl create ns app
kubectl -n app run app1 --image=nginx:alpine -l id=app
kubectl -n app run app2 --image=nginx:alpine -l id=app
kubectl -n app run manager1 --image=nginx:alpine -l id=manager
kubectl -n app run manager2 --image=nginx:alpine -l id=manager

kubectl create ns data
kubectl -n data run data-001 --image=nginx:alpine -l id=data
kubectl -n data run data-002 --image=nginx:alpine -l id=data
kubectl -n data run processor-a100 --image=nginx:alpine -l id=processor
kubectl -n data run processor-a200 --image=nginx:alpine -l id=processor

kubectl wait -n app --for=condition=ready pod --all --timeout 30s
kubectl wait -n data --for=condition=ready pod --all --timeout 30s

echo
echo Pods in Namespace app
kubectl -n app get pod -o wide --show-labels | sed 's/NOMINATED NODE/NOMINATED_NODE/g' | sed 's/READINESS GATES/READINESS_GATES/g' | awk '{print $1,$3,$5,$6,$10}' | column -t

echo
echo Pods in Namespace data
kubectl -n data get pod -o wide --show-labels | sed 's/NOMINATED NODE/NOMINATED_NODE/g' | sed 's/READINESS GATES/READINESS_GATES/g' | awk '{print $1,$3,$5,$6,$10}' | column -t