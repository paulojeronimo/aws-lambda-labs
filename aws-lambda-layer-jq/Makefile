ROOT ?= $(shell pwd)
AWS_ACCOUNT_ID := $(shell aws sts get-caller-identity --query 'Account' --output text)
LAYER_NAME ?= jq-layer
LAYER_DESC ?= jq-layer
LAYER_ZIP ?= build/layer.zip
LAYER_VERSION_ARN ?= build/layer-version-arn
S3BUCKET ?= paulojeronimo-lambda-layer-1
LAMBDA_REGION ?= us-east-1
LAMBDA_FUNC_NAME ?= $(LAYER_NAME)-test-func
LAMBDA_FUNC_DESC ?= $(LAYER_NAME)-test-func
LAMBDA_ROLE_NAME ?= lambda-role
LAMBDA_ROLE_ARN ?= arn:aws:iam::$(AWS_ACCOUNT_ID):role/$(LAMBDA_ROLE_NAME)
AWS_PROFILE ?= default
PAYLOAD ?= {"instanceId":"i-12345"}

ifeq ($(shell test -e envfile && echo -n yes),yes)
	EXTRA_DOCKER_ARGS = --env-file envfile
endif

.DEFAULT_GOAL := layer-build

.PHONY: create-build-dir \
	layer-zip-exists-or-exit layer-build layer-upload layer-publish layer-all \
	func-zip create-func update-func delete-func invoke \
	add-layer-version-permission \
	clean clean-all

create-build-dir:
	@mkdir -p build

layer-zip-exists-or-exit:
	@if ! [ -f $(LAYER_ZIP) ]; then echo "File \"$(LAYER_ZIP)\" does not exists!"; exit 1; fi

layer-build: create-build-dir
	@bash build.sh $(LAYER_NAME)

layer-upload: layer-zip-exists-or-exit
	aws s3 cp $(LAYER_ZIP) s3://$(S3BUCKET)/$(LAYER_NAME).zip \
		--profile=$(AWS_PROFILE)

layer-publish:
	aws lambda publish-layer-version \
		--profile=$(AWS_PROFILE) \
		--region $(LAMBDA_REGION) \
		--layer-name $(LAYER_NAME) \
		--description $(LAYER_DESC) \
		--license-info "MIT" \
		--content S3Bucket=$(S3BUCKET),S3Key=$(LAYER_NAME).zip \
		--compatible-runtimes provided | \
	jq -r '.LayerVersionArn' > $(LAYER_VERSION_ARN)

layer-all: layer-build layer-upload layer-publish

create-func-role:
	aws iam create-role \
    	--role-name $(LAMBDA_ROLE_NAME) \
    	--assume-role-policy-document file://trust-policy.json
	aws iam attach-role-policy \
    	--role-name $(LAMBDA_ROLE_NAME) \
    	--policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

delete-func-role:
	aws iam detach-role-policy \
    	--role-name $(LAMBDA_ROLE_NAME) \
    	--policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
	aws iam delete-role \
    	--role-name $(LAMBDA_ROLE_NAME)

func-zip: create-build-dir
	rm -rf build/lambda-bundle; mkdir build/lambda-bundle
	[ -f build/main.sh ] || cp main.sample.sh build/main.sh
	cp build/main.sh bootstrap build/lambda-bundle
	cd build/lambda-bundle && \
	zip -r ../func-bundle.zip *; ls -alh ../func-bundle.zip

create-func: func-zip
	@if ! [ -f $(LAYER_VERSION_ARN) ]; then echo "File \"$(LAYER_VERSION_ARN)\" not found!"; exit 1; fi
	$(eval LAMBDA_LAYERS := $(shell cat $(LAYER_VERSION_ARN)))
	aws lambda create-function \
		--profile=$(AWS_PROFILE) \
		--region $(LAMBDA_REGION)  \
		--function-name $(LAMBDA_FUNC_NAME) \
		--description $(LAMBDA_FUNC_DESC) \
		--runtime provided \
		--role $(LAMBDA_ROLE_ARN) \
		--timeout 30 \
		--memory-size 512 \
		--layers $(LAMBDA_LAYERS) \
		--handler main \
		--zip-file fileb://build/func-bundle.zip

update-func: func-zip
	aws lambda update-function-code \
		--profile=$(AWS_PROFILE) \
		--region $(LAMBDA_REGION) \
		--function-name $(LAMBDA_FUNC_NAME) \
		--zip-file fileb://build/func-bundle.zip

delete-func:
	aws lambda delete-function \
		--profile=$(AWS_PROFILE) \
		--region $(LAMBDA_REGION) \
		--function-name $(LAMBDA_FUNC_NAME)

invoke: create-build-dir
	aws lambda invoke \
		--profile=$(AWS_PROFILE) \
		--region $(LAMBDA_REGION) \
		--function-name $(LAMBDA_FUNC_NAME)  \
		--payload '$(PAYLOAD)' \
		--cli-binary-format raw-in-base64-out \
		--log-type Tail \
	 	build/lambda-output | \
	jq -r .LogResult | \
	base64 -D

add-layer-version-permission:
	aws lambda add-layer-version-permission \
		--profile=$(AWS_PROFILE)\
		--region $(LAMBDA_REGION) \
		--layer-name $(LAYER_NAME) \
		--version-number $(LAYER_VER) \
		--statement-id public-all \
		--action lambda:GetLayerVersion \
		--principal '*'

clean:
	rm -rf build

clean-all: clean delete-func delete-func-role
