pull:
    mkdir -p components
    wkg wit fetch --config ./wkg-config.toml
    wkg get tofuya:provider-gitlab@0.1.0 -o components/tofuya-provider-gitlab.wasm --config ./wkg-config.toml --overwrite

build:
    cargo build --target wasm32-wasip2 --release
    wac plug target/wasm32-wasip2/release/tofuya_plugin_gitlab_states.wasm \
       --plug components/tofuya-provider-gitlab.wasm \
       -o tofuya-plugin-gitlab-states.wasm
