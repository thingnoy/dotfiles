# Dotfiles

## Chezmoi

My dotfiles are managed with [Chezmoi](https://chezmoi.io).

## Usage

```shell
ASK=1 sh -c "$(curl -fsSL https://raw.githubusercontent.com/thingnoy/dotfiles/master/install.sh) -x encrypted -v"
```

First installation will ask for your name so you can customize a bit, and it will skip the encryped files, since you have to retrieve the GPG private key manually later. Removing `ASK=1` will use my names for the machine.

After the first installation you can always change the variables via `ASK=1 chezmoi init` or run `chezmoi edit-config`

To change the data or script, `chezmoi cd`, edit them, then run `chezmoi apply`.
