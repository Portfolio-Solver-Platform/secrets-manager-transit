# Transit Secrets Manager

This is a minimal secrets manager only used to auto-unseal the main secrets manager.

## Usage

On the machine that should run it securely, disable swap memory: `sudo swapoff -a`.
Swap needs to be disabled because if swap is enabled and the machine runs out of RAM,
then it may write the secrets manager's memory to the swap disk as plaintext.
This memory contains the secret to unseal the main secrets manager.

Run the image: `docker compose up -d --build`

For a first time run, it must be initialised by running `dao operator init` within the container.
Then, all the keys must be stored somewhere securely.

The manager must be unseal by running `dao operator unseal <unseal-key>` three times with three different unseal keys.

Run `terraform init`.
Then, set the `VAULT_TOKEN` environment variable to the root token, i.e., `export VAULT_TOKEN=<root-token>`.
Apply the manager's configuration by running `terraform apply`.

