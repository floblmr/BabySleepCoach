FROM node:18-slim AS frontend-builder
WORKDIR /usr/app/babysleepcoach/webapp
COPY ./webapp/package.json ./webapp/yarn.lock ./
RUN yarn install --frozen-lockfile
COPY ./webapp .
ENV REACT_APP_BACKEND_IP=192.168.178.117:8101
ENV REACT_APP_RESOURCE_SERVER_IP=192.168.178.117:8100
RUN yarn build

FROM node:18-slim
WORKDIR /usr/app/babysleepcoach
ENV PIP_BREAK_SYSTEM_PACKAGES=1
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-setuptools \
    libgl1 \
    libglib2.0-0 \
    && npm install -g serve \
    && rm -rf /var/lib/apt/lists/*
COPY ./requirements.txt .
RUN pip3 install -r requirements.txt
COPY . .
COPY --from=frontend-builder /usr/app/babysleepcoach/webapp/build ./webapp/build
EXPOSE 80 3000 8001
CMD ["sh", "-c", "python3 -m http.server 3000 --directory webapp/build & python3 main.py"]
