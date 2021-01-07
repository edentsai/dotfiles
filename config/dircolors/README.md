## dircolors Configuration

`dircolors` outputs a sequence of shell commands 
to set up the terminal via `$LS_COLORS` variable 
for color output from `ls` command (and `dir`, etc.).

> **NOTE**
>
> - `$LS_COLORS` only works on Linux or GNU coreutils.
> - On macOS, you need to install GNU coreutils.

### Installation

We can directly use `dircolors` command 
to configure `$LS_COLORS` in `.bashrc` with XDG base directory:

```shell
ln -v -s "${PWD}" "${XDG_CONFIG_HOME}/dircolors"
```

Configure `$LS_COLORS` variable in your `.bashrc`:

```shell .bashrc
if test -r "${XDG_CONFIG_HOME}/.dircolors"; then
    eval "$(dircolor --bourne-shell "${HOME}/.dircolors")"
fi
```

### References

- [dircolors: Color setup for ls](https://www.gnu.org/software/coreutils/manual/html_node/dircolors-invocation.html)
- [Nord dircolors - An arctic, north-bluish clean and elegant dircolors theme](https://github.com/arcticicestudio/nord-dircolors).
