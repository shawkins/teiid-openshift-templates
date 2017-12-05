#!/bin/sh

JAVA_OPTS=-Xmx16m /opt/jboss/teiid-server/bin/jboss-cli.sh -c --controller=$(hostname -i):9990 "/subsystem=teiid:get-vdb(vdb-name=$1, vdb-version=$2)" | grep "\"status\" => \"ACTIVE\""

exit $?
