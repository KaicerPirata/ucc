FROM python:3
RUN  mkdir WORK_REPO
RUN  cd  WORK_REPO
WORKDIR  /WORK_REPO
ADD ./python-docker/hello_world.py .
CMD ["python", "-u", "hello_world.py"]
