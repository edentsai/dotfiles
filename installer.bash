#!/usr/bin/env bash
# vim: set filetype=sh:

DIFF=`which diff`

# Get absolute path of dotfiles directory.
INSTALLER_PATH="$PWD/$0"
DOTFILES_DIR=$(dirname "$INSTALLER_PATH")

# A directory for backup the old dotfiles.
BACKUP_TIMESTAMP=`date +%s`
BACKUP_DIR="$DOTFILES_DIR/backup/$BACKUP_TIMESTAMP"

# A directory for install useful commands.
BIN_DIR="$DOTFILES_DIR/_bin"

# Create dotfile links to $HOME.
function create_dotfile_links()
{
    local filepath="$1"
    local filename=`basename $filepath`

    if [ -e "$filepath" ]; then
        # Skip if the $filepath is $DOTFILES_DIR
        if [ "$DOTFILES_DIR" != "$filepath" ]; then
            # Backup $target_filepath if $target_filepath already existed.
            local target_filepath="$HOME/${filename/_/.}"
            if [ -e "$target_filepath" ] && [ -n "$($DIFF $filepath $target_filepath)" ]; then
                backup_dotfile "$target_filepath"
            fi

            # Create a symbolic link from $HOME to $filepath
            if [ ! -e $target_filepath ] || [ -n "$($DIFF $filepath $target_filepath)" ]; then
                echo "Create symbolic links '$filepath' to '$target_filepath'"
                ln -sfn "$filepath" "$target_filepath"
            fi
        fi

        # Create symbolic links from $HOME to $filepath by recursive if $filepath is a directory
        if [ -d "$filepath" ]; then
            for file in $filepath/_*; do
                create_dotfile_links $file
            done
        fi
    fi

    unset filepath filename target_filepath
}

# Backup a dotfile to $BACKUP_DIR.
function backup_dotfile()
{
    # Create the backup directory if it not exists.
    if [ ! -e "$BACKUP_DIR" ]; then
        echo "Create a directory at '$BACKUP_DIR' for backup the old dotfiles."
        mkdir -p "$BACKUP_DIR"
    fi

    local filepath="$1"
    local filename=`basename $filepath`
    local backup_filepath="$BACKUP_DIR/$filename"

    echo "Move '$filepath' to '$backup_filepath' for backup"
    mv "$filepath" "$backup_filepath"

    unset filepath filename backup_filepath
}

# Run installer.
cd $DOTFILES_DIR
echo "Initialize all submodules:"
git submodule update --recursive --init

echo "Install and create symbolic links to '$DOTFILES_DIR':"
create_dotfile_links $DOTFILES_DIR

echo "Source '$HOME/.bash_profile' after installed."
source "$HOME/.bash_profile"

# Install dependency tools
INSTALLERS_DIR="$DOTFILES_DIR/installers"
for installer_script in `ls $INSTALLERS_DIR/*-installer.bash`; do
    if [ -f "$installer_script" ]; then
        bash $installer_script $BIN_DIR
    fi
done
