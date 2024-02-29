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


# update TAP with new settings in tap-values.yaml
tanzu package installed update tap --package tap.tanzu.vmware.com --version 1.7.4 \
--values-file tap-values.yaml -n tap-install


# feedback from pg instaall
helm install postgresql bitnami/postgresql -n "$POSTGRES_NAMESPACE" --set global.postgresql.auth.postgresPassword="$POSTGRES_ADMIN_PASSWORD" --set global.postgresql.auth.username="$POSTGRES_USERNAME" --set global.postgresql.auth.password="$POSTGRES_USERPASSWORD"

NAME: postgresql
LAST DEPLOYED: Thu Feb 29 10:03:13 2024
NAMESPACE: tanzu-postgres
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: postgresql
CHART VERSION: 14.2.1
APP VERSION: 16.2.0

** Please be patient while the chart is being deployed **

PostgreSQL can be accessed via port 5432 on the following DNS names from within your cluster:

    postgresql.tanzu-postgres.svc.cluster.local - Read/Write connection

To get the password for "postgres" run:

    export POSTGRES_ADMIN_PASSWORD=$(kubectl get secret --namespace tanzu-postgres postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)

To get the password for "tapgui" run:

    export POSTGRES_PASSWORD=$(kubectl get secret --namespace tanzu-postgres postgresql -o jsonpath="{.data.password}" | base64 -d)

To connect to your database run the following command:

    kubectl run postgresql-client --rm --tty -i --restart='Never' --namespace tanzu-postgres --image docker.io/bitnami/postgresql:16.2.0-debian-12-r4 --env="PGPASSWORD=$POSTGRES_PASSWORD" \
      --command -- psql --host postgresql -U tapgui -d postgres -p 5432

    > NOTE: If you access the container using bash, make sure that you execute "/opt/bitnami/scripts/postgresql/entrypoint.sh /bin/bash" in order to avoid the error "psql: local user with ID 1001} does not exist"

To connect to your database from outside the cluster execute the following commands:

    kubectl port-forward --namespace tanzu-postgres svc/postgresql 5432:5432 &
    PGPASSWORD="$POSTGRES_PASSWORD" psql --host 127.0.0.1 -U tapgui -d postgres -p 5432

WARNING: The configured password will be ignored on new installation in case when previous PostgreSQL release was deleted through the helm command. In that case, old PVC will have an old password, and setting it through helm won't take effect. Deleting persistent volumes (PVs) will solve the issue.

WARNING: There are "resources" sections in the chart not set. Using "resourcesPreset" is not recommended for production. For production installations, please set the following values according to your workload needs:
  - primary.resources
  - readReplicas.resources
+info https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/

