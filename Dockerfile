FROM registry.access.redhat.com/ubi8/python-38

#Allow Port 8080 from within app.
EXPOSE 8080

# Source: https://github.com/sclorg/s2i-python-container/tree/master/3.8
# Add application sources with correct permissions for OpenShift
USER 0
ADD src .
# RUN git clone https://github.com/Terrafire123/sample-python.git

# RUN rm -rf /path/.git
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