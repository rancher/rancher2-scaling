import random
import time


def random_str():
    return 'random-{0}-{1}'.format(random_num(), int(time.time()))


def random_num():
    return random.randint(0, 1000000)


def wait_for(callback, timeout=60, fail_handler=None):
    sleep_time = _sleep_time()
    start = time.time()
    ret = callback()
    while ret is None or ret is False:
        time.sleep(next(sleep_time))
        if time.time() - start > timeout:
            exception_msg = 'Timeout waiting for condition.'
            if fail_handler:
                exception_msg = exception_msg + ' Fail handler message: ' + \
                    fail_handler()
            raise Exception(exception_msg)
        ret = callback()
    return ret


def _sleep_time():
    sleep = 0.01
    while True:
        yield sleep
        sleep *= 2
        if sleep > 1:
            sleep = 1
