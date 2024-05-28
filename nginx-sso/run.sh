sed -i s/__KEYCLOAK_SECRET__/${KEYCLOAK_SECRET}/g /etc/nginx/conf.d/default.conf
sed -i s/__KEYCLOAK_CLIENT_ID__/${KEYCLOAK_CLIENT_ID}/g /etc/nginx/conf.d/default.conf
sed -i s/__KEYCLOAK_URL__/${KEYCLOAK_URL}/g /etc/nginx/conf.d/default.conf
sed -i s/__RSTUDIO_URL__/${RSTUDIO_URL}/g /etc/nginx/conf.d/default.conf
sed -i s/__SCOPE__/${SCOPE}/g /etc/nginx/conf.d/default.conf

/usr/local/openresty/nginx/sbin/nginx -g "daemon off;"