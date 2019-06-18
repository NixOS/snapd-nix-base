#!/bin/sh

set -eux

resultpath=$(nix-build .)
snapcraft push --release=stable \
          "$resultpath/nix-base_*_all.snap"
