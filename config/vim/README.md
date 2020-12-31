## Vim Configuration

### Installation

[Vim] doesn't support XDG base directory,
so we need to create a symbolic link to `$HOME/.vim` as workaround:

```shell
ln -v -s "${PWD}" "${XDG_CONFIG_HOME}/vim"

ln -v -s "${XDG_CONFIG_HOME}/vim" "${HOME}/.vim"
```

We can do something with variables
to make things easy with XDG base directories,
for example:

```vim vimrc
source $XDG_CONFIG_HOME/vim/vimrc.d/mappings.vim
```

### References

-   [Vim: a highly configurable text editor built to make creating and changing any kind of text very efficient][Vim].
-   [Learn Vimscript the Hard Way: a book for users of the Vim editor who want to learn how to customize Vim](https://learnvimscriptthehardway.stevelosh.com).
    - [Plugin Layout in the Dark Ages](https://learnvimscriptthehardway.stevelosh.com/chapters/42.html).

[Vim]: <https://www.vim.org> "Vim is a highly configurable text editor built to make creating and changing any kind of text very efficient."