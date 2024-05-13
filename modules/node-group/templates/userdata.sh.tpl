#!/usr/bin/env bash
set -euf -o pipefail
# Bootstrap and join the cluster
/etc/eks/bootstrap.sh \
    ${bootstrap_extra_args} \
    --kubelet-extra-args "${kubelet_extra_args}" \
    '${cluster_name}'
