#!/bin/bash

set -euxo pipefail

# Grab the variables set in the defaults
# These must be passed in explicitly with --build-arg
# and the defined again as an
source ./defaults.env
test -e ./local.env && source ./local.env

USAGE="Usage ./build application|nginx|postgres|solr|all [-t <tag>] [-r <repository>] [-b <registry>] [-l]"

if [[ $# -eq 0 ]]; then
  echo "${USAGE}"
  exit 1
fi

image=${1}
shift || true

while getopts "t:r:b:l" opt ; do
  case ${opt} in
    t )
      t=$OPTARG
    ;;
    r )
      r=$OPTARG
    ;;
     b )
      b="${OPTARG}/"
    ;;
    l )
      l=true
    ;;
    \? )
      echo "${USAGE}"
      exit 1
    ;;
  esac
done
shift $((OPTIND -1)) || true

tag=${t:-latest}
repository=${r:-""}
with_latest=${l:-false}
build_registry=${b:-""}

BUILD_NGINX="docker build -f nginx/Dockerfile . -t primero/nginx:${tag} --build-arg NGINX_UID=${NGINX_UID} --build-arg NGINX_GID=${NGINX_GID} --build-arg BUILD_REGISTRY=${build_registry}"
BUILD_SOLR="docker build -f solr/Dockerfile ../ -t primero/solr:${tag} --build-arg BUILD_REGISTRY=${build_registry}"
BUILD_APP="docker build -f application/Dockerfile ../ -t primero/application:${tag} --build-arg APP_ROOT=${APP_ROOT} --build-arg RAILS_LOG_PATH=${RAILS_LOG_PATH} --build-arg APP_UID=${APP_UID} --build-arg APP_GID=${APP_GID} --build-arg BUILD_REGISTRY=${build_registry}"
BUILD_POSTGRES="docker build -f postgres/Dockerfile . -t primero/postgres:${tag} --build-arg BUILD_REGISTRY=${build_registry}"

apply_tags () {
  local image=${1}
  docker tag "primero/${image}:${tag}" "primero-pakistan/${image}:${tag}"
  docker tag "primero/${image}:${tag}" "primero/${image}:${tag}"
  docker tag "primero/${image}:${tag}" "primero-pakistan/${image}:${tag}"
  if [[ "${with_latest}" == true ]] ; then
    docker tag "primero/${image}:${tag}" "primero/${image}:latest"
    docker tag "primero/${image}:${tag}" "primero-pakistan/${image}:latest"
    docker tag "primero/${image}:${tag}" "primero/${image}:latest"
    docker tag "primero/${image}:${tag}" "primero-pakistan/${image}:latest"
  fi
}

# this could use getopts for building multiple containers
case ${image} in
  nginx)
    eval "${BUILD_NGINX}" && apply_tags nginx
    ;;
  solr)
    eval "${BUILD_SOLR}" && apply_tags solr
    ;;
  application)
    eval "${BUILD_APP}" && apply_tags application
    ;;
  postgres)
    eval "${BUILD_POSTGRES}" && apply_tags postgres
    ;;
  all)
    eval "${BUILD_APP}" && apply_tags application
    eval "${BUILD_SOLR}" && apply_tags solr
    eval "${BUILD_NGINX}" && apply_tags nginx
    eval "${BUILD_POSTGRES}" && apply_tags postgres
    ;;
  *)
    echo "${USAGE}"
    exit 1
  ;;
esac
