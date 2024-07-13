FROM eclipse-temurin:17-jdk

RUN apt-get update &&\
    apt-get install -y graphviz

RUN apt update && apt install -y default-jre graphviz fonts-ipafont


ENV GRAPHVIZ_DOT=/usr/bin/dot