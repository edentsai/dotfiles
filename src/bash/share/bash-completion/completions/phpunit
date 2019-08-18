_phpunit_completion()
{
    local cur prev phpunit_opts

    COMPREPLY=()
    _get_comp_words_by_ref cur prev

    if [[ ${cur} == -* ]] ; then
        phpunit_opts=`phpunit --help | grep -o -e "\-[a\-z\-]*"`
        COMPREPLY=($(compgen -W "${phpunit_opts}" -- ${cur}))
    fi

    return 0
}

complete -F _phpunit_completion -o default phpunit
