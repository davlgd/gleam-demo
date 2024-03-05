# Gleam demo on Clever Cloud

This is a simple demo of how to deploy a Gleam application on Clever Cloud after [v1.0.0 release](https://gleam.run/news/gleam-version-1/), without the need of a Docker container. You'll need a [Clever Cloud account](https://console.clever-cloud.com/) and [Clever Tools](https://github.com/CleverCloud/clever-tools).

## Setup Clever Tools

```bash
npm i -g clever-tools
clever login
```

## Init the project

Here you need [Gleam (and Erlang)](https://gleam.run/getting-started/installing/) on your local machine:

```bash
gleam new demo_gleam
cd demo_gleam
gleam add mist gleam_http gleam_erlang
```

## Prepare your application for deployment

We rely on Elixir runtime on Clever Cloud, as it includes Erlang. You'll see some warning, as it expects some Elixir stuff, but the deployment will be fine. We only need to provide some instructions to get Gleam and launch it:

```bash
clever create -t elixir
clever env set CC_PRE_BUILD_HOOK "./get_deps.sh"
clever env set CC_RUN_COMMAND "./gleam run"
```

Create the `get_deps.sh` script or get it from this repository:

```bash
#!/bin/bash

GLEAM_VER="${GLEAM_VERSION:-1.0.0}"
GLEAM_FILE="gleam-v${GLEAM_VER}-x86_64-unknown-linux-musl.tar.gz"
GLEAM_URL="https://github.com/gleam-lang/gleam/releases/download/v${GLEAM_VER}/${GLEAM_FILE}"

# Download and extract gleam
wget -q ${GLEAM_URL}
tar -xzf ${GLEAM_FILE}
rm ${GLEAM_FILE}

# If you want to update dependencies, uncomment the following line:
# ./gleam update

# Build the project
./gleam build
```

Make the script executable:

```bash
chmod +x get_deps.sh
```

## Develop your application

Edit the `src/demo_gleam.gleam` file or get it from this repository. Here we'll use [the example](https://gleam.run/deployment/fly/) provided for Cloud deployment by Gleam:

```gleam
import mist
import gleam/erlang/process
import gleam/bytes_builder
import gleam/http/response.{Response}

pub fn main() {
  let assert Ok(_) =
    web_service
    |> mist.new
    |> mist.port(8080)
    |> mist.start_http
  process.sleep_forever()
}

fn web_service(_request) {
  let body = bytes_builder.from_string("Hello, Joe!")
  Response(200, [], mist.Bytes(body))
}
```

## Alternative solution: just clone this repository

If you want to go faster, you can skip previous steps, clone this repository and create a Clever Cloud application:

```bash
git clone https://github.com/davlgd/gleam-demo
cd gleam-demo
clever create -t elixir
clever env import < .env
```

## Git push!

```bash
git add . && git commit -m "Init"
clever deploy
clever open
```

You'll see the `Hello, Joe!` message in your browser. To use cURL, get the application URL with `clever domain`):

```bash
curl $(clever domain)
```
