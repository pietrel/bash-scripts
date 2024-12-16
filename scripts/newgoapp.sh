#!/bin/bash

COMMAND=$1
APP_NAME=${2,,}

PATHS=(
  "config"
  "data"
  "domain"
  "router"
  "router/http"
  "utils"
)

declare -A FILES=(
  [$APP_NAME".go"]="package main"
  ["Dockerfile"]="FROM golang:1.23-alpine AS build"
  ["Makefile"]=".PHONY: build run\nbuild:\n\tgo build -o $APP_NAME\nrun:\n\tgo run ."
  ["go.mod"]="module $APP_NAME"
  ["config/config.go"]="package config"
  ["router/http/router.go"]="package router"
  ["utils/env.go"]="package env"
)

create_structure() {
  app_name=$1; shift
  local paths=("$@")

  for path in "${paths[@]}"; do
    mkdir -p "$app_name/$path"
    echo "Created folder: $path"
  done
}

create_files() {
  app_name=$1; shift
  declare -n files=$1

  for file in "${!files[@]}"; do
    echo -e "${files[$file]}" > "$app_name/$file"
    echo "Created file: $file"
  done
}

if [ "$#" -lt 2 ]; then
  echo "Usage error"
  exit 1
fi

case $COMMAND in
  create)
    create_structure $APP_NAME "${PATHS[@]}"
    create_files $APP_NAME FILES
    ;;
  *)
    echo "Usage: $0 {create <app_name>}"
    ;;
esac
