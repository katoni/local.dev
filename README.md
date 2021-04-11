# Getting started

Create a named volume to persist certificates:

```
$ docker volume create local.dev
```

Start the Docker image with a custom local IP:

```
$ docker run -p "80:80" -p "443:443" -v /var/run/docker.sock:/var/run/docker.sock -v local.dev:/run/secrets katoni/local.dev
```

**Note**: You can use a custom IP with `-p "127.100.100.100:80:80" -p "127.100.100.100:443:443"`.

Download Root CA from container:

```
$ docker cp local.dev:/run/secrets/root_ca.crt .
```

Install the Root CA into your Trusted Root Certification Authorities store.

## Setup development projects

In this example we setup a whoami container using Docker Compose.

```
version: "3.7"
services:
  whoami:
    image: containous/whoami
    labels:
      - "local.dev.enable=true"
      - "traefik.http.routers.whoami.rule=Host(`whoami.local`)"
    networks:
      - default
      - local.dev

networks:
  local.dev:
    external:
      name: local.dev
```

Add an entry to your hosts file:

```
127.0.0.1 whoami.local
```

Open https://whoami.local/ in your browser.

# Customization

## Constraints

You can use e.g. namespace based constraints by running the **local.dev** container with environment variables:
```
docker run ... -e LOCALDEV_CONSTRAINTS_LABEL_KEY=local.dev.namespace -e LOCALDEV_CONSTRAINTS_LABEL_VALUE=my-project katoni/local.dev
```

Only Docker containers with `--label=local.dev.namespace=my-project` will be discovered.

**Note**: Constraints lets you can run multiple **local.dev** instances with different IP bindings and network.

# Dashboard

You can access the underlaying Traefik dashboard if you add `127.0.0.1 traefik.local.dev` to your hosts file.

Default dashboard URL: https://traefik.local.dev/dashboard/.

# Reference

| Environment variable             | Default          |
|----------------------------------|------------------|
| LOCALDEV_DOMAIN                  | local.dev        |
| LOCALDEV_NETWORK                 | local.dev        |
| LOCALDEV_CONSTRAINTS_LABEL_KEY   | local.dev.enable |
| LOCALDEV_CONSTRAINTS_LABEL_VALUE | true             |
