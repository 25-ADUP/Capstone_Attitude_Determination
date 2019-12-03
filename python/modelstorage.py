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
Module: modelstorage

Description:
Provides a simple interface with the model database
"""

import sqlite3
import io
from typing import Union


class ModelStorage:
    def __init__(self, drop_old=False, use_blobs=True):
        """
        Initialize the DB.
        :param drop_old: Set to True if making new DB
        """
        self.use_blobs = use_blobs

        self.connection = sqlite3.connect('priors.db')
        self.cursor = self.connection.cursor()
        print('Database connected.')

        if drop_old:
            self.cursor.execute('drop table if exists angles')

        # this module plans for contours but does not add them
        self.cursor.execute(
            """
            create table if not exists angles (
                theta real not null,
                psi real not null,
                phi real not null,
                image {0},
                contour {0},
                primary key (theta, psi, phi)
            );
            """.format('blob' if use_blobs else 'text')
        )

    def insert(self, theta, psi, phi, imagefile: Union[str, io.BytesIO]):
        """
        Insert an angle mask
        :param theta: angle corresponding to X
        :param psi: angle corresponding to Y
        :param phi: angle corresponding to Z
        :param imagefile: str filename or file-like object with png image
        """
        if self.use_blobs:
            self.cursor.execute('insert into angles (theta, psi, phi, image) values (?,?,?,?)',
                                (theta, psi, phi, sqlite3.Binary(imagefile.getvalue())))
        else:
            self.cursor.execute('insert into angles (theta, psi, phi, image) values (?,?,?,?)',
                                (theta, psi, phi, imagefile))
        self.connection.commit()

    def request(self, theta=None, psi=None, phi=None) -> list:
        """
        Request data with any angle criteria
        :param theta: angle corresponding to X
        :param psi: angle corresponding to Y
        :param phi: angle corresponding to Z
        """
        if not any((theta is not None, psi is not None, phi is not None)):
            raise ValueError('Please provide an angle to request.')

        angles = {
            'theta': theta,
            'psi': psi,
            'phi': phi
        }

        query = 'select * from angles where {} '.format(' and '.join(['{}={}'.format(k, v) for k, v in angles.items() if v is not None]))

        return list(self.cursor.execute(query))

    def save(self):
        """
        Saves and closes DB
        """
        self.connection.commit()
        self.connection.close()

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        number = self.cursor.execute("SELECT COUNT(theta) FROM angles").fetchone()[0]
        print('\nDatabase closing with {} angles'.format(number))
        self.save()
