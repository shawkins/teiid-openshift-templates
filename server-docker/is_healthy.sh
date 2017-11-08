#!/bin/sh

JAVA_OPTS=-Xmx16m /opt/jboss/teiid-server/bin/jboss-cli.sh -c --controller=$(hostname -i):9990 '/subsystem=teiid/health=HEALTH:read-attribute(name=cluster-health)' | grep HEALTHY

exit $?
