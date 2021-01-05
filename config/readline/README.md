## Readline Configuration

[GNU Readline] is a software library that provides line-editing 
and history capabilities for interactive programs 
with a command-line interface, such as Bash.

### Installation

[GNU Readline] doesn't support XDG base directory,
but it provide a environment variable `$INPUTRC` 
to configure the path of init file.

so we can simply configure `$INPUTRC` to 
`$XDG_CONFIG_HOME/readline/inputrc` in `.bashrc`: 

```shell
ln -v -s "${PWD}" "${XDG_CONFIG_HOME}/readline"
```

```shell .bashrc
export INPUTRC="${XDG_CONFIG_HOME}/readline/inputrc"
```

### References

- [GNU Readline]
- [Readline Init File Syntax]

[GNU Readline]: <https://en.wikipedia.org/wiki/GNU_Readline>
[Readline Init File Syntax]: <https://www.gnu.org/software/bash/manual/html_node/Readline-Init-File-Syntax.html>
"There are only a few basic constructs allowed in the Readline init file."
