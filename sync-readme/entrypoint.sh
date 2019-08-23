#!/bin/sh -l

set -e

#
# Since Github doesn't seem to verify the `required: true` param, it has to be done here…
#

input_error() {
  >&2 printf "\nERR: Invalid input: '%s' is required, and must be specified.\n\n" "$1"
  >&2 printf "\tNote: It's the %s\n" "$2"
  >&2 printf "Try:\n"
  >&2 printf "\tuses: meeDamian/docker-ci/sync-readme@TAG\n"
  >&2 printf "\twith:\n"
  >&2 printf "\t  user: \${{ secrets.DOCKER_USER }}\n"
  >&2 printf "\t  pass: \${{ secrets.DOCKER_PASS }}\n"
  >&2 printf "\t  slug: \${{ github.repository }}\n\n"
  exit 1
}

if [ -z "${INPUT_USER}" ]; then
  input_error "user" "username used to login to Docker Hub."
fi

if [ -z "${INPUT_PASS}" ]; then
  input_error "pass" "password used to login to Docker Hub."
fi

if [ -z "${INPUT_SLUG}" ]; then
  input_error "slug" "image name used to pull images from Docker Hub (ex. meedamian/simple-qemu) "
fi

# Convert to lower case, which Docker requires
#INPUT_SLUG="${INPUT_SLUG,,}"

PAYLOAD=$(cat <<-JSON
  {
    "username": "${INPUT_USER}",
    "password": "${INPUT_PASS}"
  }
JSON
)

echo "world | ${INPUT_USER} | ${INPUT_PASS} | ${INPUT_SLUG} | ${INPUT_README}" | "${PAYLOAD}" |

exit 0




IFS=$'\n\t'

# Set the default path to README.md
README_FILEPATH=${README_FILEPATH:="./README.md"}

# Acquire a token for the Docker Hub API
echo "Acquiring token"
LOGIN_PAYLOAD="{\"username\": \"${DOCKERHUB_USERNAME}\", \"password\": \"${DOCKERHUB_PASSWORD}\"}"
TOKEN=$(curl -s -H "Content-Type: application/json" -X POST -d ${LOGIN_PAYLOAD} https://hub.docker.com/v2/users/login/ | jq -r .token)

# Send a PATCH request to update the description of the repository
echo "Sending PATCH request"
REPO_URL="https://hub.docker.com/v2/repositories/${DOCKERHUB_REPOSITORY}/"
RESPONSE_CODE=$(curl -s --write-out %{response_code} --output /dev/null -H "Authorization: JWT ${TOKEN}" -X PATCH --data-urlencode full_description@${README_FILEPATH} ${REPO_URL})
echo "Received response code: $RESPONSE_CODE"

if [ $RESPONSE_CODE -eq 200 ]; then
  exit 0
else
  exit 1
fi
