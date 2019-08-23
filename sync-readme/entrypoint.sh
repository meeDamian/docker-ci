#!/bin/sh -l

set -e

# Since Github doesn't seem to verify the `required` param, it has to be done here…

print_input_error() {
  >&2 printf "%s is required, and must be specified.\n" "$1"
  >&2 printf "\tNote: %s\n" "$2"
  >&2 printf "Try:\n"
  >&2 printf "\tuses: meeDamian/docker-ci/sync-readme@TAG\n"
  >&2 printf "\twith:\n"
  >&2 printf "\t  user: \${{ secrets.DOCKER_USER }}\n"
  >&2 printf "\t  pass: \${{ secrets.DOCKER_PASS }}\n"
  >&2 printf "\t  slug: \${{ github.repository }}\n"
}

if [ -z "${INPUT_USER}" ]; then
  print_input_error "Docker Hub Username" "It's the login you use to access Docker Hub."
  exit 1
fi

if [ -z "${INPUT_PASS}" ]; then
  print_input_error "Docker Hub Password" "It's the password you use to access Docker Hub."
  exit 1
fi

if [ -z "${INPUT_SLUG}" ]; then
  print_input_error "Docker Hub Slug" "It's the image name you use to pull images from Docker Hub (minus any tag)"
  exit 1
fi

echo "world | ${INPUT_USER} | ${INPUT_PASS} | ${INPUT_SLUG} | ${INPUT_README}"






#IFS=$'\n\t'
#
## Set the default path to README.md
#README_FILEPATH=${README_FILEPATH:="./README.md"}
#
## Acquire a token for the Docker Hub API
#echo "Acquiring token"
#LOGIN_PAYLOAD="{\"username\": \"${DOCKERHUB_USERNAME}\", \"password\": \"${DOCKERHUB_PASSWORD}\"}"
#TOKEN=$(curl -s -H "Content-Type: application/json" -X POST -d ${LOGIN_PAYLOAD} https://hub.docker.com/v2/users/login/ | jq -r .token)
#
## Send a PATCH request to update the description of the repository
#echo "Sending PATCH request"
#REPO_URL="https://hub.docker.com/v2/repositories/${DOCKERHUB_REPOSITORY}/"
#RESPONSE_CODE=$(curl -s --write-out %{response_code} --output /dev/null -H "Authorization: JWT ${TOKEN}" -X PATCH --data-urlencode full_description@${README_FILEPATH} ${REPO_URL})
#echo "Received response code: $RESPONSE_CODE"
#
#if [ $RESPONSE_CODE -eq 200 ]; then
#  exit 0
#else
#  exit 1
#fi
