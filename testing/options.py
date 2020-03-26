import os


class Options:
    def __init__(self, jitter=.5, iterations=5, pulse=5, save_every=999):
        """
        :param jitter: random number within this range will be added to every "pulse"
        :param iterations: number of times to run full suite of metrics
        :param pulse: time to wait between each iteration
        :param save_every: amount of time to wait in between saving results to csv
        """
        self.jitter = float(os.getenv("RANCHER_SCALING_JITTER", jitter))
        self.iterations = int(os.getenv("RANCHER_SCALING_ITERATIONS", iterations))
        self.pulse = float(os.getenv("RANCHER_SCALING_PULSE", pulse))
        self.save_every = float(os.getenv("RANCHER_SCALING_SAVE", save_every))
