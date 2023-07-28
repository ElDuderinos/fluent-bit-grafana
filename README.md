# fluent-bit-grafana
fluent-bit docker monitoring with grafana output

Mainly based on https://github.com/fluent/fluent-bit/issues/1499#issuecomment-682306213
But with Grafana cloud target.

This will get all the docker logs from your docker host and ship them to Grafana Cloud.

Configure these env vars:
* CONTAINERS_PATH - The path to look for the 
* GRAFANA_CLOUD_LOGS_URL - Grafana cloud logs url
* GRAFANA_CLOUD_USER - Numerical Loki cloud logs user id
* GRAFANA_CLOUD_TOKEN - User id's API token.

See https://klaushofrichter.medium.com/migrating-to-grafana-cloud-653dabd5a8b8 as good article with reference for some guidelines on how to get some of those enr vars values.