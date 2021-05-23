FROM dockeralexandrtalan/java8

ARG HOME=/usr/local/lib
ARG APP=/usr/local/bin
ARG HADOOP_VERSION=hadoop-2.10.1
ARG HADDOP_ARCHIVE=${HADOOP_VERSION}.tar.gz
ARG CLUSTER_NAME=g5_test_cluster

WORKDIR $HOME

RUN wget --no-check-certificate https://www.dropbox.com/s/qfdzagns2sj867n/$HADDOP_ARCHIVE?dl=0 -O $HADDOP_ARCHIVE
RUN tar -xvzf $HADDOP_ARCHIVE
RUN rm -f $HADDOP_ARCHIVE

ENV HADOOP_HOME=$HOME/$HADOOP_VERSION
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$APP
ENV HADOOP_CONFIG=$HADOOP_HOME/etc/hadoop/
ENV HADOOP_PID_DIR=$HADOOP_HOME

RUN echo "Hadoop has been installed:"
RUN hadoop version

RUN hdfs namenode -format $CLUSTER_NAME

COPY ./easy-start.py $APP
COPY ./entrypoint.sh $APP

RUN chmod 777 $APP/easy-start.py
RUN chmod 777 $APP/entrypoint.sh

CMD ["entrypoint.sh"]

