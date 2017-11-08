eval $(minishift docker-env)
docker build -t teiid-server:10.0.0.Final .
docker tag teiid-server:10.0.0.Final $(minishift openshift registry)/myproject/teiid-server:10.0.0.Final
docker login -u developer -p $(oc whoami -t) $(minishift openshift registry)
docker push $(minishift openshift registry)/myproject/teiid-server:10.0.0.Final
