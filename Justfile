clean:
    rm wit/deps/*.wasm

pull:
    wkg oci pull ghcr.io/tmuntaner/tofuya-provider-gitlab:0.1.0 -o wit/deps/tofuya-provider-gitlab.wasm
    wkg oci pull ghcr.io/tmuntaner/tofuya-plugin-interface:0.1.0 -o wit/deps/tofuya-plugin-interface.wasm

build:
    cargo component build --release
    wasm-tools compose target/wasm32-wasip1/release/tofuya_plugin_gitlab_states.wasm \
        -d wit/deps/tofuya-provider-gitlab.wasm \
        -o tofuya-plugin-gitlab-states.wasm
