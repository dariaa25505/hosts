cat /etc/hosts | while read ip nume rest; do
    # sărim peste liniile goale și peste comentarii (cele care încep cu #)
    case "$ip" in
        ""|\#*) continue ;;
    esac

    # întrebăm DNS-ul și păstrăm doar adresele IPv4 din răspuns
    reale=$(nslookup "$nume" 2>/dev/null | awk '/^Address:/ {print $2}' | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$')

    # dacă IP-ul din /etc/hosts nu e printre cele reale, e fals
    if ! echo "$reale" | grep -qx "$ip"; then
        echo "Bogus IP for $nume in /etc/hosts!"
    fi
done
