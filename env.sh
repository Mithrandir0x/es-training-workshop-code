#!/usr/bin/env bash

mkdir -p ../.data/elasticsearch

docker-compose up -d elasticsearch kibana
