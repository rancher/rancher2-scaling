import pandas


class State:
    def __init__(self, options):
        self.count = options.iterations
        self.current_measure = pandas.DataFrame()

    def decrement(self):
        self.count -= 1
