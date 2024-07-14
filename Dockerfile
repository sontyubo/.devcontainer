FROM eclipse-temurin:17-jdk

RUN apt-get update &&\
    apt-get install -y graphviz

RUN apt update && apt install -y default-jre graphviz fonts-ipafont x11-apps


ENV GRAPHVIZ_DOT=/usr/bin/dot