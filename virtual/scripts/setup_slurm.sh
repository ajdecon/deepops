#!/bin/bash
set -ex

# Get absolute path for script, and convenience vars for virtual and root
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
VIRT_DIR="${SCRIPT_DIR}/.."
ROOT_DIR="${SCRIPT_DIR}/../.."

#####################################
# Configure slurm in virtual cluster 
#####################################

# Move working directory to root of DeepOps repo 
cd "${ROOT_DIR}" || exit 1

# Configure NFS for shared home directories
ansible-playbook \
	-i "${VIRT_DIR}/config/inventory" \
	-l slurm-cluster \
	-e "@${VIRT_DIR}/vars_files/nfs_homedirs.yml" \
	"${ROOT_DIR}/playbooks/nfs.yml"

# Configure Slurm cluster
ansible-playbook \
	-i "${VIRT_DIR}/config/inventory" \
	-l slurm-cluster \
	"${ROOT_DIR}/playbooks/slurm-cluster.yml"
