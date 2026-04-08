# Transit Secrets Manager

This is a minimal secrets manager only used to auto-unseal the main secrets manager.

## Usage

Prerequisites:
- Have [Nix (the package manager)](https://nixos.org/download/) installed
- Enter the Nix environment: `nix --extra-experimental-features "nix-command flakes" develop`
    - If you have Nix flakes enabled globally, you can instead run `nix develop`

For initialisation, run the `./scripts/init` bash script from the root of this repo.
For local development, run it with `--no-swap` to stop it from disabling swap memory.

### Initialisation Explanation

On the machine that should run it securely, disable swap memory: `sudo swapoff -a`.
Swap needs to be disabled because if swap is enabled and the machine runs out of RAM,
then it may write the secrets manager's memory to the swap disk as plaintext.
This memory contains the secret to unseal the main secrets manager.

Run the image: `docker compose up -d --build`

For a first time run, you must start a shell in the container: `docker exec -it secrets-manager-transit sh`.
Then, you must set the `BAO_ADDR` environment variable within the container: `export BAO_ADDR=http://127.0.0.1:8200/`.
Then, you must initialise it by running `bao operator init` within the container.
Then, all the keys must be stored somewhere securely.

The manager must be unsealed by running `bao operator unseal <unseal-key>` three times with three different unseal keys.
Remember to clear the command history afterwards using `rm $HISTFILE`.

Run `tofu init`.
Then, set the `VAULT_TOKEN` environment variable to the root token and apply the manager's configuration by running `VAULT_TOKEN=<root-token> tofu apply`.
Optionally, the `token_period` variable can be set to control how long the token lasts: `-var token_period=30d`

Get the boostrap token by running: `tofu output -raw kubernetes_bootstrap_token`.

## Deletion

To delete this secrets manager, run the `./scripts/delete` bash script.

Or manually, you can find the ID of the container using `docker ps`.
Then, use `docker stop <id> && docker kill <id>`. Finally, use `docker volume rm secrets-manager-transit-data`.

