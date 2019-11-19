SOURCE_REPO_URL=$ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/$SOURCE_REPO_NAME
DEST_REPO_URL=$ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/$DEST_REPO_NAME

echo "Logging into ECR..."
$(aws ecr get-login --no-include-email)

# scan source repo and pull out all image tags
image_tags=$(aws ecr list-images --repository-name $SOURCE_REPO_NAME --max-items 1000 --query 'imageIds[*].imageTag' | jq -r '.[]')
semver_regex="^([0-9]+)\.([0-9]+)\.([0-9]+)$"

for i in ${image_tags}
do
  # only migrate images with correct semantic versions i.e. only those created from the master branch
  if [[ ${i} =~ ${semver_regex} ]]; then
    echo "Pulling $SOURCE_REPO_URL:$i"
    docker pull $SOURCE_REPO_URL:$i
    echo "Retagging..."
    docker tag $SOURCE_REPO_URL:$i $DEST_REPO_URL:$i
    echo "Pushing $DEST_REPO_URL:$i"
    docker push $DEST_REPO_URL:$i
    # delete the local image
    echo "Deleting local images.."
    docker rmi $SOURCE_REPO_URL:$i $DEST_REPO_URL:$i
  fi
done
