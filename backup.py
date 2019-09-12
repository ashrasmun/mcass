#!/usr/bin/python

# This script is meant to save the chosen script,
# with it's full path into "bank" directory.
# Precious scripts need proper place for them :)

import sys
import os
import shutil
import pwd
import re
import mcass_utils

# Credits to https://stackoverflow.com/a/35091558/2059351
# It throws on wrong indices... I will write this myself, sooner or later >.>
def replacenth(string, sub, wanted, n):
    where = [m.start() for m in re.finditer(sub, string)][n - 1]
    before = string[:where]
    after = string[where:]
    after = after.replace(sub, wanted)
    newString = before + after
    return newString

def check_arguments():
    if len(sys.argv) < 2:
        sys.stderr.write("ERROR:" +   \
                os.linesep +          \
                "Usage: " +           \
                sys.argv[0] +         \
                " <path to script>" + \
                os.linesep)
        sys.exit(1)

def make_sure_bank_exists():
    if not os.path.isdir(mcass_utils.get_bank_location()):
        print("WARNING" +                           \
                os.linesep +                        \
                "Bank doesn't exist! Creating..." + \
                os.linesep)
        os.mkdir(mcass_utils.get_bank_location())

def check_if_file_exists(file_name):
    if not os.path.isfile(file_name):
        sys.stderr.write("ERROR:" +        \
                os.linesep +               \
                "Provided path (" +        \
                absolute_path(file_name) + \
                ") is invalid" +           \
                os.linesep)
        sys.exit(1)

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
    dir_branch = prepare_path_in_bank(             \
            mcass_utils.get_bank_location(),       \
            mcass_utils.absolute_path(file_name),  \
            pwd.getpwuid(os.getuid()).pw_name)

    if dir_branch.find("home") != -1:
        warn_about_home = True

    try:
        os.makedirs(dir_branch)
        print(                        \
                "Directory branch " + \
                dir_branch          + \
                " created"          + \
                os.linesep)
    except FileExistsError:
        pass
    except:
        print("Unspecified error encountered!");

    return (dir_branch, warn_about_home)

def copy_file_with_permissions(script_file_name, to):
    shutil.copy2(script_file_name, to)

def main():
    check_arguments()
    make_sure_bank_exists()

    script_file_names = sys.argv[1:]
    should_warn_about_home = False

    for file_name in script_file_names:
        check_if_file_exists(file_name)

        (directory_branch, was_home_used) = \
                recreate_directory_branch_in_bank(file_name)

        if was_home_used:
            should_warn_about_home = True

        copy_file_with_permissions(file_name, directory_branch)

    if should_warn_about_home:
        print("WARNING:" +                                           \
                os.linesep +                                         \
                "Scripts located in 'home' directory" +              \
                " will be placed into directory with the same name" + \
                " but stripped from the 'username' directory" +       \
                os.linesep)

    print("Please check if everything's fine :)")

if __name__=="__main__":
    main()
