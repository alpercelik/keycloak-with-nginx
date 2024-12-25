FROM alpine/curl:latest AS digicert

WORKDIR /app
RUN curl https://dl.cacerts.digicert.com/DigiCertGlobalRootCA.crt.pem -o DigiCertGlobalRootCA.crt.pem

FROM quay.io/keycloak/keycloak:latest AS builder

ENV KC_DB=postgres

WORKDIR /opt/keycloak
# for demonstration purposes only, please make sure to use proper certificates in production instead
RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore conf/server.keystore
RUN /opt/keycloak/bin/kc.sh build --health-enabled=true

FROM quay.io/keycloak/keycloak:latest

# Copy Keycloak files from the builder stage
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Copy custom theme files into Keycloak
COPY ./themes/ /opt/keycloak/themes/

# Copy the DigiCert root CA certificate for secure connections
COPY --from=digicert /app/DigiCertGlobalRootCA.crt.pem /opt/keycloak/.postgresql/root.crt

# Uncomment the following lines to modify Keycloak configuration for caching and static max age
# RUN sed -i -E "s/(<staticMaxAge>)2592000(<\/staticMaxAge>)/\1\-1\2/" /opt/jboss/keycloak/standalone/configuration/standalone.xml
# RUN sed -i -E "s/(<cacheThemes>)true(<\/cacheThemes>)/\1false\2/" /opt/jboss/keycloak/standalone/configuration/standalone.xml
# RUN sed -i -E "s/(<cacheTemplates>)true(<\/cacheTemplates>)/\1false\2/" /opt/jboss/keycloak/standalone/configuration/standalone.xml

# Uncomment the following lines to modify HA configuration if needed
# RUN sed -i -E "s/(<staticMaxAge>)2592000(<\/staticMaxAge>)/\1\-1\2/" /opt/jboss/keycloak/standalone/configuration/standalone-ha.xml
# RUN sed -i -E "s/(<cacheThemes>)true(<\/cacheThemes>)/\1false\2/" /opt/jboss/keycloak/standalone/configuration/standalone-ha.xml
# RUN sed -i -E "s/(<cacheTemplates>)true(<\/cacheTemplates>)/\1false\2/" /opt/jboss/keycloak/standalone/configuration/standalone-ha.xml

# Set the entry point for the Keycloak server
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]

# Expose the necessary ports
EXPOSE 8080
