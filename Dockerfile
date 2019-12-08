FROM dockeralexandrtalan/java11

ARG HOME=/root
ARG HADOOP_ARHIVE=hadoop-2.9.2.tar.gz

WORKDIR $HOME

RUN wget --no-check-certificate https://www.dropbox.com/s/6tfsqxf60ja3ddx/hadoop-2.9.2.tar.gz?dl=0 -O $HADOOP_ARHIVE
RUN tar -xvzf $HADOOP_ARHIVE
RUN rm -f $HADOOP_ARHIVE

ENV HADOOP_HOME=$HOME/hadoop-2.9.2
ENV PATH=$PATH:$HADOOP_HOME/bin

RUN echo "Hadoop has been installed:"
RUN hadoop version

CMD ["/bin/bash"]

