FROM python:3.9-slim-buster
# one being used

ENV DEBIAN_FRONTEND="noninteractive" TZ="America/New_York"

# Installing apt packages 
#RUN apt-get update && apt-get -y upgrade && apt-get install -y build-essential curl git libbz2-dev libcurl3-dev liblzma-dev libgsl-dev  libncurses5-dev wget zip && apt-get clean && apt-get purge && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update && apt-get -y upgrade && apt-get install -y build-essential curl git libncurses5-dev libbz2-dev liblzma-dev libcurl3-dev libssl-dev
RUN apt-get install -y zlib1g-dev wget zip && apt-get clean && apt-get purge && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Installing pandas
#RUN pip install --upgrade pip
RUN pip install pandas

# install gcloud
RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-400.0.0-linux-x86_64.tar.gz 
RUN tar -xf google-cloud-cli-400.0.0-linux-x86.tar.gz && ./google-cloud-sdk/install.sh
RUN  ./google-cloud-sdk/bin/gcloud init


# install samtoolss
RUN wget 'https://github.com/samtools/samtools/releases/download/1.15.1/samtools-1.15.1.tar.bz2' -O samtools-1.15.1.tar.bz 
RUN tar -xf samtools-1.15.1.tar.bz &&   rm samtools-1.15.1.tar.bz &&   cd samtools-1.15.1 && ./configure && make &&  make install && cd ../ &&   rm -r samtools-1.15.1 
# Don't need the source directory now that we've installed the binary




# Fixing path issues (edit)
ENV PATH="/:${PATH}"