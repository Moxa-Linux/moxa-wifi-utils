BEGIN {
    i = 0
}
/^BSS / {
    MAC = substr($2,1,length($2)-3)
    i++
    wifi[i]["mac"] = MAC
    wifi[i]["enc"] = "Open"
    wifi[i]["eap"] = "N"
}
$1 == "SSID:" {
    wifi[i]["ssid"] = substr($0,index($0,$1)+length($1)+1)
}
$1 == "freq:" {
    wifi[i]["freq"] = $NF
}
$1 == "signal:" {
    wifi[i]["sig"] = substr($2,1,length($2)-3)
}
$1 == "WPA:" {
    wifi[i]["enc"] = "WPA"
}
$1 == "RSN:" {
    if (wifi[i]["enc"] == "WPA")
        wifi[i]["enc"] = "WPA/WPA2";
    else
        wifi[i]["enc"] = "WPA2";
}
$5 == "802.1X" {
    wifi[i]["eap"] = "Y"
}
$1 == "WEP:" {
    wifi[i]["enc"] = "WEP"
}
END {
    #printf "%-17s %s\t%s\t%s\t%s\t%s\n","MAC","SSID","Frequency","Signal","Encryption","EAP"

    for (w in wifi) {
        printf "%s\t%s\t%s\t%s\t%s\t%s\n",wifi[w]["mac"],wifi[w]["freq"],wifi[w]["sig"],wifi[w]["enc"],wifi[w]["eap"],wifi[w]["ssid"]
    }
}
