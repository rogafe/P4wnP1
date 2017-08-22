#/bin/bash
# check for presence of wlan1

if ! sudo iwconfig 2>&1 | grep -q -E ".*wlan1.*"; then
        echo "...[Error] now wlan0 interface found"
        exit 1
fi
exit 0
