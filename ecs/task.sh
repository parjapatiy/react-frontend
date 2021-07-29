#!/bin/bash

aws ecs register-task-definition --family yanshul-frontend --container-definitions "[{\"name\":\"frontend\",\"image\":\"421320058418.dkr.ecr.ap-south-1.amazonaws.com/yanshul-frontend:aef7e00\",\"cpu\":200,\"memory\":200,\"essential\":true}]"
