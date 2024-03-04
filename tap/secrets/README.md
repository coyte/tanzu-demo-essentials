# Secrets

This is where the secrets for use with TAP are created.
The ytt templating system is used to prevent editing multiple files and have credentials on github.
A example-values.yaml is suplied for structure, copy the file and edit it to your liking.

To actually create the secrets in the cluster, run

```
    ytt -f secrets.yaml -f values.yaml | kubectl apply -f-
```
