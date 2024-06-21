## About 

A custom [gcloud sdk](https://cloud.google.com/sdk?hl=en) image with additional plugins.

### Wait... but why?

Because I prefer to have such things run in a container, rather than installing them locally on my machine.

But while google provides a [docker image for gcloud sdk](https://cloud.google.com/sdk/docs/downloads-docker), the default images lack some additional plugins that I use daily.

Thankfully, it's quite easy to [install additional components](https://cloud.google.com/sdk/docs/downloads-docker#installing_additional_components).

## Usage

I have a bash `gcloud_wrapper` function [defined in my dotfiles](https://github.com/serpro69/dotfiles/blob/764fc9f63527dfc8dcf5dd47ffdfebd9cf907158/extra#L16):

```bash
➜ which gcloud_wrapper
gcloud_wrapper () {
        local docker_cmd=("docker" "run" "--rm" "-ti" "-u" "$(id -u):$(id -g)" "-v" "/etc/passwd:/etc/passwd" "-v" "${HOME}/.config/gcloud:${HOME}/.config/gcloud" "-v" "${HOME}/.kube:${HOME}/.kube" "-v" "$(pwd):${HOME}/workdir" "-w" "${HOME}/workdir")
        local image_name="serpro69/google-cloud-cli"
        local bash_mode=false
        local args=()
        print_usage () {
                echo "Usage: gcloud_wrapper [--bash-exec] [--mount-docker] [gcloud_command [args...]]"
                echo ""
                echo "Options:"
                echo "  --bash-exec    Start an interactive bash shell inside the Docker container."
                echo "  --mount-docker Mount Docker configuration directory (\$HOME/.docker) inside the container."
                echo ""
                echo "Description:"
                echo "  This function facilitates running Google Cloud CLI commands inside a Docker container"
                echo "  using the 'serpro69/google-cloud-cli' image. It ensures necessary configurations"
                echo "  are mounted and sets a working directory inside the container. By default, it runs"
                echo "  'gcloud' commands; with '--bash-exec', it starts an interactive bash session inside"
                echo "  the container."
                echo ""
                echo "Docker Mounts:"
                echo "  - /etc/passwd:/etc/passwd                       Host's passwd file is mounted to the container."
                echo "  - \$HOME/.config/gcloud:\$HOME/.config/gcloud   Mounts gcloud configuration directory."
                echo "  - \$HOME/.kube:\$HOME/.kube                     Mounts kube configuration directory."
                echo "  - \$(pwd):\${HOME}/workdir                      Mounts current directory on host to container's workdir."
                echo ""
                echo "  - \$HOME/.docker:\${HOME}/.docker               Mounts docker configuration directory (requires '--mount-docker' option)."
                echo ""
                echo "Examples:"
                echo "  gcloud_wrapper --mount-docker auth configure-docker europe-north1-docker.pkg.dev"
                echo "    - configure docker authentication with gcloud helper"
                echo "      (see also: https://cloud.google.com/artifact-registry/docs/docker/authentication#gcloud-helper )"
                echo ""
                echo "  gcloud_wrapper --mount-docker compute instances list"
                echo "    - Runs 'gcloud compute instances list' inside the Docker container."
                echo ""
                echo "  gcloud_wrapper --bash-exec"
                echo "    - Starts an interactive bash session inside the Docker container."
                echo ""
        }
        while [[ $# -gt 0 ]]
        do
                case "$1" in
                        (--bash-exec) bash_mode=true
                                shift ;;
                        (--mount-docker) docker_cmd+=("-v" "${HOME}/.docker:${HOME}/.docker")
                                shift ;;
                        (-hh | --help-msg) print_usage
                                return 0 ;;
                        (*) args+=("$1")
                                shift ;;
                esac
        done
        if $bash_mode
        then
                "${docker_cmd[@]}" "${image_name}" "/bin/bash"
        else
                "${docker_cmd[@]}" "${image_name}" "gcloud" "${args[@]}"
        fi
}
```

I also have a simple "wrapper" shell script:

```bash
➜ cat ~/.local/bin/gcloud
#!/usr/bin/env bash

source ${HOME}/dotfiles/extra

gcloud_wrapper "$@"
```

Which I can then use as a normal `gcloud` executable, e.g.: `gcloud config set project visit20-e2e-poc`

> [!NOTE]
> I use a bash script wrapper instead of calling the function directly because some tools require `gcloud` executable to be on the `PATH`,
> e.g. [docker credential helpers](https://cloud.google.com/artifact-registry/docs/docker/authentication#gcloud-helper)

I also have a `gcloud-init` function that helps me set things up on first run:

```bash
➜ which gcloud-init
gcloud-init () {
        if [ ! -d "$HOME/.config/gcloud" ]
        then
                mkdir -p "$HOME/.config/gcloud"
        fi
        if [[ "$*" == *"--help"* ]]
        then
                echo "Initialize gcloud to be used via docker"
                return 0
        fi
        docker run --rm -ti -u $(id -u):$(id -g) -v /etc/passwd:/etc/passwd -v $HOME/.config/gcloud:$HOME/.config/gcloud serpro69/google-cloud-cli gcloud init
}
```

## Build and Publish

- `make build`
- `make publish`

> [!NOTE]
> Run `make help` to see all available commands

