FROM debian:testing-slim as config
RUN apt-get update && apt-get install -y deluged psmisc wget
RUN deluged -c /var/lib/deluged/config && sleep 1 && killall deluged
RUN sed -i 's/"allow_remote": false/"allow_remote": true/' /var/lib/deluged/config/core.conf
RUN wget --output-document=/var/lib/deluged/config/plugins/YaRSS2-2.1.4-py3.7.egg https://bitbucket.org/bendikro/deluge-yarss-plugin/downloads/YaRSS2-2.1.4-py3.7.egg

FROM debian:testing-slim

RUN apt-get update \
	&& apt-get full-upgrade -y \
	&& apt-get install -y --no-install-recommends \
		tini \
		deluged \
		ca-certificates \
		python3-idna \
	&& apt-get autoremove -y \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /
COPY --from=config /var/lib/deluged/config/core.conf /configs/
COPY --from=config /var/lib/deluged/config/plugins/ /configs/plugins/
VOLUME /var/lib/deluged/config
EXPOSE 58846/tcp
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/entrypoint.sh"]

LABEL maintainer="imantas.lukenskas@gmail.com"
LABEL deluge-version="2.0.1"
