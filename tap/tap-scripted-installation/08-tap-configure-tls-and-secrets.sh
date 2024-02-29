# 09-tap-configure-tls.sh
#
# First update password.txt and route53-clusterissuer.yaml
#
#
#kubectl create secret generic route53-credentials-secret --from-file=../tls/password.txt -n cert-manager
#kubectl apply -f ../tls/route53-clusterissuer.yaml
#kubectl apply -f ../tls/tap-gui-azure-certificate.yaml
#kubectl apply -f ../secrets/git-secret.yaml




#NT: Using Cloudflare DNS

# Install cert-manager in cert-manager namespace
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.3/cert-manager.yaml


# Create a  secret with your Cloudflare API token
apiVersion: v1
kind: Secret
metadata:
  name: cloudflare-api-token-secret
  namespace: cert-manager
type: Opaque
stringData:
  #api-token: <API Token>
  api-token: "PmkfvbMp6P0DgYgNgjAeCWWMzm_thU5Ffm6y1r5S"

# Next we make the issuer that defines letsencrypt
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: letsencrypt-prod
  namespace: cert-manager
spec:
  acme:
    email: niels@teekens.info
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - dns01:
        cloudflare:
          email: niels@teekens.info
          apiTokenSecretRef:
            name: cloudflare-api-token-secret
            key: api-token  


# Enter the domain info
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: nilab.io
  namespace: cert-manager
spec:
  secretName: tap-gui
  issuerRef:
    name: letsencrypt-prod
  duration: 2160h # 90d
  renewBefore: 720h # 30d before SSL will expire, renew it
  dnsNames:
    - "nilab.io"
    - "*.nilab.io"