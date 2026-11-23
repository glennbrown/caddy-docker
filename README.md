# caddy-docker

A custom Caddy image that adds two modules:

* `github.com/caddy-dns/cloudflare` (DNS challenge provider)
* `github.com/caddyserver/replace-response` (response body rewriting)

Images are published to `ghcr.io/<owner>/caddy` for `linux/amd64`, `linux/arm/v6`, `linux/arm/v7`, `linux/arm64`, `linux/ppc64le` and `linux/riscv64`.

## Tags

Tags mirror the official [caddy](https://hub.docker.com/_/caddy) image: `X.Y.Z`, `X.Y`, `X` and `latest`. For example, `2.11.9`, `2.11`, `2` and `latest`. Only the default variant is published.

## How updates work

The Caddy version lives in the two `FROM` lines of the `Dockerfile`. Dependabot watches them and opens a single PR when the official image publishes a newer tag. The PR build checks that Caddy compiles with both modules. Merging the PR to `main` publishes the new tags.

Plugin versions are not pinned, so each build uses the latest release of both modules.

## Usage

```
docker run -d -p 80:80 -p 443:443 \
  -e CF_API_TOKEN=... \
  -v $PWD/Caddyfile:/etc/caddy/Caddyfile \
  ghcr.io/<owner>/caddy:latest
```

Example Caddyfile snippet using the Cloudflare DNS challenge:

```
example.com {
	tls {
		dns cloudflare {env.CF_API_TOKEN}
	}
	respond "hello"
}
```

## Verify the modules

```
docker run --rm ghcr.io/<owner>/caddy:latest caddy list-modules | grep -E 'cloudflare|replace'
```
