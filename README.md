## About 

A custom [gcloud sdk](https://cloud.google.com/sdk?hl=en) image with additional plugins.

### Wait... but why?

Because I prefer to have such things run in a container, rather than installing them locally on my machine.

But while google provides a [docker image for gcloud sdk](https://cloud.google.com/sdk/docs/downloads-docker), the default images lack some additional plugins that I use daily.

Thankfully, it's quite easy to [install additional components](https://cloud.google.com/sdk/docs/downloads-docker#installing_additional_components).

## Usage

I have a bash `gcloud` alias defined in my dotfiles:

```bash
➜ which gcloud
alias gcloud="docker run --rm -ti -u `id -u`:`id -g` -v /etc/passwd:/etc/passwd -v $HOME/.config/gcloud:$HOME/.config/gcloud -v $HOME/.kube:$HOME/.kube serpro69/google-cloud-cli gcloud"
```

Which I can then use as a normal `gcloud` executable, e.g.: `gcloud config set project visit20-e2e-poc`

## Build

```bash
docker build -t gcloud-cli .
```

## Publish

```bash
docker tag gcloud-cli serpro69/google-cloud-cli
docker push serpro69/google-cloud-cli
```

