#!/usr/bin/env bash
# vim: set filetype=sh

# Return if not running interactive bash.
if [[ "${BASH_VERSION:-}" == "" ]] || [[ "${PS1:-}" == "" ]]; then
    return
fi

# Display the last commit id of current branch.
function git_last_commit_id()
{
    if [[ "$(__git_ps1)" == "" ]]; then
        return
    fi

    local last_commit_id
    last_commit_id="$(git rev-parse --short HEAD 2>/dev/null)"
    if [[ "${last_commit_id}" != "" ]]; then
        echo "${last_commit_id}"
    fi
}

# Get time since the git last commit.
function git_since_last_commit()
{
    # Get last commit time
    local last_committed_at
    last_committed_at="$(git log --pretty=format:%at -1 2>/dev/null)"
    if [[ "${last_committed_at}" == "" ]]; then
        return
    fi

    # Calculate since last commit
    local now
    now="$(date +%s)"

    local seconds_since_last_commit
    seconds_since_last_commit="$((now - last_commit))"

    local minutes_since_last_commit
    minutes_since_last_commit="$((seconds_since_last_commit / 60))"

    local hours_since_last_commit
    hours_since_last_commit="$((minutes_since_last_commit / 60))"

    minutes_since_last_commit="$((minutes_since_last_commit % 60))"

    echo "${hours_since_last_commit}h ${minutes_since_last_commit}m"
}

# Display git current ps1.
function git_current_ps1()
{
    local git_ps1
    git_ps1="$(__git_ps1)"
    if [[ "${git_ps1}" == "" ]]; then
        return
    fi

    local last_commit_id
    last_commit_id="$(git_last_commit_id)"
    if [[ "${last_commit_id}" != "" ]]; then
        git_ps1="${git_ps1} > ${last_commit_id}"
    fi

    local since_last_commit
    since_last_commit="$(git_since_last_commit)"
    if [[ "${since_last_commit}" != "" ]]; then
        git_ps1="${git_ps1} > ${since_last_commit}"
    fi

    echo "${git_ps1}"
}
