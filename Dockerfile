FROM dockeralexandrtalan/java11

ARG HOME=/usr/local/lib
ARG APP=/usr/local/bin
ARG HADOOP_ARHIVE=hadoop-2.9.2.tar.gz
ARG CLUSTER_NAME=hdfs_cluster

WORKDIR $HOME

RUN apt install -y  python3
RUN wget --no-check-certificate https://www.dropbox.com/s/6tfsqxf60ja3ddx/hadoop-2.9.2.tar.gz?dl=0 -O $HADOOP_ARHIVE
RUN tar -xvzf $HADOOP_ARHIVE
RUN rm -f $HADOOP_ARHIVE

ENV HADOOP_HOME=$HOME/hadoop-2.9.2
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

