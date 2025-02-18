#!/bin/bash

# Set environment variables

#AUTH-API
export JWT_SECRET="PRFT"
export AUTH_API_PORT="8000"

#USER-API
export USERS_API_ADDRESS="http://users-api:8083"
export USERS_API_PORT="8083"

#PYTHON-LOG
export REDIS_HOST="redis" 
export REDIS_PORT="6379" 
export REDIS_CHANNEL="log_channel" 
export TODO_API_PORT="8082"
export FRONTEND_PORT="8080"
