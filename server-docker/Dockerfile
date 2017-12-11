# Use latest jboss/base-jdk:8 image as the base
FROM jboss/base-jdk:8

# Set the JBOSS_HOME env variable
ENV JBOSS_HOME /opt/jboss/teiid-server

# Set the TEIID_VERSION env variable
ENV TEIID_VERSION 10.0.0.Final

# Ensure signals are forwarded to the JVM process correctly for graceful shutdown
ENV LAUNCH_JBOSS_IN_BACKGROUND true

# Server download location
ENV DISTRIBUTION_URL https://oss.sonatype.org/service/local/repositories/releases/content/org/teiid/teiid/$TEIID_VERSION/teiid-$TEIID_VERSION-wildfly-server.zip

# Labels
LABEL name="Teiid Server" \
      version="TEIID_VERSION" \
      release="TEIID_VERSION" \
      architecture="x86_64" \
      io.k8s.description="Provides virtualized access to a variety of sources." \
      io.k8s.display-name="Teiid Server" \
      io.openshift.expose-services="8080:http,31000:mm,35432:pg" \
      io.openshift.tags="virtualization,java,jboss" \
      io.openshift.s2i.scripts-url="image:///usr/local/s2i/bin"

# Download and extract the Teiid Server
USER root

ENV HOME /opt/jboss/

RUN TEIID_SHA=$(curl $DISTRIBUTION_URL.sha1); curl -o /tmp/server.zip $DISTRIBUTION_URL && sha1sum /tmp/server.zip | grep $TEIID_SHA \
    && unzip -q /tmp/server.zip -d $HOME && mv $HOME/teiid-* $JBOSS_HOME && rm /tmp/server.zip \ 
    && chown -R jboss:0 $JBOSS_HOME \
    && chmod -R g+rw $JBOSS_HOME \
    && find $JBOSS_HOME -type d -exec chmod g+x {} +
    
USER jboss

# Copy entrypoint script
COPY docker-entrypoint.sh /usr/local/bin
COPY is_healthy.sh /usr/local/bin
COPY is_running.sh /usr/local/bin
# S2I Scripts
COPY .s2i /usr/local/s2i

# dependencies
COPY ./contrib/wfmodules/ $JBOSS_HOME/modules/

ENTRYPOINT ["docker-entrypoint.sh"]

# Expose Teiid server ports 
EXPOSE 8080 9990 31000 35432
