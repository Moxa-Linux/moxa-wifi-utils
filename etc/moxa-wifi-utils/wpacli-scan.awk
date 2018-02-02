BEGIN {
    i = 0
}
/^/ {
    wifi[i]["mac"] = $1
    wifi[i]["freq"] = $2
    wifi[i]["sig"] = $3

    # WPA-PSK: WPA
    # WPA2-PSK: WPA2
    # WPA-EAP: WPA, EAP
    # WPA2-EAP: WPA2, EAP
    # WEP: WEP
    wifi[i]["enc"] = "Open"
    where = match($4, /WPA-PSK/)
    if (where != 0)
        wifi[i]["enc"] = "WPA"
    where = match($4, /WPA2-PSK/)
    if (where != 0) {
        if (wifi[i]["enc"] == "WPA")
            wifi[i]["enc"] = "WPA/WPA2"
        else
            wifi[i]["enc"] = "WPA2"
    }
    wifi[i]["eap"] = "N"
    where = match($4, /WPA-EAP/)
    if (where != 0) {
        wifi[i]["eap"] = "Y"
        wifi[i]["enc"] = "WPA"
    }
    where = match($4, /WPA2-EAP/)
    if (where != 0) {
        wifi[i]["eap"] = "Y"
        if (wifi[i]["enc"] == "WPA")
            wifi[i]["enc"] = "WPA/WPA2"
        else
            wifi[i]["enc"] = "WPA2"
    }
    where = match($4, /WEP/)
    if (where != 0) {
        wifi[i]["enc"] = "WEP"
    }
    if (length($5) == 0)
        wifi[i]["ssid"] = ""
    else
        wifi[i]["ssid"] = substr($0, index($0,$5))
    i++
}
END {
    for (w in wifi) {
        printf "%s\t%s\t%s\t%s\t%s\t%s\n",wifi[w]["mac"],wifi[w]["freq"],wifi[w]["sig"],wifi[w]["enc"],wifi[w]["eap"],wifi[w]["ssid"]
    }
}
