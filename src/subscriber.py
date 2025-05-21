import paho.mqtt.client as mqtt
import subprocess
from enum import Enum


MQTT_BROKER_HOST = 'localhost'
MQTT_TOPIC_NAME = 'raspi/bme280'
TEMPERATURE_THRESHOLD = 25.0
GPIOPIUM_SCRIPT_PATH = '~/gpiopium/gpiopium.sh'
FAN_GPIO_PIN = '17'


class FanState(Enum):
    ON = 'high'
    OFF = 'low'


current_fan_state = FanState.OFF


def on_connect(client, userdata, flags, rc):
    print(f"Connected to broker with result code: {rc}")
    client.subscribe(MQTT_TOPIC_NAME)


def on_message(client, userdata, msg):
    try:
        value = float(msg.payload.decode())

        print(f"Received value: {value}")

        if value > TEMPERATURE_THRESHOLD and current_fan_state == FanState.OFF:
            set_fan_state(FanState.ON)
        elif value <= TEMPERATURE_THRESHOLD and current_fan_state == FanState.ON:
            set_fan_state(FanState.OFF)
    except ValueError:
        print("Received non-numeric value in message.")
    except Exception as e:
        print(f"Error processing message: {e}")


def set_fan_state(fan_state: FanState):
    global current_fan_state

    command = [GPIOPIUM_SCRIPT_PATH, fan_state.value, FAN_GPIO_PIN]
    subprocess.call(command)

    current_fan_state = fan_state

    print(f"Fan state set to: {fan_state.value}")


if __name__ == "__main__":
    client = mqtt.Client()

    client.on_connect = on_connect
    client.on_message = on_message

    client.connect(MQTT_BROKER_HOST, 1883, 60)
    client.loop_forever()
