# Getting started

Create a named volume to persist CA certificates.

```
$ docker volume create local.dev
```

Start the Docker image with a custom local IP.

```
$ docker run -p "127.100.100.100:80:80" -p "127.100.100.100:443:443" -v /var/run/docker.sock:/var/run/docker.sock -v local.dev:/run/secrets katoni/local.dev
```

Download Root CA from container:

```
$ docker cp local.dev:/run/secrets/root_ca.crt .
```

Install the Root CA into your Trusted Root Certification Authorities store.

## Setup development projects

Add e.g. `--label local.dev.domains=whoami.local` option to your Docker containers.

Remember to update your hosts file. Example:

```
127.100.100.100 whoami.local
```

Alternative, you can add the label with Docker Compose:

```
version: "3.7"
services:
  whoami:
    image: containous/whoami
    labels:
      - "local.dev.domains=whoami.local"
```

Open https://whoami.local/ in your browser.
