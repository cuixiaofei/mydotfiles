#!/bin/bash
# ~/.bash_functions/proxy.sh

# your windows external address
export WIN_HOST=$(awk '/nameserver/ {print $2}' /etc/resolv.conf)

proxy_on() {
    # add your external port
    export http_proxy="http://$WIN_HOST:7890"
    export https_proxy="$http_proxy"
    echo "✅ Proxy enabled"
}

proxy_off() {
    unset http_proxy https_proxy
    echo "📴 Proxy disabled"
}