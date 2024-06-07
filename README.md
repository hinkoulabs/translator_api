# Translator API

This README documents the steps necessary to get the Translator API application up and running.

## Table of Contents

- [Ruby Version](#ruby-version)
- [System Dependencies](#system-dependencies)
- [Configuration](#configuration)
- [Run Application](#run-application)
- [How to Run the Test Suite](#how-to-run-the-test-suite)

## Ruby Version

- Ruby 3.2.2

## System Dependencies

- docker
- docker-compose

## Configuration

Set up environment variables by creating a `.env` file in the root directory of your project. Example:

```
RAILS_MASTER_KEY=your_rails_master_key
RAILS_ENV=development
```

## Run Application

Run the following commands to build application:

```
docker-compose build
```

Run the following commands to run application:

```
docker-compose up -d
```

Run the following commands to prepare database:

```
docker-compose exec web bin/rails db:prepare
```

The application is available on `http://0.0.0.0:3000/`

Run the following commands to stop application:

```
docker-compose down
```

## How to Run the Test Suite

Run the following commands to prepare database:

```
docker-compose exec web bin/rails test
```