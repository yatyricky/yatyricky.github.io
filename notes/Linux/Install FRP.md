```bash
install_frps() {
    if [[ -f /usr/local/bin/frps ]]; then
        echo "frps is already installed."
        return 0
    fi
    local frp_dirname
    frp_dirname=$(basename "$frp_archive" .tar.gz)
    if [[ -f "${frp_dirname}.tar.gz" ]]; then
        echo "frp package already downloaded."
    else
        echo "Downloading frp package into $staging..."
        wget -q --show-progress -O "${frp_dirname}.tar.gz" "$frp_archive"
    fi
    echo "Extracting frp package..."
    tar -xzf "${frp_dirname}.tar.gz"
    echo "Installing frps..."
    sudo install -o root -g root -m 0755 "./$frp_dirname/frps" /usr/local/bin/frps
}
```