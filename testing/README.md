# How setup environment
1. `sudo pip install virtualenv`
2. `mkdir -p ~/.venv/rancher-scaling`
3. `virtualenv -p python3 ~/.venv/rancher-scaling`
4. `source ~/.venv/rancher-scaling/bin/activate`
5. `pip install -r requirements.txt`
6. `deactivate`
# How to use
1. `source ~/.venv/rancher-scaling/bin/activate`
2. set environment variable "RANCHER_SCALING_URL" to rancher url.
3. set environment variable "RANCHER_SCALING_TOKEN" to rancher token.
4. run `python testbench.py`.
5. (optional) can run `jupyter notebook` and select "Scaling Summary".
6. (when done) `deactivate`
# Options
### There are multiple optional parameters that can be configured with environment variables.
### Below are the environment variables that can be set and what they do. If these are not set,
### they will be given default values.

RANCHER_SCALING_PULSE: time to wait between each iteration
RANCHER_SCALING_JITTER: random number within this range will be added to every "pulse" 
RANCHER_SCALING_ITERATIONS: number of times to run full suite of metrics
RANCHER_SCALING_SAVE: amount of time to wait in between saving results to csv
