#!/usr/bin/python

# TODO:

# This script is meant to update all the scripts located in bank. It's more
# of a convenience tool, rather than necessity, as the scripts can be simply
# copied into their respective directories using "backup" script.

import os
import pwd
import mcass_utils

# Credit to https://stackoverflow.com/a/13094326/2059351 
def find_nth(string, substring, n):
    if (n == 1):
        return string.find(substring)
    else:
        return string.find(substring, \
                find_nth(string, substring, n - 1) + 1)

def recreate_true_path(subdir, file):
    path = os.path.join(subdir, file)
    path = path[path.find('/'):]
    begins_with_home_dir = path.find("home", 1, 5) != -1

    if begins_with_home_dir:
        user_name         = pwd.getpwuid(os.getuid()).pw_name
        home_dir          = path[:path.find('/', 1)] + '/' 
        specific_location = path[find_nth(path, '/', 2):]
        path = home_dir + user_name + specific_location 

    return path

def update(path):
    (bank_path, _) = mcass_utils.recreate_directory_branch_in_bank(path)
    mcass_utils.copy_file_with_permissions(path, bank_path)
    
def main():
    for subdir, _, files in os.walk('bank/'):
        for file in files:
            update(recreate_true_path(subdir, file))

if __name__=="__main__":
    main()
