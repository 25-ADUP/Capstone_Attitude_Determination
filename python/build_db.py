import os
import io
import re
import sys
from time import sleep
from PIL import Image
from modelstorage import ModelStorage


images_folder = 'Cone1'
use_blobs = False
input_width = 1920
input_height = 1080
target_dimension = (512, 512)

# calculate coordinates for cropping a rectangle to a square
crop_low_x = (input_width - input_height) / 2
crop_low_y = 0
crop_high_x = crop_low_x + input_height
crop_high_y = input_height

crop_frame = (crop_low_x, crop_low_y, crop_high_x, crop_high_y)


def percentage(iter, total):
    # percentage of 20 bars
    num = int((iter / total) * 20) + 1

    # carriage return, loading bar, write
    sys.stdout.write('\r')
    sys.stdout.write("[%-20s] %d%% (#%d)" % ('=' * num, 5 * num, iter))
    sys.stdout.flush()
    sleep(0.25)


print('Building database...\n')

# list and num of files in source image directory
file_list = os.listdir('./{}'.format(images_folder))
file_num = len(file_list)

if not use_blobs:
    if not os.path.exists('./masks'):
        os.makedirs('./masks')

with ModelStorage(drop_old=True, use_blobs=use_blobs) as db:
    for i, filename in enumerate(file_list):

        # extract angles from filename
        match = re.match(r'{}_(.*)_(.*).png'.format(images_folder), filename)
        theta, psi = match.group(1), match.group(2)

        # open image, crop, resize, and convert it to grayscale
        image = Image.open('./{}/{}'.format(images_folder, filename))
        image = image.crop(crop_frame).resize(target_dimension).convert('L')

        if use_blobs:
            # save image to `file_obj` as binary object
            file_obj = io.BytesIO()
            image.save(file_obj, format='PNG')
        else:
            # set `file_obj` to image file name and save image into ./masks/
            file_obj = 'M{}_{}_0.png'.format(theta, psi)
            image.save('./masks/{}'.format(file_obj), format='PNG')

        # insert into database
        db.insert(theta, psi, 0, file_obj)
        percentage(i, file_num)

