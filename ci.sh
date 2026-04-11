#!/bin/sh

SA=https://review.sourcearcade.org
JOBS=3 # per gnatprove instance

set -e

[ $# -ne 2 ] && { echo "Usage: $0 <project> <change-ref>"; exit 1; }

PROJECT="$1"
CHANGE="$2"

echo ${PROJECT}: ${CHANGE}

[ -d "${PROJECT}" ] || git clone "${SA}/${PROJECT}.git"

cd "${PROJECT}"
git fetch origin "${CHANGE}"
git checkout FETCH_HEAD
exec make -kj$(($(nproc)/JOBS/2)) jobs=${JOBS} proof-allconfigs
