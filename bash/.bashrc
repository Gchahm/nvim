export XDG_CONFIG_HOME="${HOME}/custom_config"

check_and_install() {
    local cmd=$1
    local install_cmd=$2

    if ! command -v "$cmd" &> /dev/null; then
        echo "$cmd not found, installing..."
        eval "$install_cmd"
    fi
}

check_and_install "nvim" "sudo snap install nvim --classic"
check_and_install "clang" "sudo apt update && sudo apt install -y clang"
check_and_install "unzip" "sudo apt update && sudo apt install -y unzip"
check_and_install "oh-my-posh" "curl -s https://ohmyposh.dev/install.sh | bash -s"
check_and_install "lua" "sudo apt install lua5.1"
check_and_install "make" "sudo apt install make"
check_and_install "luarocks" "sudo apt install luarocks"
check_and_install "rg" "sudo apt  install ripgrep"
check_and_install "nvm" "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash"

alias vim='nvim'

init_posh() {
    local theme="honukai"
    local theme_path="${XDG_CONFIG_HOME}/posh_themes/${theme}.omp.json"
    local command="$(oh-my-posh init bash --config ${theme_path})"
    eval "$command"
}
init_posh
