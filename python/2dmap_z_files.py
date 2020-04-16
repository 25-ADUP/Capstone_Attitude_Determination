import os
import sys
from tools import percentage
import time
from modelstorage import ModelStorage


if __name__ == '__main__':

    upper_limit = int(sys.argv[1])
    step_size = int(sys.argv[2])
    z_start = int(sys.argv[3])

    print('Mapping Z-Axis files on 1 process...')
    time_start = time.time()

    with ModelStorage(drop_old=False) as db:
        iter_count = 0
        total = ((upper_limit / step_size) ** 2) * ((upper_limit / step_size) - 1)  # skips a step on Z

        for z in range(z_start, upper_limit, step_size):
            for y in range(0, upper_limit, step_size):
                for x in range(0, upper_limit, step_size):
                    image_filename = 'M{}_{}_0.png'.format(x, y)
                    contour_filename = 'C{}_{}_0.png'.format(x, y)

                    db.insert_image(x, y, z, image_filename)
                    db.insert_contour(x, y, z, contour_filename)

                    percentage(iter_count, total)
                    iter_count += 1

    print('\nMapping took {} seconds'.format(time.time() - time_start))
