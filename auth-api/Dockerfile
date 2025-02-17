
# Phase 1: Defining build phase to compile code. 
FROM golang:1.18-alpine AS builder  

WORKDIR /app

COPY . . 

# Env variable useful to define newer module system tha was implemented on Go 1.11.

ENV GO111MODULE=on

# Download dependencies and compile application process. 

RUN go mod init github.com/bortizf/microservice-app-example/tree/master/auth-api && \
    go mod tidy &&\
    go build -o auth-api .

# Phase 2: Image for runtime

FROM alpine:latest

# DevSecOps practice: Avoid the use of root user on container by adding other user with limited permissions.

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# From phase 1 we copy the compiled file and then execute it (Remenber the alias "builder" assign in phase 1). 

COPY --from=builder /app/auth-api .

RUN chown appuser:appgroup /app/auth-api

# Must specify appuser to avoid the use of root user.

USER appuser

CMD ["./auth-api"]



