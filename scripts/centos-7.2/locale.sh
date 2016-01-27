#!/usr/bin/env bash

set -ex

localedef --list-archive | grep -a -v en_US.utf8 | xargs sudo localedef --delete-from-archive
sudo cp /usr/lib/locale/locale-archive{,.tmpl}
sudo build-locale-archive
