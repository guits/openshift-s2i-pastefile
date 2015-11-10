FROM docker.io/openshift/base-centos7

MAINTAINER Guillaume Abrioux <guillaume@abrioux.info>

# Set labels used in OpenShift to describe the builder images
LABEL io.openshift.s2i.scripts-url=image:///usr/local/s2i \
      io.k8s.description="pastefile service" \
      io.k8s.display-name="pastefile" \
      io.openshift.expose-services="9000:http" \
      io.openshift.s2i.destination="/tmp/src" \
      io.openshift.tags="builder,html,pastefile"

RUN yum install -y python python-devel python-pip && yum clean all -y && pip install uwsgi && pip install python-magic && pip install flask

COPY ./.s2i/bin/ /usr/local/s2i
COPY ./etc/pastefile.cfg /etc/

# Drop the root user and make the content of /opt/openshift owned by user 1001
RUN mkdir /tmp/src && mkdir /opt/openshift && chown -R 1001:1001 /opt/openshift /tmp/src

# Set the default user for the image, the user itself was created in the base image
USER 1001

# Specify the ports the final image will expose
EXPOSE 9000

# Set the default CMD to print the usage of the image, if somebody does docker run
CMD ["usage"]
