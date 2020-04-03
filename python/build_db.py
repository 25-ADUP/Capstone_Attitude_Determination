"""
MIT License

Copyright (c) 2019 Sierra MacLeod

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
==============================================================================
Module: build_db

Description:
Builds a new database via input model frames
"""

import os
import io
import re
import sys
import time
from PIL import Image
import imageio
import numpy as np
from modelstorage import ModelStorage
from multiprocessing import Process, Value, Lock, Queue
from processing import calc_contour_gauss


calc_contours = True


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
        

def convert_masks(file_names: list,
                  file_num: int,
                  file_counter: Value,
                  file_prefix: str,
                  images_folder: str,
                  use_blobs: bool,
                  crop_frame: tuple,
                  target_dimension: tuple,
                  print_lock: Lock,
                  write_lock: Lock):
                  
    with ModelStorage(drop_old=False, use_blobs=use_blobs) as db:
        for i, filename in enumerate(file_names):

            # extract angles from filename using regex, aka black magic
            match = re.match(r'{}_(.*)_(.*)_(.*).png'.format(file_prefix), filename)
            theta, psi, phi = match.group(1), match.group(2), match.group(3)

            # open image, crop, resize, and convert it to grayscale
            image = Image.open('./{}/{}'.format(images_folder, filename))
            image = image.crop(crop_frame).resize(target_dimension).convert('L')

            if use_blobs:
                # save image to `file_obj` as binary object
                file_obj = io.BytesIO()
                image.save(file_obj, format='PNG')
            else:
                # set `file_obj` to image file name and save image into ./masks/
                file_obj = 'M{}_{}_{}.png'.format(theta, psi, phi)
                image.save('./masks/{}'.format(file_obj), format='PNG')

            # insert into database
            try:
                write_lock.acquire()
                db.insert(theta, psi, phi, file_obj)
            finally:
                try:
                    write_lock.release()
                except:
                    pass
                    
            try:
                print_lock.acquire(True, 3)
                with file_counter.get_lock():
                    file_counter.value += 1
                    percentage(file_counter.value, file_num)
            finally:
                try:
                    print_lock.release()
                except:
                    pass


def build_contours(file_names: list,
                   file_num: int,
                   file_counter: Value,
                   print_lock: Lock,
                   write_lock: Lock):
    with ModelStorage(drop_old=False, use_blobs=False) as db:
        for filename in file_names:
            match = re.match(r'M(.*)_(.*)_(.*).png', filename)
            theta, psi, phi = match.group(1), match.group(2), match.group(3)

            im = imageio.imread('./working_model/masks/{}'.format(filename))
            im = np.float32(im)
            contour = calc_contour_gauss(im, 2)
            contour = 255 * (contour - np.min(contour)) / np.ptp(contour).astype(int)

            new_filename = 'C{}_{}_{}.png'.format(theta, psi, phi)
            imageio.imwrite('./working_model/contours/{}'.format(new_filename), np.uint8(contour))

            # insert into database
            try:
                write_lock.acquire()
                db.insert(theta, psi, phi, new_filename)
            finally:
                try:
                    write_lock.release()
                except:
                    pass

            try:
                print_lock.acquire(True, 3)
                with file_counter.get_lock():
                    file_counter.value += 1
                    percentage(file_counter.value, file_num)
            finally:
                try:
                    print_lock.release()
                except:
                    pass

            
def partition(array, num):
    start = 0
    iteration = 1
    while start < len(array):
        yield array[start:int(iteration / num * len(array))]
        start = int(iteration / num * len(array))
        iteration += 1


if __name__ == '__main__':

    if calc_contours:
        file_list = os.listdir('./working_model/masks')
        file_num = len(file_list)

        counter = Value('i', 0)

        percent_lock = Lock()
        write_lock = Lock()

        process_num = 16

        print('Building contours with {} processes...\n'.format(process_num))
        time_start = time.time()

        processes = [Process(target=build_contours, args=(part,
                                                         file_num,
                                                         counter,
                                                         percent_lock,
                                                         write_lock)) for part in partition(file_list, process_num)]

        for p in processes:
            p.start()

        processes[-1].join()
        print('Contour processing took {} seconds'.format(time.time() - time_start))

    else:
        images_folder = sys.argv[1]
        file_prefix = sys.argv[2]
        use_blobs = True if sys.argv[3].lower() in ['true', '1', 't', 'y', 'yes', 'yeah', 'yup', 'certainly', 'uh-huh'] else False
        input_width = 512
        input_height = 512
        target_dimension = (64, 64)

        # calculate coordinates for cropping a rectangle to a square
        crop_low_x = (input_width - input_height) / 2
        crop_low_y = 0
        crop_high_x = crop_low_x + input_height
        crop_high_y = input_height

        crop_frame = (crop_low_x, crop_low_y, crop_high_x, crop_high_y)

        percent_lock = Lock()
        write_lock = Lock()

        counter = Value('i', 0)

        file_list = os.listdir('./{}'.format(images_folder))
        file_num = len(file_list)

        process_num = 20

        if not use_blobs:
            if not os.path.exists('./masks'):
                os.makedirs('./masks')

        print('Building database with {} processes...\n'.format(process_num))
        time_start = time.time()

        processes = [Process(target=convert_masks, args=(part,
                                                         file_num,
                                                         counter,
                                                         file_prefix,
                                                         images_folder,
                                                         use_blobs,
                                                         crop_frame,
                                                         target_dimension,
                                                         percent_lock,
                                                         write_lock)) for part in partition(file_list, process_num)]

        for p in processes:
            p.start()

        processes[-1].join()
        time.sleep(3)
        with ModelStorage(drop_old=False, use_blobs=use_blobs) as db:
            num = db.get_length()
            print('\nDB created from {} frames, closing with {} frames'.format(file_num, num))
            print('Processing took {} seconds'.format(time.time() - time_start))
    
