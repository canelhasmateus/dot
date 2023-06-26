#! /bin/bash

function silently() {
    "$@" >/dev/null
}

function continuously() {
    while "$@"; do
        true
    done
}

function prompt() {
    while true; do
        echo -n "$1"
        read -r yn

        case $yn in
        [yY]) return 0 ;;
        [nN]) return 1 ;;
        *) ;;
        esac

    done
}
function atGitRoot() {
    root=$(git rev-parse --show-toplevel) &&
        silently pushd &&
        silently cd "$root" &&
        "$@" &&
        silently popd
}

function inRebase() {
    [ -d ".git/rebase-merge" ] || [ -d ".git/rebase-apply" ]
}

function pendingChanges() {
    [ -n "$(git status --porcelain=v1 2>/dev/null)" ]
}

function lastMessage() {
    git log -1 --pretty=%B
}
function currentBranch() {
    git rev-parse --abbrev-ref HEAD
}

function gitAmmend() {
    git add .
    git commit --amend --no-edit
}

function gitPush() {
    remote="origin"
    branchName=$(currentBranch)
    git push -u ${remote} "${branchName}"
}

function gitSwap() {
    git add .
    git commit -m "tmp"
    git checkout -
}

function gitAdvance() {
    message=$1
    function doCommit() {
        [ -z "$message" ] && {
            lastMessage=$(git log -1 --pretty=%B)

            echo -n "Build success. Commit: [${lastMessage}]: "
            read -r input

            message=${input:-$lastMessage}
        }
        git add .
        git commit -m "$message"
        return 0
    }

    git add . && ./gradlew build --offline -x detekt && {

        pendingChanges && doCommit && inRebase &&
            prompt "Would you like to revert newly commited change to avoid conflicts in your rebase? (y/n) " &&
            git revert head --no-edit

        pendingChanges || inRebase && git rebase --continue

        return 0
    }

}

function gitStagger {
    git diff --name-only --cached | while read -r file; do
        name=$(basename "$file")
        git commit -m "$name" "$file"
    done
}
function gitPreserve() {

    allowlist=($(cat))
    lastMessage=$(git log -1 --pretty=%B)

    git reset --soft head~ && {

        git diff --name-only --staged | while read -r file; do
            git restore --staged "${file}"
        done

        git status &&
            for file in "${allowlist[@]}"; do
                git add file
            done

        git status &&
            git commit -m "${lastMessage}" &&
            git add . && git reset --hard
    }
}

alias gammend="atGitRoot gitAmmend"
alias gpush="atGitRoot gitPush"

alias gswap="atGitRoot gitSwap"
alias gstagger="atGitRoot gitStagger"

alias gadvance="atGitRoot gitAdvance"
alias gpreserve="atGitRoot gitPreserve"
