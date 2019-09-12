#!/usr/bin/python

# Utils used in more than one MCaSS scripts

import os

def absolute_path(file_name):
    return os.path.dirname(os.path.realpath(file_name))

def get_bank_location():
    return os.path.join(absolute_path(__file__), "bank")

