#!/bin/bash

# Downstream container images may append to this file to apply additional initialization steps
# These steps will be run one time on first startup of the container, after all other steps
#
#   Dockerfile example:
#     COPY ./my-init.sh /scripts/my-init.sh
#     RUN echo "/scripts/my-init.sh" >> /scripts/additional-init.sh
