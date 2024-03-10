function addkey () {
    key="$1"
    security add-generic-password -a $LOGNAME -s "$key" -T "" -w
}

function getkey() {
    key="$1"
    security find-generic-password -w -a $LOGNAME -s "$key"
}

function delkey() {
    key="$1"
    security delete-generic-password -a $LOGNAME -s "$key"
}
