FROM gcr.io/google.com/cloudsdktool/google-cloud-cli:debian_component_based
RUN gcloud components install \
    kubectl \
    gke-gcloud-auth-plugin
