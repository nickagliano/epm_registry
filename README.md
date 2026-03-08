# epm_registry

[![CI](https://github.com/nickagliano/epm_registry/actions/workflows/ci.yml/badge.svg)](https://github.com/nickagliano/epm_registry/actions/workflows/ci.yml)

The package registry server for the [EPS](https://github.com/nickagliano/eps_mcp) ecosystem.

Packages are published and installed via the [`epm` CLI](https://github.com/nickagliano/extremely_personal_marketplace). This server provides the API and web UI that backs it.

## Stack

- Rails 8.1 + PostgreSQL
- Tailwind CSS + Hotwire/Turbo
- RSpec + FactoryBot

## API

All endpoints are under `/api/v1/`.

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/api/v1/packages` | List all packages (supports `?q=` search) |
| `GET` | `/api/v1/packages/:name` | Get a package with its versions |
| `POST` | `/api/v1/packages` | Publish a new package or version |
| `GET` | `/api/v1/packages/:name/versions/:version` | Get a specific version |
| `PATCH` | `/api/v1/packages/:name/versions/:version/yank` | Yank a version |

Publish requires an `Authorization: Bearer <token>` header when `EPM_PUBLISH_TOKEN` is set on the server.

## Development

```sh
bundle install
rails db:create db:migrate
bin/dev          # starts Rails + Tailwind watcher
```

Run tests:

```sh
bundle exec rspec
```

## Using the CLI

Install the `epm` CLI to interact with this registry:

```sh
# publish a package
epm publish --registry http://localhost:3000

# search packages
epm search todo

# install a package
epm install todo
```

See the [epm CLI repo](https://github.com/nickagliano/extremely_personal_marketplace) for full usage.

## Deployment

See [DEPLOYMENT.md](DEPLOYMENT.md) for Hetzner VPS setup instructions.
