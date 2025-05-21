import time
import paho.mqtt.client as mqtt
from BME280 import BME280


MQTT_BROKER_HOST = "172.25.1.15"
MQTT_BROKER_PORT = 1883
MQTT_TOPIC_NAME = "raspi/temp"


if __name__ == "__main__":
    client = mqtt.Client()
    client.connect(MQTT_BROKER_HOST, MQTT_BROKER_PORT, 60)

    bme280 = BME280()

    while True:
        temperature: float | None = bme280.sensors["temperature"].value

        print(f'Publishing: {temperature}')

        client.publish(MQTT_TOPIC_NAME, temperature)

        time.sleep(1)
