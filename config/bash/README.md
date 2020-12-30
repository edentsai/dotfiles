## Bash Configurations

### Installation

Bash doesn't support XDG base directory,
so we need to create symbolic links to `$HOME/.bashrc`, 
`$HOME/.bash_login` and `$HOME/.bash_logout` as workaround.

```shell
ln -v -s "${PWD}" "${XDG_CONFIG_HOME}/bash"

ln -v -s "${XDG_CONFIG_HOME}/bash/bash_login" "${HOME}/.bash_login"
ln -v -s "${XDG_CONFIG_HOME}/bash/bash_logout" "${HOME}/.bash_logout"
ln -v -s "${XDG_CONFIG_HOME}/bash/bashrc" "${HOME}/.bashrc"
```

We can do something with variables
to make things easy with XDG base directories,
for examples:

```shell ~/.bashrc
export BASH_CONFIG_HOME="${XDG_CONFIG_HOME}/bash"

if test -f "${BASH_CONFIG_HOME}/bashrc.d/aliases.bashrc"; then
    source "${BASH_CONFIG_HOME}/bashrc.d/aliases.bashrc"
fi
```

### References

- [Bash Startup Files]
- [Bash Variables]
- [Google - Shell Style Guide]

[Bash Startup Files]: https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html
[Bash Variables]: https://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html
[Google - Shell Style Guide]: https://google.github.io/styleguide/shellguide.html
