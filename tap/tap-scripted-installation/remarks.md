00-set-environment-variables.sh
    Source the file
    get values for cluster essiantials file from: 
    https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/1.7/cluster-essentials/deploy.html
    change export POSTGRES_NAMESPACE in export POSTGRESNAMESPACE


02-install-tanzu-cli
    Installs a bare cli, need to add 'package' and 'secret' plugins:
        tanzu plugin install --group vmware-tap/default:v1.7.4
    Need to install helm
    Need to set cluster credentials for kubectl


# update TAP with new settings in tap-values.yaml
tanzu package installed update tap --package tap.tanzu.vmware.com --version 1.7.4 \
--values-file tap-values.yaml -n tap-install


# Now deploy some apps
tanzu apps workload create --yes -n ns-production -f https://raw.githubusercontent.com/coyte/golang-demo/main/config/workload.yaml
tanzu apps workload create --yes -n ns-production -f https://raw.githubusercontent.com/coyte/nl-tanzu-java-web-app/main/config/workload.yaml
tanzu service class-claim create customer-database --class postgresql-unmanaged -n ns-production
tanzu apps workload create --yes -n ns-production -f https://raw.githubusercontent.com/coyte/nl-java-rest-service/main/config/workload.yaml

To see logs:   "tanzu apps workload tail golang-demo --namespace ns-develop --timestamp --since 1h"
To get status: "tanzu apps workload get golang-demo --namespace ns-develop"



