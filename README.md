https://docs.openshift.com/container-platform/4.8/cicd/builds/build-strategies.html



Notes:
We changed a few lines in requirements.txt:
1.
pandas==1.2.0 to pandas==1.1.5
(Pandas 1.1.5 is the latest available version in Openshift's PIP repository.)

2.
Removed pkg-resources==0.0.0
This appears as a bug, as per https://stackoverflow.com/questions/39577984/what-is-pkg-resources-0-0-0-in-output-of-pip-freeze-command

3.
pyproj==3.0.0.post1 requires us to update PIP to version >=10.0.1 as per https://github.com/pyproj4/pyproj/issues/177
so we update pip via the environment variable 
UPGRADE_PIP_TO_LATEST = true
set in the Edit Application ( https://console.pro-us-east-1.openshift.com/console/project/fatfish-test/edit/dc/test-python-server )

4.
Rtree==0.9.4 to Rtree>=0.9.4 
(Rtree 0.9.7 resolves correctly, 0.9.4 fails to compile.)

This is a known issue:
https://github.com/Toblerity/rtree/issues/64
sudo apt install libspatialindex-dev python3-rtree

5. 
Renamed starting python file to app.py

Creating an s2i build image:
https://cloud.redhat.com/blog/create-s2i-builder-image

Openshift provides images for starting points at:
https://hub.docker.com/r/openshift/origin-custom-docker-builder


Commands:
1. sudo snap install docker
2. sudo docker pull registry.access.redhat.com/ubi8/python-38
3. Go to https://console.redhat.com/openshift/downloads and download and install OC
4. Create a dockerfile with the following code:

/*-------------------------------*/
FROM registry.access.redhat.com/ubi8/python-38

#Allow Port 8080 from within app.
EXPOSE 8080

# Add application sources with correct permissions for OpenShift
USER 0
# ADD src .
RUN go get https://github.com/Terrafire123/sample-python.git

RUN chown -R 1001:0 ./
USER 1001


# Install the dependencies
# Some of these are technically for Django, and are just here to show how to run extra commands.
RUN pip install -U "pip>=19.3.1" && \
    pip install -r requirements.txt && \
    python app.py collectstatic --noinput && \
    python app.py migrate && \
    yum clean all -y

# Run the application
CMD python app.py
/*-----------------------------*/
5. Put your code (app.py, requirements.txt) into a new folder called "src"

6. Test locally using:
sudo docker build -t mycontainer .
7. 
# Build from command line
https://dzone.com/articles/4-ways-to-build-applications-in-openshift-1
6a. cat build.Dockerfile | oc new-build --name fatfish-test --dockerfile='-'
6b. oc start-build  dc/test-python-server -n fatfish-test  --follow


# Image stream list

>Menu > Builds > Images > Name-of-server(test-python-server)
https://console.pro-us-east-1.openshift.com/console/project/fatfish-test/browse/images/test-python-

# How to push new images to internal Openshift Registery
https://cookbook.openshift.org/image-registry-and-image-streams/how-do-i-push-an-image-to-the-internal-image-registry.html
https://console.pro-us-east-1.openshift.com/console/about


docker push registry.pro-us-east-1.openshift.com/fatfish-test/test-python-server:v1.0.1


sudo docker tag myimage registry.pro-us-east-1.openshift.com/fatfish-test/test-python-server:v1.0.1
sudo docker push registry.pro-us-east-1.openshift.com/fatfish-test/test-python-server


# sudo docker push registry.pro-us-east-1.openshift.com/fatfish-test/test-python-server:v1.0.1
# sudo docker push docker-registry.default.svc:5000/fatfish-test/test-python-server:v1.0.1


# Push an image directly onto the app
https://console.pro-us-east-1.openshift.com/console/project/fatfish-test/browse/images/test-python-server

 sudo docker image build -t myimage .
 sudo docker tag myimage registry.pro-us-east-1.openshift.com/fatfish-test/test-python-server:v1.0.1
 sudo docker push registry.pro-us-east-1.openshift.com/fatfish-test/test-python-server
 oc login https://api.pro-us-east-1.openshift.com --token=s3JycdBv-JDaQQRj5e-TkEDU9Yb2edgAMpUfPG5PAsg
# sudo docker login registry.pro-us-east-1.openshift.com -u urbandev -p Urban123

cat ./password | docker login registry.pro-us-east-1.openshift.com --username urbandev --password-stdin


1. Download OC and Log into openshift using this:
 Get login token: https://console.pro-us-east-1.openshift.com/console/command-line

2. 


https://docs.openshift.com/container-platform/4.8/cli_reference/openshift_cli/developer-cli-commands.html
  # Create a build config using a Dockerfile specified as an argument
  oc new-build -D $'FROM centos:7\nRUN yum install -y httpd'

    # Create an application based on the source code in the current git repository (with a public remote) and a Docker image
  oc new-app . --docker-image=registry/repo/langimage