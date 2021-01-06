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

### SSH Authentication with GnuPG

> **References**
>
> [Using a GPG key for SSH authentication on macOS and Debian](https://gregrs-uk.github.io/2018-08-06/gpg-key-ssh-mac-debian/)

Copy `sshcontrol-example` to `sshcontrol`,
then we will edit it later:

```shell
cp -v sshcontrol-example sshcontrol

ln -v -s \
    "${XDG_CONFIG_HOME}/gnupg/sshcontrol" \
    "${HOME}/.gnupg/sshcontrol"
```

#### Use GPG Subkey for SSH Authentication

1.  Add a GPG subkey with `authenticate` capability:

    ```shell
    gpg --keyid-format "0xlong" \
        --edit-key "<GPG_KEY_ID>"
    
    gpg> addkey
    ...
    
    gpg> save
    ```

2.  Apply the GPG subkey into `sshcontrol`:

    ```shell

    gpg --keyid-format "0xlong" \
        --list-secret-keys \
        --with-keygrip
    
    echo "<GPG_SUBKEY_KEYGRIP>" | tee -a sshcontrol
    
    # Verify it is works:
    ssh-add -l
    # ssh-ed25519 <SSH_PUBLIC_KEY> (none)
    ```

3.  Export public key in OpenSSH format from a specific GPG Subkey:

    ```shell
    gpg --list-secret-keys \
        --keyid-format "0xlong"
    
    gpg --export-ssh-key "<GPG_SUBKEY_ID>" | tee ssh-public-key.pub
    # ssh-ed25519 <SSH_PUBLIC_KEY> openpgp:<HASH>
    ```

4.  Finally, you can add the public key into `$HOME/.ssh/authorized_keys`
    on the server which you're connecting.

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
- [Using a GPG key for SSH authentication on macOS and Debian](https://gregrs-uk.github.io/2018-08-06/gpg-key-ssh-mac-debian/)

[GnuPG]: <https://www.gnupg.org>
