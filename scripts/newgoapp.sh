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
  [$APP_NAME".go"]="package main\nfunc main() {\n}"
  ["Dockerfile"]="FROM golang:1.23-alpine AS build"
  ["Makefile"]=".PHONY: build run\nbuild:\n\tgo build -o $APP_NAME\nrun:\n\tgo run ."
  ["go.mod"]="module $APP_NAME"
  ["config/config.go"]="package config\n\nimport (env \"server/utils\")\ntype Config struct {\nEnvironment string\nPort string\nDatabase *Database\n}\ntype Database struct {\nHost     string\nPort     string\nUser     string\nDB       string\nPassword string\n}\nfunc NewConfig() (*Config, error) {\nenv.CheckDotEnv()\nport := env.MustGet(\"PORT\")\nif port == \"\" {\nport = \"3000\"\n\n	}\n	return &Config{\n		Environment: env.MustGet(\"ENV\"),\n		Port:        port,\n		Database: &Database{\n			Host:     env.MustGet(\"DATABASE_HOST\"),\n			Port:     env.MustGet(\"DATABASE_PORT\"),\n			User:     env.MustGet(\"DATABASE_USER\"),\n			DB:       env.MustGet(\"DATABASE_DB\"),\n			Password: env.MustGet(\"DATABASE_PASSWORD\"),\n		},\n	}, nil\n}"
  ["router/http/handler.go"]="package router"
 ["utils/env.go"]="package env\nimport (\n\"github.com/joho/godotenv\"\n\"log\"\n\"os\"\n)\nconst (\nlocal      = \"local\"\nstaging    = \"staging\"\nproduction = \"production\"\nenv        = \"ENV\")\nfunc MustGet(key string) string {\nval := os.Getenv(key)\nif val == \"\" && key != \"PORT\" {panic(\"Env key missing \" + key)}\nreturn val}\nfunc CheckDotEnv() {\nerr := godotenv.Load()\nif err != nil && os.Getenv(env) == local {log.Println(\"Error loading .env file\")}}"
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
    gofmt -w $APP_NAME
    cd $APP_NAME && go mod tidy
    ;;
  *)
    echo "Usage: $0 {create <app_name>}"
    ;;
esac
