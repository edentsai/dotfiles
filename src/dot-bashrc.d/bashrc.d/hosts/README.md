## Bash Configurations by Hostname

### Usage

Configure Bash by hostname:

```bash
# Print the current hostname:
$ hostname
my-macbook

# Add a .bashrc configuration for the current hostname:
$ mkdir -p "$(hostname)"
$ vim "$(hostname)/editor.bashrc"
export EDITOR="vim"
```

#### Examples

```shell
# ./my-macbook/editor.bashrc
export EDITOR="vim"
```

```shell
# ./my-server-without-vim/editor.bashrc
export EDITOR="vi"
```
