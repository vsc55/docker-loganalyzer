FROM vsc55/apache:php-5.6

LABEL version="1.0" maintainer="vsc55@cerebelum.net" description="Docker webapp loganalyzer"

COPY --chown=root:root ["rootfs", "/"]

#Fix, hub.docker.com auto buils
RUN chmod +x /*.sh; \
    chown root:root /*.sh; \
    chown root:root /data -R; \
    chown root:root /data_default -R; \
    chown www-data:www-data /var/www/html -R

WORKDIR /var/www/html

HEALTHCHECK --interval=5s --timeout=3s --start-period=20s CMD /health_check.sh

ENV TZ=Europe/Madrid
ENV HTTP_PORT=80

EXPOSE ${HTTP_PORT}/tcp

VOLUME ["/data"]

ENTRYPOINT ["/entrypoint.sh"]
CMD ["start"]
