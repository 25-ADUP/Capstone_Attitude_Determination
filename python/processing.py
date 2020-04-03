import numpy as np
from scipy.ndimage import gaussian_filter


def calc_contour_gauss(image, filter_width: int):
    i_x, i_y = np.gradient(image)

    frame_contour = i_x**2 + i_y**2

    return gaussian_filter(frame_contour, sigma=filter_width)
