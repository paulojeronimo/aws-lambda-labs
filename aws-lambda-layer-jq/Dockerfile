FROM amazonlinux:2 as builder
ARG layer_zip
WORKDIR /root
RUN set -e; \
    yum -y install wget zip && \
	mkdir -p /opt/bin && \
	wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -O /opt/bin/jq && \
	chmod +x /opt/bin/jq; \
	cd /opt; \
	zip -r ../$layer_zip *
