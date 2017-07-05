if [ -e /var/cfengine/classes/nextgen ]
then
    source /home/fonix/prd_progs/tools/engineering-login.sh
    source /home/fonix/prd_progs/tools/fdb_utils.sh
    source /home/fonix/prd_progs/tools/dbl/dbl_defs.sh
    source /home/fonix/prd_progs/tools/uniframe/common_defs.sh
else
    echo "*** This does not appear to be a NEXTGEN CLASS MACHINE, skipping NEXTGEN specific set-up ***"
fi

# soure:   https://github.com/mathiasbynens/dotfiles/blob/master
# Load the shell dotfiles, and then some:
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
        [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# include expansion of files starting with '.'
shopt -s dotglob

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Add tab completion for many Bash commands (only for OSX)
if [[ `uname` == 'Darwin' ]]; then
    if which brew > /dev/null && [ -f "$(brew --prefix)/etc/bash_completion" ]; then
        source "$(brew --prefix)/etc/bash_completion";
    elif [ -f /etc/bash_completion ]; then
        source /etc/bash_completion;
    fi;
fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
    complete -o default -o nospace -F _git g;
fi;

export PATH="$HOME/.linuxbrew/bin:$PATH"

source /home/fonix/prd_progs/bcomcts/tools/ccc_common_profile_user.sh

echo '.bash_profile sourced'
