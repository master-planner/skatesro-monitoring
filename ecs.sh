#!/usr/bin/env bash

# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/using-service-linked-roles.html

read -r -d '' data_body << EOF
[
    {
        "Id": "Id841d13a4-33ad-45ca-bf30-bab64fa85cb3",
        "Arn": "arn:aws:ecs:eu-central-1:100312914570:cluster/test-ecs-cluster-2",
        "RoleArn": "arn:aws:iam::100312914570:role/service-role/Amazon_EventBridge_Invoke_ECS_test-ecs-cluster-2",
        "EcsParameters": {
            "TaskDefinitionArn": "arn:aws:ecs:eu-central-1:100312914570:task-definition/test-hello-world",
            "TaskCount": 1,
            "NetworkConfiguration": {
                "awsvpcConfiguration": {
                    "Subnets": [
                        "subnet-0aefc2ed55757fb4f",
                        "subnet-008880cac8c6e6fc3"
                    ],
                    "SecurityGroups": [],
                    "AssignPublicIp": "ENABLED"
                }
            },
            "CapacityProviderStrategy": [],
            "EnableECSManagedTags": true,
            "EnableExecuteCommand": false,
            "PlacementConstraints": [],
            "PlacementStrategy": [],
            "Tags": []
        }
    }
]
EOF

awsv2 events list-targets-by-rule --region eu-central-1 --rule test-ecs-hello-world
awsv2 events put-targets --rule test-ecs-hello-world --targets "${data_body}"