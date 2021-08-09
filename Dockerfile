# Source: https://github.com/sclorg/s2i-python-container/tree/master/3.8
FROM registry.access.redhat.com/ubi8/python-38

# Install basic dependencies.
RUN pip install -U "pip>=19.3.1" 

# Add application sources with correct permissions for OpenShift
USER 0
ADD src .
RUN chown -R 1001:0 ./
USER 1001


# Install the dependencies
# Some of these are technically for Django, and are just here to show how to run extra commands.
RUN pip install -r requirements.txt && \
    python app.py collectstatic --noinput && \
    python app.py migrate && \
    yum clean all -y


# Allow Port 8080 from within app.
EXPOSE 8080

# Run the application
CMD python app.py && \
 python -m http.server 8080
