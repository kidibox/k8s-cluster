plan:
	terraform plan \
		-var client_id=${ARM_CLIENT_ID} \
		-var client_secret=${ARM_CLIENT_SECRET} \
		stack

apply:
	terraform apply \
		-var client_id=${ARM_CLIENT_ID} \
		-var client_secret=${ARM_CLIENT_SECRET} \
		stack
