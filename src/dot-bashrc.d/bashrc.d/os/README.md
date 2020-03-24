## Bash Configurations by Operating System

### Usage

Configure Bash by OS name:

```bash
# Print the current OS name:
$ uname -s
Linux

# Add a .bashrc configuration for the OS name:
$ mkdir -p "$(uname -s)"
$ vim "$(uname -s)/editor.bashrc
export EDITOR="vim"
```

#### Examples:

```shell
# ./Darwin/editor.bashrc on MacOS (Darwin)
export EDITOR="subl"
```

```shell
# ./Linux/editor.bashrc on Linux
export EDITOR="vim"
```

```shell
# ./FreeBSD/editor.bashrc on FreeBSD
export EDITOR="vim"
```
