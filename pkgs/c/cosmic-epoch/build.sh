just_build() {
    PREBUILD_CWD="$PWD"
    cd $1
    shift
    export CARGO_HOME=${PWD}/.cargo
    just $@
    cd "$PREBUILD_CWD"
}
