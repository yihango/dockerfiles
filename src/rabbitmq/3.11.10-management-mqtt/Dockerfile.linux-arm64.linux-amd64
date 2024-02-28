FROM --platform=$TARGETPLATFORM rabbitmq:3.11.10-management
RUN rabbitmq-plugins enable --offline \
    rabbitmq_mqtt \
    rabbitmq_web_mqtt \
    rabbitmq_web_mqtt_examples
    