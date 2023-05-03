#
# Build an Ubuntu installation of pycsep
#
from ubuntu:jammy
MAINTAINER Fabil Silva fsilva@usc.edu

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles

RUN apt-get update && apt-get -y upgrade \
  && apt-get install -y --no-install-recommends \
    git \
    wget \
    g++ \
    jupyter \
    libproj-dev proj-data proj-bin libgeos-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3 /usr/bin/python

# Define Build and runtime arguments
# These accept userid and groupid from the command line
ARG APP_UNAME
ARG APP_GRPNAME
ARG APP_UID
ARG APP_GID
ARG BDATE

ENV APP_UNAME=$APP_UNAME \
APP_GRPNAME=$APP_GRPNAME \
APP_UID=$APP_UID \
APP_GID=$APP_GID \
BDATE=$BDATE

# Retrieve the userid and groupid from the args so 
# Define these parameters to support building and deploying on EC2 so user is not root
# and for building the model and adding the correct date into the label
RUN echo $APP_UNAME $APP_GRPNAME $APP_UID $APP_GID $BDATE

# Setup Owners
# Group add duplicates "staff" so just continue if it doesn't work
RUN groupadd -f --non-unique --gid $APP_GID $APP_GRPNAME
RUN useradd -ms /bin/bash -G $APP_GRPNAME --uid $APP_UID $APP_UNAME

#Define interactive user
USER $APP_UNAME

# Move to the user directory where the gmsvtoolkit is installed and built

ENV PATH="/home/$APP_UNAME/miniconda3/bin:${PATH}"
ARG PATH="/home/$APP_UNAME/miniconda3/bin:${PATH}"

WORKDIR /home/$APP_UNAME

RUN wget  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /home/$APP_UNAME/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh \
    && echo "Running $(conda --version)" \
    && conda update conda \
    && conda create -n csep-dev \
    && conda init bash

RUN echo 'conda activate csep-dev' >> /home/$APP_UNAME/.bashrc \
    && bash /home/$APP_UNAME/.bashrc \
    && conda install python=3.10 pip numpy notebook

RUN conda install -c conda-forge jupyterlab jupyterhub

WORKDIR /home/$APP_UNAME
RUN git clone https://github.com/SCECcode/pycsep.git
WORKDIR /home/$APP_UNAME/pycsep
RUN pip install -e .

WORKDIR /home/$APP_UNAME
RUN git clone https://github.com/cseptesting/pycsep_workshop_rise21.git
RUN mv /home/$APP_UNAME/pycsep_workshop_rise21 /home/$APP_UNAME/scec_workshop
RUN rm -R /home/$APP_UNAME/scec_workshop/organizational
# Define file input/output mounted disk
#
#
# Add metadata to dockerfile using labels
LABEL "org.scec.project"="pycsep"
LABEL org.scec.responsible_person="Fabio Silva"
LABEL org.scec.primary_contact="maechlin@usc.edu"
LABEL version="$BDATE"

#
# Start Jupyter notebook

ENTRYPOINT ["/usr/bin/jupyter","lab","--ip=0.0.0.0","--notebook-dir=/home/csepuser/scec_workshop/tutorials","--allow-root","--no-browser"]
#CMD ["/bin/bash"]
