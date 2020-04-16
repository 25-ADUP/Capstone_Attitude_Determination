import sys


def percentage(iter: int, total: int):
    """
    A handy percent bar for visualization
    :param iter: number you're on
    :param total: total number of iterations
    :return: None
    """
    # percentage of 20 bars
    num = int((iter / total) * 20) + 1

    # carriage return, loading bar, write
    sys.stdout.write('\r')
    sys.stdout.write("[%-20s] %d%% (#%d)" % ('=' * num, int(iter / total * 100), iter))
    sys.stdout.flush()
