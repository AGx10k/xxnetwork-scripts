#!/bin/bash
### source: https://github.com/AGx10k/xxnetwork-scripts
### usage:
### $0 yournode
### for example:
### $0 AGx1
### then - monitor 'xxnetwork_monit_COMPLETED_timestamp{xxnetwork_account_name="yournode"}' metric in prometheus

TEXTFILE_COLLECTOR_DIR=/var/lib/prometheus/node-exporter
FILENAME=xxnetwork_monit.prom
metrics_prefix=xxnetwork_monit
xxnetwork_account_name="$1"

COMPLETED_timestamp=$(date --date="$(cat /opt/xxnetwork/node-logs/node.log  | grep "Updating to COMPLETED" | tail -n 1 | cut -c6-24 )" +"%s")
ERROR_timestamp=$(date --date="$(cat /opt/xxnetwork/node-logs/node.log  | grep "Updating to ERROR" | tail -n 1 | cut -c6-24 )" +"%s")

cat << EOF > "$TEXTFILE_COLLECTOR_DIR/$FILENAME.$$"

# HELP ${metrics_prefix}_COMPLETED_timestamp Latest string COMPLETED in node.log
# TYPE ${metrics_prefix}_COMPLETED_timestamp counter
${metrics_prefix}_COMPLETED_timestamp{account="${xxnetwork_account_name}"} ${COMPLETED_timestamp}

# HELP ${metrics_prefix}_ERROR_timestamp Latest ERROR in node.log
# TYPE ${metrics_prefix}_ERROR_timestamp counter
${metrics_prefix}_ERROR_timestamp{account="${xxnetwork_account_name}"} ${ERROR_timestamp}

EOF

mv "$TEXTFILE_COLLECTOR_DIR/$FILENAME.$$" "$TEXTFILE_COLLECTOR_DIR/$FILENAME"
