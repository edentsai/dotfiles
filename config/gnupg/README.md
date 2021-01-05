## GnuPG 

[GnuPG] is a complete and free implementation of the OpenPGP standard 
as defined by RFC4880 (also known as PGP). 

[GnuPG] allows you to encrypt and sign your data and communications; 
it features a versatile key management system, 
along with access modules for all kinds of public key directories.

### Installation

[GnuPG] doesn't support XDG base directory,
so we need to create symbolic links to `$HOME/.gnupg` as workaround.

1.  Use `$XDG_DATA_HOME/gnupg` as real GnuPG home directory,
    and create a symbolic link to `$HOME/.gnupg` as fallback:

        ```shell
        if test -e "${HOME}/.gnupg"; then
            mkdir -p "${XDG_DATA_HOME}"
            mv -v "${HOME}/.gnupg" "${XDG_DATA_HOME}/gnupg"
        else
            mkdir -p "${XDG_DATA_HOME}/gnupg"
        fi
        ln -v -s "${XDG_DATA_HOME}/gnupg" "${HOME}/.gnupg"
        ```

2.  Create symbolic links of GPG configurations 
    into `$HOME/.gnupg`:

        ```
        ln -v -s "${PWD}" "${XDG_CONFIG_HOME}/gnupg"
        
        ln -v -s \
            "${XDG_CONFIG_HOME}/gnupg/gpg.conf" \
            "${HOME}/.gnupg/gpg.conf"
        
        ln -v -s \
            "${XDG_CONFIG_HOME}/gnupg/gpg-agent.conf" \
            "${HOME}/.gnupg/gpg-agent.conf"
        
        ln -v -s \
            "${XDG_CONFIG_HOME}/gnupg/dirmngr.conf" \
            "${HOME}/.gnupg/dirmngr.conf""
        
        # Reload GPG agent.
        gpg-connect-agent reloadagent /bye
        ```

2.  Remember to configure `$GPG_TTY` variable in your `.bashrc` to
    to allows GPG agent ask passphrase in the Terminal:

        ```shell
        export GPG_TTY="$(tty)"
        ```

### References

-   [GnuPG]
    -   [GPG Configuration Options](https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html)
    -   [GPG Input and Output](https://www.gnupg.org/documentation/manuals/gnupg/GPG-Input-and-Output.html)
    -   [GPG Options](https://www.gnupg.org/documentation/manuals/gnupg/GPG-Options.html)
    -   [GPG Options Reference](https://www.gnupg.org/gph/en/manual/r1172.html)
    -   [Invoking GPG Agent](https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html)
    -   [GPG Agnet Options](https://www.gnupg.org/documentation/manuals/gnupg/Agent-Options.html)
-   [ArchLinux - GnuPG](https://wiki.archlinux.org/index.php/GnuPG)
-   [GPG Quickstart Guide](https://medium.com/@acparas/gpg-quickstart-guide-d01f005ca99)

[GnuPG]: <https://www.gnupg.org>
