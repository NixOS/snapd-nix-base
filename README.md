Have a Snapcraft-capable machine

Hint: NixOS doesn't have Snapcraft at the time of publishing.

Then:

1. `snapcraft login`
2. `./publish.sh`

However, good news, you will probably never need to do this since the
base image has almost nothing in it but the minimum necessary
directories plus `/nix`.
