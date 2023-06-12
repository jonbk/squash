generate-keys:
	openssl genrsa -out $(PWD)/data/trusted_key.pem 4096 && openssl rsa -pubout -in $(PWD)/data/trusted_key.pem -out $(PWD)/data/trusted_key.pub

generate-jwt:
	docker run --rm -it -w /app -v $(PWD)/data/trusted_key.pem:/app/trusted_key.pem squashtest/squash-orchestrator:4.1.0 opentf-ctl generate token using trusted_key.pem

fedora:
	docker run --rm -it fedora:38 bash