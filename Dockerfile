FROM multiarch/qemu-user-static:x86_64-aarch64 as qemu
FROM arm64v8/ubuntu
# FROM node:22-bookworm
COPY --from=qemu /usr/bin/qemu-aarch64-static /usr/bin
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y nodejs
RUN apt-get install -y npm
RUN npm install -g corepack
RUN corepack prepare yarn@stable --activate
RUN apt-get install -y emacs-nox vim tmux

RUN apt-get install -y gcc-14-arm-linux-gnueabihf
RUN apt-get install -y gdb
COPY src /xterm

WORKDIR /xterm

# RUN yarn install --frozen-lockfile
RUN yarn install 
RUN npm install node-pty  # not sure if we need this

RUN useradd -m student
ENTRYPOINT node server.js -w /home/student

# to allow gdb to disable address randomization
# docker run --security0opt seccomp=unconfined
