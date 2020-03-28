ARG AIRFLOW_VERSION=1.10.9

FROM puckel/docker-airflow:$AIRFLOW_VERSION
ARG AIRFLOW_VERSION

USER root
# Add apache-airflow kubernetes package for Kubernetes Executor
RUN pip install apache-airflow[kubernetes]==${AIRFLOW_VERSION}
# https://github.com/puckel/docker-airflow/issues/521
RUN sed -i '/kube_client_request_args/c kube_client_request_args = {"_request_timeout" : [60,60] }' airflow.cfg
# Add Airflow exporter for Prometheus metrics https://github.com/epoch8/airflow-exporter
RUN pip install airflow-exporter==1.3.0

USER airflow
WORKDIR ${AIRFLOW_HOME}

COPY example/tuto.py dags/tuto.py

ENTRYPOINT ["/entrypoint.sh"]
CMD ["webserver"]
