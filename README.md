# VB Scan GitHub Action

## Description
A GitHub Action to perform VB SBOM scans and retrieve ECR credentials.

## Inputs
- `vb-api-url`: (Required) The base URL for the VB API
- `vb-api-key`: (Required) The API key for authentication

## Outputs
- `username`: ECR username
- `password`: ECR password
- `region`: ECR region
- `registry_id`: ECR registry ID
- `scan_id`: The ID of the created SBOM scan

## Example Usage
```yaml
- name: VB Scan
  uses: your-org/vb-scan-action@v1
  with:
    vb-api-url: ${{ secrets.VB_API_URL }}
    vb-api-key: ${{ secrets.VB_API_KEY }}
```

## License
[Choose an appropriate license]
