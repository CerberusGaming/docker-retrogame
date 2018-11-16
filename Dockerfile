FROM openjdk:latest

RUN apt-get update \
    && apt-get -y install git maven gcc build-essential cmake

WORKDIR /usr/src/ogame

RUN git clone https://github.com/retro-game/retro-game.git .

RUN mkdir build \
    && cd build \
	&& cmake -DCMAKE_BUILD_TYPE=Release ../battle-engine \
	&& make \
	&& cd /usr/src/ogame \

RUN ls -lah
	
RUN mvn package \
	&& mv /usr/src/ogame/target/*.jar /usr/src/ogame/server.jar

RUN mkdir lib \
	&& mv build/libBattleEngine.so lib \
	&& mv config/application.properties .application.properties.default

RUN rm -rf build/ target/ src/ etc/ battle-engine/ \
	&& apt-get remove --purge -y --allow-remove-essential git maven gcc build-essential cmake \
	&& apt-get remove --purge -y --allow-remove-essential $BUILD_PACKAGES $(apt-mark showauto) \
	&& rm -rf /var/lib/apt/lists/*

VOLUME /usr/src/ogame/config
	
COPY entrypoint.sh /usr/src/ogame/entrypoint.sh

EXPOSE 8080/tcp

ENTRYPOINT ['entrypoint.sh']
CMD ['/usr/bin/java', '-Djava.library.path=lib', '-jar', 'server.jar']
