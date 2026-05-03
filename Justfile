pull:
    mkdir -p wit/deps/tofuya-provider-gitlab
    wkg oci pull ghcr.io/tmuntaner/tofuya-provider-gitlab:0.1.0 -o components/tofuya-provider-gitlab.wasm
    wasm-tools component wit components/tofuya-provider-gitlab.wasm > wit/deps/tofuya-provider-gitlab/provider.wit
    mkdir -p wit/deps/tofuya-plugin
    wkg oci pull ghcr.io/tmuntaner/tofuya-plugin-interface:0.1.0 -o components/tofuya-plugin-interface.wasm
    wasm-tools component wit components/tofuya-plugin-interface.wasm > wit/deps/tofuya-plugin/plugin.wit

build:
    cargo build --target wasm32-wasip2 --release
    wac plug target/wasm32-wasip2/release/tofuya_plugin_gitlab_states.wasm \
       --plug components/tofuya-provider-gitlab.wasm \
       -o tofuya-plugin-gitlab-states.wasm
