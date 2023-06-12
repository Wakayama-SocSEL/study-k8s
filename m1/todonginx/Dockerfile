FROM nginx:1.25

RUN apt-get update \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*

RUN rm /etc/nginx/conf.d/*
COPY etc/nginx/nginx.conf.tmpl /etc/nginx/
COPY etc/nginx/conf.d/ /etc/nginx/conf.d/

CMD envsubst '$$NGINX_PORT' < /etc/nginx/nginx.conf.tmpl > /etc/nginx/nginx.conf \
  && nginx -g 'daemon off;'
