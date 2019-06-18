{
  lib, runCommand, squashfsTools, closureInfo, jq
}:
let
  meta = {
    name = "nix-base";
    type = "base";
    confinement = "strict";
    architectures = [ "all" ] ;
    license = "CC0-1.0";
  };

  # from: https://github.com/snapcore/snapcraft/blob/b88e378148134383ffecf3658e3a940b67c9bcc9/snapcraft/internal/lifecycle/_packer.py#L96-L98
  # These options need to match the review tools:
  # http://bazaar.launchpad.net/~click-reviewers/click-reviewers-tools/trunk/view/head:/clickreviews/common.py#L38
  mksquashfs_args = [
    "-noappend" "-comp" "xz" "-no-xattrs" "-no-fragments"

    # https://github.com/snapcore/snapcraft/blob/b88e378148134383ffecf3658e3a940b67c9bcc9/snapcraft/internal/lifecycle/_packer.py#L100
    "-all-root"
  ];
in runCommand "nix-base" {
  nativeBuildInputs = [ squashfsTools jq ];

  snapMeta = builtins.toJSON meta;
  passAsFile = [ "snapMeta" ];
}
''
  root=$PWD/root
  mkdir $root

  version=$(echo $out | cut -d/ -f4 | cut -d- -f1)

  (
    mkdir $root/meta
    cat $snapMetaPath | jq  ". + { version: \"$version\" }" \
    > $root/meta/snap.yaml
  )

  (
    cd $root
    mkdir --mode 755 -p meta sys tmp usr/lib/snapd usr/src \
      bin nix snap etc root run dev home proc var/lib/snapd \
      var/tmp var/snap var/log media \
      usr/share/fonts usr/local/share/fonts \
      var/cache/fontconfig
  )

  # Generate the squashfs image.
  mksquashfs $root ./nix-base_''${version}_all.snap \
    ${lib.concatStringsSep " " mksquashfs_args}

  mkdir $out
  mv ./nix-base_*_all.snap $out/
''
