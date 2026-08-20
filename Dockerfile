FROM node:slim
WORKDIR /usr/app/babysleepcoach
EXPOSE 80
COPY ./requirements.txt .
ENV PIP_BREAK_SYSTEM_PACKAGES 1
RUN apt-get update && apt-get install python3-pip libgl1 libglib2.0-0 -y && \
    pip3 install --upgrade pip && \
    pip3 install -r requirements.txt
COPY . .
RUN cd webapp && yarn install && cd ..
WORKDIR /usr/app/babysleepcoach
ENTRYPOINT ["bash", "start_docker.sh"]
