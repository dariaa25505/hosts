#!/bin/bash

# verifica_ip NUME IP SERVER_DNS
# Intoarce 0 daca IP-ul corespunde numelui la serverul DNS dat, 1 altfel
verifica_ip() {
    local nume="$1"
    local ip="$2"
    local dns="$3"

    # intrebam serverul DNS dat si pastram doar adresele IPv4 din raspuns
    local reale
    reale=$(nslookup "$nume" "$dns" 2>/dev/null | awk '/^Address:/ {print $2}' | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$')

    echo "$reale" | grep -qx "$ip"
}

# serverul DNS: primul argument al scriptului, implicit 8.8.8.8
dns_server="${1:-8.8.8.8}"

cat /etc/hosts | while read ip nume rest; do
    # sarim peste liniile goale si peste comentarii
    case "$ip" in
        ""|\#*) continue ;;
    esac

    if ! verifica_ip "$nume" "$ip" "$dns_server"; then
        echo "Bogus IP for $nume in /etc/hosts!"
    fi
done
echo "Script modificat de Crina"
