#!/bin/bash

DOWNLOAD_DIR="./databases"
mkdir -p $DOWNLOAD_DIR

function download {
  name=$(echo $1 |awk -F "/" '{print $NF}')
  echo "Downloading $name..."
  wget -q -O "$DOWNLOAD_DIR/$name" "$1" &
}

function contains_arg {
    local target
    target="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
    shift
    for arg in "$@"; do
        if [ "$(echo "$arg" | tr '[:upper:]' '[:lower:]')" = "$target" ]; then
            return 0
        fi
    done
    return 1
}


if [ $# -eq 0 ]; then
  echo -e "Downloading everything by default.\n"
  set -- 'afrinic' 'apnic' 'ripe' 'ipv6'
fi


if contains_arg "afrinic" "$@"; then
  download "https://ftp.afrinic.net/pub/dbase/afrinic.db.gz"
fi

if contains_arg "apnic" "$@"; then
  download "https://ftp.apnic.net/apnic/whois/apnic.db.aut-num.gz"
  download "https://ftp.apnic.net/apnic/whois/apnic.db.organisation.gz"
  
  download "https://ftp.apnic.net/pub/apnic/whois/apnic.db.inetnum.gz"

  if contains_arg "ipv6" "$@"; then
    download "https://ftp.apnic.net/pub/apnic/whois/apnic.db.inet6num.gz"
  fi
fi

if contains_arg "ripe" "$@"; then
  download "https://ftp.ripe.net/ripe/dbase/split/ripe.db.aut-num.gz"
  download "https://ftp.ripe.net/ripe/dbase/split/ripe.db.organisation.gz"

  download "https://ftp.ripe.net/ripe/dbase/split/ripe.db.inetnum.gz"

  if contains_arg "ipv6" "$@"; then
    download "https://ftp.ripe.net/ripe/dbase/split/ripe.db.inet6num.gz"
  fi
fi


# it is a 'route' db - ignoring
# download "https://ftp.arin.net/pub/rr/arin.db.gz"

# it doesn't contain any tangible to org info - ignoring
# download "https://ftp.lacnic.net/lacnic/dbase/lacnic.db.gz" 


wait
