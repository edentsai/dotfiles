## EditorConfig

[EditorConfig] helps maintain consistent coding styles
for multiple developers working on the same project
across various editors and IDEs.

See the following links for more details:

- [EditorConfig]
- [EditorConfig Supported Properties]
- [EditorConfig Specification]

### Installation

[EditorConfig] doesn't support XDG base directory,
but we can create a symbolic link to `${HOME}/.editorconfig`
as workaround:

```shell
ln -v -s \
    "${PWD}" \
    "${XDG_CONFIG_HOME}/editorconfig"

ln -v -s \
    "${XDG_CONFIG_HOME}/editorconfig/editorconfig" \
    "${HOME}/.editorcconfig"
```

[EditorConfig]: https://editorconfig.org
[EditorConfig Supported Properties]: https://github.com/editorconfig/editorconfig-vim#supported-properties
[EditorConfig Specification]: https://editorconfig-specification.readthedocs.io
