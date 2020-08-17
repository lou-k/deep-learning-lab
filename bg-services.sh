#!/bin/bash
set -e

echo 'Starting Tensorboard with default arguments... (6006)'
screen -dmS tensorboard tensorboard --logdir data/06_models

echo 'Starting mlflow on 0.0.0.0:5000'
screen -dmS mlflow mlflow ui -h 0.0.0.0

echo 'Starting jupyter w/ kedro on 0.0.0.0:8888'
screen -dmS jupyter kedro jupyter notebook --allow-root  --ip 0.0.0.0 --no-browser

exec /bin/bash