function silently() {
    "$@" >/dev/null
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

function gitAmmend() {
    git add .
    git commit --amend --no-edit
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
    }

    git add . && ./gradlew build --offline -x detekt && {
        pendingChanges && doCommit
        pendingChanges || inRebase && git rebase --continue
    }

}

function gitStagger() {
    git diff --name-only --cached | while read -r file; do
        name=$(basename "$file")
        git commit -m "$name" "$file"
    done
}

function gitPreserve() {

    allowlist=($(cat))
    git rebase --interactive --exec "false" "${1}"

    # while inRebase; do

    sleep 1
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

    # done
}
