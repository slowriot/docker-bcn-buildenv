set -e
docker build --no-cache -t bitcoincashnode/buildenv:debian .
docker push bitcoincashnode/buildenv:debian
