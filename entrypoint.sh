#!/bin/bash
set -e

VB_API_URL=$1
VB_API_KEY=$2

export_vb_environment_variables() {
    echo "Exporting VB Environment Variables..."
    if [ -z "$VB_API_URL" ] || [ -z "$VB_API_KEY" ]; then
        echo "Error: Missing required variables: VB_API_URL or VB_API_KEY" >&2
        return 1
    fi
    local api_url="${VB_API_URL}utilityapi/v1/registry?api_key=${VB_API_KEY}"
    local response
    response=$(curl --silent --location "$api_url")
    local encoded_data
    encoded_data=$(echo "$response" | jq -r '.data')
    if [ -z "$encoded_data" ]; then
        echo "Error: No data received from registry API" >&2
        return 1
    fi
    local decoded_data
    decoded_data=$(echo "$encoded_data" | base64 -d)
    
    # Output ECR credentials as GitHub Action outputs
    echo "username=$(echo "$decoded_data" | jq -r '.username')" >> "$GITHUB_OUTPUT"
    echo "password=$(echo "$decoded_data" | jq -r '.password')" >> "$GITHUB_OUTPUT"
    echo "region=$(echo "$decoded_data" | jq -r '.region')" >> "$GITHUB_OUTPUT"
    echo "registry_id=$(echo "$decoded_data" | jq -r '.registry_id')" >> "$GITHUB_OUTPUT"
}

create_sbom_scan() {
    echo "Creating SBOM Scan..."
    local request_body="{\"api_key\": \"${VB_API_KEY}\"}"
    local response
    response=$(curl --silent --location "${VB_API_URL}utilityapi/v1/scan" \
        -H "Content-Type: application/json" \
        -d "$request_body")
    local scan_id
    scan_id=$(echo "$response" | jq -r '.data.scan_id')
    if [ -z "$scan_id" ] || [ "$scan_id" = "null" ]; then
        echo "Error: Failed to get scan_id from API response" >&2
        return 1
    fi
    
    # Output scan ID as GitHub Action output
    echo "scan_id=$scan_id" >> "$GITHUB_OUTPUT"
}

main() {
    export_vb_environment_variables
    create_sbom_scan
}

main
