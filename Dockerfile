# FROM nytimes/blender:2.82-gpu-ubuntu18.04
FROM nytimes/blender:latest

# This works perfectly.. except that Openshift won't let us change to the user "Docker".
# # Install SUDO
# RUN apt-get update \
#  && apt-get install -y sudo
#
# # Create a new user named "Docker".
# RUN adduser --disabled-password --gecos '' docker
#
# # Add the user "Docker" to the sudo group.
# RUN adduser docker sudo
#
# # Make user "Docker" not require a password to sudo.
# RUN echo 'docker ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
#
# # Switch to our new user named "Docker".
# USER docker

WORKDIR /usr/src/app

# Install basic dependencies.
RUN apt-get update && \ 
    apt-get -y install libgeos-dev && \ 
    apt-get clean
    # pip install --upgrade pip && \
    # pip install wheel

ADD src .

# Add symbolic link for the Python installed on the system.
RUN ln -sf /bin/3.0/python/bin/python3.9 /usr/bin/python3

# Install the dependencies
# Some of these are technically for Django, and are just here to show how to run extra commands.
# Note: these commands are commented out because they were moved from Build-time to run-time, so
# that we can run them AFTER running git clone.
# RUN pip install -r requirements.txt && \
#    python3 app.py collectstatic --noinput && \
#    python3 app.py migrate 


# Allow Port 8080 from within app.
EXPOSE 8080

# Allow our user to have permissions to create and delete files in the default directory.
# See https://docs.openshift.com/container-platform/4.2/openshift_images/create-images.html#use-uid_create-images
RUN chgrp -R 0 /usr/src/app && \
    chmod -R g=u /usr/src/app 

# Give our user ownership of all files inside the working directory.
# RUN sudo chown docker:root -R /usr/src/app
RUN chmod -R 775 /usr/src/app

# Run the application
# Here we immediately first create a directory to verify we have write permissions.
# If that succeeds, then we continue with the Blender.
CMD mkdir checkPermissions && pwd && ls -la && \
    python3 app.py && \
    # blender --background -noaudio ./light-work.blend --render-output //output/render_ -F PNG -E CYCLES --frame-start 2 --frame-end 3 --render-anim && \
    blender --background -noaudio --python ./blenderGit/scripts/AllScripts.py && \
    python3 app.py && \
    python3 -m http.server 8080
