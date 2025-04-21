#!/usr/bin/env bash

ALL_SUMMARIZED_IP_LIST="./voice_domains/discord-voice-ip-summarized-list"

regions=("atlanta" "brazil" "bucharest" "buenos-aires" "dubai" "finland" "frankfurt" "hongkong" "india" "japan" "madrid" "milan" "newark" "rotterdam" "santa-clara" "santiago" "seattle" "singapore" "south-korea" "southafrica" "stage-scale" "stockholm" "sydney" "tel-aviv" "us-central" "us-east" "us-south" "us-west" "warsaw")

for region in "${regions[@]}"; do
    local_directory="./regions/$region"
    if [[ -f "$local_directory/${region}-voice-ip-summarized" ]]; then
        sort -u "$local_directory/${region}-voice-ip-summarized" >> "$ALL_SUMMARIZED_IP_LIST" 2>/dev/null || true
    fi
done

if [[ -f "$ALL_SUMMARIZED_IP_LIST" ]]; then
    sort -u "$ALL_SUMMARIZED_IP_LIST" > "$ALL_SUMMARIZED_IP_LIST".tmp 2>/dev/null || true
    rm "$ALL_SUMMARIZED_IP_LIST" 2>/dev/null || true
    mv "$ALL_SUMMARIZED_IP_LIST".tmp "$ALL_SUMMARIZED_IP_LIST" 2>/dev/null || true

    if ! command -v 'iprange' > /dev/null; then
        echo '"iprange" executable is missing, unable to combine subnets'
        exit 126
    fi

    iprange --union "$ALL_SUMMARIZED_IP_LIST" > "$ALL_SUMMARIZED_IP_LIST".tmp 2>/dev/null || true
    rm "$ALL_SUMMARIZED_IP_LIST" 2>/dev/null || true
    mv "$ALL_SUMMARIZED_IP_LIST".tmp "$ALL_SUMMARIZED_IP_LIST" 2>/dev/null || true
fi
