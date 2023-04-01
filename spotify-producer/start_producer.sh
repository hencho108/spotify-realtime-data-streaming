#!/bin/bash
curl -s --max-time 1 http://169.254.169.254/latest/meta-data/instance-id 2>/dev/null >/tmp/instance_id
CURL_EXIT_CODE=$?

if [ $CURL_EXIT_CODE -eq 0 ]; then
    echo "Starting producer container on EC2 instance"
    docker run -it --network kafka_kafka-net spotify-producer
else
    echo "Starting producer container on local machine with AWS credentials mounted"
    docker run -it -v ~/.aws/credentials:/root/.aws/credentials -e AWS_PROFILE=$AWS_PROFILE spotify-producer
fi
