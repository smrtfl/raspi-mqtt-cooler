import time
import paho.mqtt.client as mqtt
from BME280 import BME280


MQTT_BROKER_PORT = 1883
MQTT_TOPIC_NAME = "raspi/bme280"


if __name__ == "__main__":
    mqtt_broker_host = input("MQQT broker host: ")

    client = mqtt.Client()
    client.connect(mqtt_broker_host, MQTT_BROKER_PORT, 60)

    bme280 = BME280()

    while True:
        temperature: float | None = bme280.sensors["temperature"].value

        print(f'Publishing: {temperature}')

        client.publish(MQTT_TOPIC_NAME, temperature)

        time.sleep(1)
