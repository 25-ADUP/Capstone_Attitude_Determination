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

        self.cursor.execute(
            """
            create table if not exists angles (
                theta real not null,
                psi real not null,
                phi real not null,
                image {},
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
            self.cursor.execute('insert into angles values (?,?,?,?)', (theta, psi, phi, sqlite3.Binary(imagefile.getvalue())))
        else:
            self.cursor.execute('insert into angles values (?,?,?,?)', (theta, psi, phi, imagefile))
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
