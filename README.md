# container-litecoin

A simple container for running `litecoind`.

## Helm Chart

Validate the chart:

`helm lint charts/litecoin`

Dry run and print out rendered YAML:

`helm install --dry-run --debug litecoin charts/litecoin`

Dry run and print out rendered YAML with merged values file:

```
helm install \
  --dry-run \
  --debug \
  -f helm-values.local.yaml \
    litecoin charts/litecoin
```

#### Installation

`helm install \
  --namespace crypto
  litecoin charts/litecoin`

Or, with some different values:

```
helm install litecoin \
  --set image.tag="latest" \
  --set service.type="LoadBalancer" \
    charts/litecoin
```

Or, the same but with a custom values from a file:

```
helm install litecoin \
  -f helm-values.local.yaml \
    charts/litecoin
```

#### Testing

Testing after creation of a release:

`helm test litecoin`

#### Upgrading

Upgrade the chart, with values file:

```
helm upgrade litecoin . \
  -f helm-values.local.yaml
```

#### Uninstallation

Completely remove the chart:

`helm uninstall litecoin`

## Container Image Scanning

Passes with `grype`:

```
$ grype flaccid/litecoin:0.18.1
 ✔ Vulnerability DB     [updated]
 ✔ Loaded image         
 ✔ Parsed image         
 ✔ Cataloged image      [17 packages]
 ✔ Scanned image        [0 vulnerabilities]

No vulnerabilities found
```
