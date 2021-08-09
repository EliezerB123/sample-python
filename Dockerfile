FROM python:3.8-buster
WORKDIR /usr/src/app

# Install basic dependencies.
RUN apt-get update && \ 
apt-get -y install libgeos-dev && \ 
apt-get clean

ADD src .

# Install the dependencies
# Some of these are technically for Django, and are just here to show how to run extra commands.
RUN pip install -r requirements.txt && \
    python app.py collectstatic --noinput && \
    python app.py migrate 


# Allow Port 8080 from within app.
EXPOSE 8080

# Run the application
CMD python app.py && \
 python -m http.server 8080
