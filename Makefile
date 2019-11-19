GIT_REPO=nirdosh17/ecr_image_migrate_codebuild

create-codebuild:
	aws cloudformation create-stack --stack-name ecr-migrate-codebuild --template-body file://codebuild.yaml $(MAKE_ARGS) --capabilities CAPABILITY_NAMED_IAM --parameters $(CODEBUILD_ARGS)
update-codebuild:
	aws cloudformation update-stack --stack-name ecr-migrate-codebuild --template-body file://codebuild.yaml $(MAKE_ARGS) --capabilities CAPABILITY_NAMED_IAM --parameters $(CODEBUILD_ARGS)

CODEBUILD_ARGS=ParameterKey=GitRepo,ParameterValue=$(GIT_REPO)
