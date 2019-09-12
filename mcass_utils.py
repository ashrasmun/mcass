#!/usr/bin/python

# Utils used in more than one MCaSS scripts

import os
import pwd
import shutil
import re

def absolute_path(file_name):
    return os.path.dirname(os.path.realpath(file_name))

def get_bank_location():
    return os.path.join(absolute_path(__file__), "bank")

# Credits to https://stackoverflow.com/a/35091558/2059351
# It throws on wrong indices... I will write this myself, sooner or later >.>
def replacenth(string, sub, wanted, n):
    where = [m.start() for m in re.finditer(sub, string)][n - 1]
    before = string[:where]
    after = string[where:]
    after = after.replace(sub, wanted)
    newString = before + after
    return newString

# WARN: This is Linux specific, for obvious reasons.
# If there's ever a need to implement this for other platforms,
# please consult the link below:
# https://stackoverflow.com/questions/4579908/cross-platform-splitting-of-path-in-python/4580931#4580931
def prepare_path_in_bank(bank_location, file_path, user_name):
    final_directory_branch = \
        bank_location +      \
        replacenth(file_path, '/' + user_name, "", 1) 

    return final_directory_branch

# NOTE: This works only for scripts located in subdirectory of 
# $HOME directory. I'm too tired to fix it now tho. It would be nice
# to take care of it after introducing unit tests for these scripts,
# as some of the functions start to get out of hand.
def recreate_directory_branch_in_bank(file_name):
    dir_branch = prepare_path_in_bank( \
            get_bank_location(),       \
            absolute_path(file_name),  \
            pwd.getpwuid(os.getuid()).pw_name)

    if dir_branch.find("home") != -1:
        warn_about_home = True

    return (dir_branch, warn_about_home)

def copy_file_with_permissions(script_file_name, to):
    shutil.copy2(script_file_name, to)

