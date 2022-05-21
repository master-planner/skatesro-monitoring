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
    curl -v ${SKATES_TARGET_URL} --output - \
        -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:100.0) Gecko/20100101 Firefox/100.0' \
        -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' \
        -H 'Accept-Language: ro-RO,ro;q=0.8,en-US;q=0.6,en-GB;q=0.4,en;q=0.2' \
        -H 'Accept-Encoding: gzip, deflate, br' \
        -H 'Connection: keep-alive' \
        -H 'Cookie: _ga=GA1.2.606076161.1547895509; __atuvc=0%7C48%2C0%7C49%2C0%7C50%2C8%7C51%2C2%7C5; cto_bundle=OZNvTV9sUzBQUjhMZ1hlMjFGeHp3YlVGNUlrRmdWTWs1TmtVTiUyQkMwNSUyRkFkVnVHJTJCbk5DdVI1UGN5bFp4b1RtY210OGNvVzlsVGtuNlN1d2Y3byUyRm9pVkVnbzhZdW8lMkJaUUtRJTJCakdPTVpwJTJCdDhteW1CWXRwUmJvQ3RkMkRoMTlLZ0k0RDdCRG0lMkJEaEhIZnZzZjIzdkdFcmI5ZFFnQnR2UEd3RHNwbTBMM3RUSTA5TncwJTNE; _ga_LHC7DHD1DZ=GS1.1.1627044493.1.1.1627045142.0' \
        -H 'Upgrade-Insecure-Requests: 1' \
        -H 'Sec-Fetch-Dest: document' \
        -H 'Sec-Fetch-Mode: navigate' \
        -H 'Sec-Fetch-Site: none' \
        -H 'Sec-Fetch-User: ?1' \
        --connection-timeout 10
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