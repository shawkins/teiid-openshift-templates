# Teiid server Docker image

## Adjusting memory

Teiid Docker image automatically scales Java heap (`Xmx` and `Xms`) to memory limitations defined
 CGroups. The default behavior sets it to 50% of the container memory. This is a safe minimum that allows to
 use Teiid with different configuration.

This setting can be easily overridden by specifying `JAVA_OPTIONS` environmental variable with `Xmx` setting.
In that case the automatic scaling scripts will use value specified by the user.

## Configuring authentication

To be able to connect to any of the Teiid server Docker images, authentication is necessary.
The easiest way to create a new user (with specified password) before starting the server is to specify `APP_USER`
and `APP_PASS` environment variables or pass `-au` (for user name) and `-ap` (for password) switches.

Optionally, `APP_ROLES` environment variable (or `-ar` switch) can be passed in which provides specific security roles 
to be associated with the user. The value of this environment variable is expected to be a comma-separated
list of roles for the user.

The management console exposed by the Teiid server Docker images also requires authentication.
In this case, to be able to access the console, `MGMT_USER` and `MGMT_PASS` environment variables
(or `-mu` and `-mp` equivalents) need to be provided. Even if not accessing the console,
these environment properties are required if creating a cluster in the domain mode.

If no application and/or management user and password is specified, the image will generate a new one. A newly 
generated user/password pair will be displayed on the console before the starts up.

Here are some examples on how environment variables can be provided depending on the chosen method to start the image.

Docker run example with environmental variables:

    docker run ... -e "APP_USER=user" -e "APP_PASS=changeme" jboss/teiid-server 

Docker run example with switches:

    docker run ... jboss/teiid-server -au "user" -ap "changeme"

Dockerfile example:

    ENV APP_USER user
    ENV APP_PASS changeme

Kubernetes yaml example:

    spec:
      containers:
      - args:
        image: jboss/teiid-server:...
        ...
        env:
        - name: APP_USER
          value: "user"
        - name: APP_PASS
          value: "changeme"

OpenShift client example:

    oc new-app ... -e "APP_USER=user" -e "APP_PASS=changeme" ...

Finally, it's possible to add more fine grained credentials by invoking `add-user` command once the image has started up:

    docker exec -it $(docker ps -l -q) /opt/jboss/teiid-server/bin/add-user.sh

### Accessing the Server Management Console

The Server Management Console listens on the domain controller on port 9990.
To be able to access the console, credentials need to be provided (see above).

## Source to image (S2I)

The Teiid Docker image uses S2I to supply configuration XML file to the server. The scripts copy content of user directory
into `/opt/jboss/teiid-server/standalone/configuration`. The destination directory can be changed using `CONFIGURATION_PATH`
environmental variable.

The easiest way to run Teiid with custom configuration inside OpenShift is to invoke the following command:

    oc new-app jboss/teiid-server~https://github.com/<username or organization>/<repository with xml in its root>.git

There are special parameters to specify the context directory, branch or SHA1 of the repository. For more information
please refer to [OpenShift S2I manual](https://github.com/openshift/source-to-image).

## Extending the image

    FROM jboss/teiid-server
    # Do your stuff here

Then you can build the image:

    docker build .

## Source

The source is [available on GitHub](https://github.com/jboss-dockerfiles/teiid).

## Issues

Please report any issues or file RFEs on [GitHub](https://github.com/jboss-dockerfiles/teiid/issues).
