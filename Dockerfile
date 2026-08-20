FROM node:18-slim
WORKDIR /usr/app/babysleepcoach
EXPOSE 80
COPY ./requirements.txt .
ENV PIP_BREAK_SYSTEM_PACKAGES=1
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-setuptools \
    libgl1 \
    libglib2.0-0 && \
    pip3 install -r requirements.txt
COPY . .
RUN cd webapp && yarn install && cd ..
WORKDIR /usr/app/babysleepcoach
ENTRYPOINT ["bash", "start_docker.sh"]
