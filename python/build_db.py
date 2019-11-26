import os
import io
import re
import sys
from time import sleep
from PIL import Image
from modelstorage import ModelStorage


images_folder = 'Cone1'


def percentage(iter, total):
    num = int((iter / total) * 20)
    sys.stdout.write('\r')
    # the exact output you're looking for:
    sys.stdout.write("[%-20s] %d%% (#%d)" % ('=' * num, 5 * num, iter))
    sys.stdout.flush()
    sleep(0.25)


print('Building database...\n')

file_list = os.listdir('./{}'.format(images_folder))
file_num = len(file_list)
with ModelStorage(drop_old=True) as db:
    for i, filename in enumerate(file_list):

        # open image and convert it to grayscale
        image = Image.open('./{}/{}'.format(images_folder, filename))
        image = image.crop((420, 0, 1500, 1080)).resize((512, 512)).convert('L')
        file_obj = io.BytesIO()
        image.save(file_obj, format='PNG')

        # extract angles from filename
        match = re.match(r'{}_(.*)_(.*).png'.format(images_folder), filename)
        theta, psi = match.group(1), match.group(2)

        # insert into database
        db.insert(theta, psi, 0, file_obj)
        percentage(i, file_num)

