00-set-environment-variables.sh
    don't execute, but source the file
    get values for cluster essiantials file from: 
    https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/1.7/cluster-essentials/deploy.html
    change export POSTGRES_NAMESPACE in export POSTGRESNAMESPACE


02-install-tanzu-cli
    Installs a bare cli, need to add 'package' and 'secret' plugins:
        tanzu plugin install --group vmware-tap/default:v1.7.4
    Need to install helm
    Need to set cluster credentials for kubectl


