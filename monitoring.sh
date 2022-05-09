#!/usr/bin/env bash
set -ox pipefail

AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
AWS_REGION=eu-central-1

export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
export AWS_DEFAULT_REGION=${AWS_REGION}

SKATES_TARGET_URL=https://www.skates.ro/trotinete-freestyle

function test_aws_connection() {
    aws s3 ls
}

function profile_skates_category() {
    start_time=$(date +%s%N | cut -b1-13)
    curl -v ${SKATES_TARGET_URL}
    end_time=$(date +%s%N | cut -b1-13)

    resp_time=$((end_time-start_time))
    echo "Response time ${resp_time} ms"

    read -r -d '' data_body << EOF
[{
    "MetricName": "category_page_internet",
    "Dimensions": [
      {
        "Name": "url",
        "Value": "${SKATES_TARGET_URL}"
      }
    ],
    "Value": ${resp_time},
    "Unit": "Milliseconds",
    "StorageResolution": 60
}]
EOF

    aws cloudwatch put-metric-data \
        --namespace Skates.ro \
        --metric-data "${data_body}"
}

test_aws_connection
profile_skates_category