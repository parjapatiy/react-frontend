#!/bin/bash

aws ecs register-task-definition --family yanshul-frontend --cli-input-json file://defination.json
