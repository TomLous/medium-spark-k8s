# Information
# Main Spark Docker file code: https://github.com/apache/spark/blob/master/resource-managers/kubernetes/docker/src/main/dockerfiles/spark/Dockerfile

ARG SPARK_IMAGE=gcr.io/spark-operator/spark:v2.4.4
FROM ${SPARK_IMAGE}

ARG VERSION
ARG VCS_REF
ARG BUILD_DATE

ENV SCALA_VERSION 2.12
ENV SPARK_VERSION 2.4.5
ENV HADOOP_VERSION 3.2.1
ENV KUBERNETES_CLIENT_VERSION 4.6.4
ENV JMX_PROMETHEUS_VERSION 0.12.0



ENV REPO_URL https://repo1.maven.org/maven2
ENV ARCHIVE_URL http://archive.apache.org/dist

# Adhere to opencontainers image spec https://github.com/opencontainers/image-spec/blob/master/annotations.md
LABEL org.opencontainers.image.title="graphiq-spark-runner" \
      org.opencontainers.image.created=${BUILD_DATE} \
      org.opencontainers.image.description="base image for Scala  Spark jobs that need to run on kubernetes via the spark-operator" \
      org.opencontainers.image.source="https://github.com/TomLous/medium-spark-k8s" \
      org.opencontainers.image.documentation="https://github.com/TomLous/medium-spark-k8s/blob/master/README.md" \
      org.opencontainers.image.revison=${VCS_REF} \
      org.opencontainers.image.vendor="GraphIQ" \
      org.opencontainers.image.version=${VERSION} \
      org.opencontainers.image.authors="Tom Lous <tomlous@gmail.com>" \
      version.scala=${SCALA_VERSION} \
      version.spark=${SPARK_VERSION} \
      version.hadoop=${HADOOP_VERSION} \
      version.kubernetes-client=${KUBERNETES_CLIENT_VERSION}

# Install Tools
RUN apk --no-cache add curl

# Hadoop Config
ENV HADOOP_HOME "/opt/hadoop"
RUN rm -rf ${HADOOP_HOME}/ \
    && cd /opt \
    && curl -sL --retry 3 "${ARCHIVE_URL}/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz" | tar xz  \
    && chown -R root:root hadoop-${HADOOP_VERSION} \
    && ln -sfn hadoop-${HADOOP_VERSION} hadoop \
    && rm -rf ${HADOOP_HOME}/share/doc \
    && find /opt/ -name *-sources.jar -delete
ENV PATH="${HADOOP_HOME}/bin:${PATH}"
ENV HADOOP_CONF_DIR "${HADOOP_HOME}/etc/hadoop"

# Spark Config
# Since the conf/ folder gets mounted over by the spark-operator we move the spark-env.sh to another folder to be sourced in the entrypoint.sh. No good solution exists to merge the original conf folder with the volumeMount
RUN rm -rf ${SPARK_HOME}/ \
    && cd /opt \
    && curl -sL --retry 3 "${ARCHIVE_URL}/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop-scala-${SCALA_VERSION}.tgz" | tar xz  \
    && mv spark-${SPARK_VERSION}-bin-without-hadoop-scala-${SCALA_VERSION} spark-${SPARK_VERSION} \
    && chown -R root:root spark-${SPARK_VERSION} \
    && ln -sfn spark-${SPARK_VERSION} spark \
    && mkdir -p ${SPARK_HOME}/conf-org/ \
    && mv ${SPARK_HOME}/conf/spark-env.sh.template ${SPARK_HOME}/conf-org/spark-env.sh \
    && rm -rf ${SPARK_HOME}/examples  ${SPARK_HOME}/data ${SPARK_HOME}/tests ${SPARK_HOME}/conf  \
    && echo 'export SPARK_DIST_CLASSPATH=$(hadoop classpath)' >> ${SPARK_HOME}/conf-org/spark-env.sh \
    && echo 'export SPARK_EXTRA_CLASSPATH=$(hadoop classpath)' >> ${SPARK_HOME}/conf-org/spark-env.sh

ENV PATH="${SPARK_HOME}/bin:${PATH}"

# Add Prometheus metrics (like: https://github.com/GoogleCloudPlatform/spark-on-k8s-operator/blob/master/spark-docker/Dockerfile)
RUN mkdir -p /etc/metrics/conf
RUN mkdir -p /prometheus
ADD ${REPO_URL}/io/prometheus/jmx/jmx_prometheus_javaagent/${JMX_PROMETHEUS_VERSION}/jmx_prometheus_javaagent-${JMX_PROMETHEUS_VERSION}.jar /prometheus/jmx_prometheus_javaagent.jar
COPY conf/metrics.properties /etc/metrics/conf
COPY conf/prometheus.yaml /etc/metrics/conf


# Kubernetes Client  <= TODO Remove when this issue is fixed https://andygrove.io/2019/08/apache-spark-regressions-eks/
RUN rm -rf ${SPARK_HOME}/jars/kubernetes-*.jar
ADD ${REPO_URL}/io/fabric8/kubernetes-client/${KUBERNETES_CLIENT_VERSION}/kubernetes-client-${KUBERNETES_CLIENT_VERSION}.jar ${SPARK_HOME}/jars
ADD ${REPO_URL}/io/fabric8/kubernetes-model/${KUBERNETES_CLIENT_VERSION}/kubernetes-model-${KUBERNETES_CLIENT_VERSION}.jar ${SPARK_HOME}/jars
ADD ${REPO_URL}/io/fabric8/kubernetes-model-common/${KUBERNETES_CLIENT_VERSION}/kubernetes-model-common-${KUBERNETES_CLIENT_VERSION}.jar ${SPARK_HOME}/jars

# Edit entrypoint to source spark-env.sh before running spark-submit
RUN sed -i '30i #CUSTOM\n' /opt/entrypoint.sh \
    && sed -i '/#CUSTOM/a source ${SPARK_HOME}/conf-org/spark-env.sh\n' /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]