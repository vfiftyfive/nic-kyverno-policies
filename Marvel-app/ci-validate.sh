#!/usr/bin/env bash

dev_dir="/Users/nvermande/Documents/Dev/Ondat/CFD/app_manifests/overlay/dev"
prod_dir="/Users/nvermande/Documents/Dev/Ondat/CFD/app_manifests/overlay/prod"
policy_dev_dir="$HOME/Documents/Dev/kyverno/Marvel-app/dev"
policy_prod_dir="$HOME/Documents/Dev/kyverno/Marvel-app/prod"

if [[ ${1} == "dev" ]]; then
    computed_dir=${dev_dir}
    computed_policy_dir=${policy_dev_dir}
    elif [[ ${1} == "prod" ]]; then
    computed_dir=${prod_dir}
    computed_policy_dir=${policy_prod_dir}
    else 
    echo "Usage: ./ci-validate.sh <dev|prod>"
    exit 1
fi

res=$(kustomize build "${computed_dir}" | kubectl kyverno apply "${computed_policy_dir}" --resource - | tail -n+5 | cut -f 4 -d "," | cut -d ":" -f 2 | cut -d " " -f 2)

if [[ ${res} == "0" ]]; then
    echo "Passed"
else
    echo "Failed"
fi