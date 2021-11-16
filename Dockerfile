FROM python:3.8-buster
WORKDIR /usr/src/app

# Install basic dependencies.
RUN apt-get update && \ 
apt-get -y install libgeos-dev && \ 
apt-get clean

ADD src .

# Install the dependencies
# Some of these are technically for Django, and are just here to show how to run extra commands.
# Note: these commands are commented out because they were moved from Build-time to run-time, so
# that we can run them AFTER running git clone.
# RUN pip install -r requirements.txt && \
#    python app.py collectstatic --noinput && \
#    python app.py migrate 


# Allow Port 8080 from within app.
EXPOSE 8080

# Allow our user to have permissions to create and delete files in the default directory.
# See https://docs.openshift.com/container-platform/4.2/openshift_images/create-images.html#use-uid_create-images
RUN chgrp -R 0 /usr/src/app && \
    chmod -R g=u /usr/src/app 

# Run the application
CMD git clone https://${GIT_USERNAME}:${GIT_PASS}@${GIT_URL} gitSrc && \
    cd gitSrc && \ 
    git checkout ${GIT_BRANCH} && \
    cd .. && \ 
    pip install -r requirements.txt && \
    python app.py collectstatic --noinput && \
    python app.py migrate && \
    python app.py && \
    python -m http.server 8080
