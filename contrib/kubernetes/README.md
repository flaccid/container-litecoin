# Kubernetes Manifest(s) for litecoin

The `statefulset.yaml` is designed to be the most simple example which uses a persistent volume claim and resource limits.

The Local Path Provisioner witll create a `hostPath`-based persistent volume on the node automatically, see https://github.com/rancher/local-path-provisioner/blob/master/README.md#usage.

Resources limits are merely a demonstration of usage. More information, https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/.

An alternative is to write a custom helm chart or just use https://github.com/flaccid/chart-flex.

**Important**: Be sure to create the service account first using `serviceaccount.yaml`.

## Testing

This was quickly tested with a single node k3s cluster which comes with the [`local-path`](https://rancher.com/docs/k3s/latest/en/storage/) provisioner/storage class.
