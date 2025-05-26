# raspi-mqtt-cooler

Automatic cooler controller based on BME280 environmental sensor's readings.

## Getting Started

For this setup, you would need a device to run a MQQT broker, publisher and subscriber (can be run on a single device).

1. Start the MQTT broker

```sh
./mqtt-broker.sh start
```

2. Setup python virtual environment (if needed)

```sh
python -m venv venv/
source venv/bin/activate
```

3. Start the MQTT Publisher

```sh
python src/publisher.py
```

or MQTT Subscriber

```sh
python src/publisher.py
```
