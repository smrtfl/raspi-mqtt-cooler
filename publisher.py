import time
import paho.mqtt.client as mqtt
from BME280 import BME280


BROKER_HOST = "172.25.1.15"
MQTT_TOPIC_NAME = "172.25.1.15"


if __name__ == "__main__":
    client = mqtt.Client()
    client.connect("172.25.1.15", 1883, 60)

    bme280 = BME280()

    while True:
        temperature: float | None = bme280.sensors["temperature"].value

        print(f'Publishing: {temperature}')

        client.publish(MQTT_TOPIC_NAME, temperature)

        time.sleep(1)
