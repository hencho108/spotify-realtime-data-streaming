FROM python:3.8-slim

RUN apt-get update && apt-get install -y wget openjdk-11-jre-headless procps

ENV SPARK_VERSION=3.3.2
ENV HADOOP_VERSION=3
ENV SPARK_URL=https://archive.apache.org/dist/spark
ENV SPARK_HOME=/opt/spark

RUN wget -q $SPARK_URL/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz && \
    tar -xzf spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz -C /opt && \
    rm spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz && \
    mv /opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} ${SPARK_HOME}

RUN pip install pyspark==$SPARK_VERSION

ENV PATH $SPARK_HOME/bin:$PATH

CMD ["bash"]
