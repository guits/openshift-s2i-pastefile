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

RUN mkdir /tmp/src && mkdir /tmp/pastefile && mkdir /tmp/pastefile/files && mkdir /tmp/pastefile/tmp && mkdir /opt/openshift && chmod -R 777 /opt/openshift /tmp/src /tmp/pastefile

USER 1001

EXPOSE 9000
