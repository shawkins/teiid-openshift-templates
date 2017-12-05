#!/bin/sh

JAVA_OPTS=-Xmx16m /opt/jboss/teiid-server/bin/jboss-cli.sh -c --controller=$(hostname -i):9990 "/subsystem=teiid/:execute-query(sql-query=\"select 1\", vdb-name=$1, vdb-version=$2, timeout-in-milli=100)" | grep "\"outcome\" => \"success\""

exit $?
