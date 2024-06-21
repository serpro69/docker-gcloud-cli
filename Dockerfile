FROM gcr.io/google.com/cloudsdktool/google-cloud-cli:debian_component_based
RUN gcloud components install \
    # https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl
    kubectl \
    gke-gcloud-auth-plugin \
    # https://cloud.google.com/docs/terraform/resource-management/export
    config-connector
