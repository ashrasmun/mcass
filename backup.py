#!/usr/bin/python

# This script is meant to save the chosen script, 
# with it's full path into "bank" directory.
# Precious scripts need proper place for them :)

import sys
import os
import shutil
import pwd

# Credit to https://stackoverflow.com/a/35092436/2059351
# I was too tired to implement it myself when I needed... bummer
def nth_repl(s, sub, repl, nth):
    find = s.find(sub)
    # if find is not p1 we have found at least one match for the substring
    i = find != -1

    # loop util we find the nth or we find no match
    while find != -1 and i != nth:
        # find + 1 means we start at the last match start index + 1
        find = s.find(sub, find + 1)
        i += 1

    # if i  is equal to nth we found nth matches so replace
    if i == nth:
        return s[:find] + repl + s[find + len(sub):]

    return s

def absolute_path(file_name):
    return os.path.dirname(os.path.realpath(file_name))

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
    if not os.path.isdir(get_bank_location()):
        print("WARNING" +                           \
                os.linesep +                        \
                "Bank doesn't exist! Creating..." + \
                os.linesep)
        os.mkdir(get_bank_location())

def check_if_file_exists(file_name):
    if not os.path.isfile(file_name):
        sys.stderr.write("ERROR:" +        \
                os.linesep +               \
                "Provided path (" +        \
                absolute_path(file_name) + \
                ") is invalid" +           \
                os.linesep)
        sys.exit(1)

def get_bank_location():
    return os.path.join(absolute_path(__file__), "bank")

# WARN: This is Linux specific, for obvious reasons.
def recreate_directory_branch_in_bank(file_name):
    file_directory_branch = absolute_path(file_name)
    
    # TODO: print warning about fetching something from home directory, 
    # or at least store this warning and display it later

    if file_directory_branch.find("home") != -1:
        print("WARNING:" +                                              \
                os.linesep +                                            \
                "The script's path contains 'home' directory" +         \
                os.linesep +                                            \
                "it will be placed into directory with the same name" + \
                os.linesep +                                            \
                "but stripped from the username directory" +            \
                os.linesep) 

    # WARN: If there's ever a need to implement this for other platforms, 
    # please consult the link below:
    # https://stackoverflow.com/questions/4579908/cross-platform-splitting-of-path-in-python/4580931#4580931
    final_directory_branch = get_bank_location() + file_directory_branch
    username               = pwd.getpwuid(os.getuid()).pw_name + '/'
    final_directory_branch = \
            nth_repl(final_directory_branch, username, "", 2)

    try: 
        os.makedirs(final_directory_branch)
        print(                           \
                "Directory branch "    + \
                final_directory_branch + \
                " created"             + \
                os.linesep)
    except FileExistsError:
        print(                           \
                "Directory branch "    + \
                final_directory_branch + \
                " already exists"      + \
                os.linesep)

    return final_directory_branch

def copy_file_with_permissions(script_file_name, to):
    shutil.copy2(script_file_name, to)

def main():
    check_arguments()
    make_sure_bank_exists()

    script_file_name = sys.argv[1]
    check_if_file_exists(script_file_name)

    directory_branch = recreate_directory_branch_in_bank(script_file_name)
    copy_file_with_permissions(script_file_name, directory_branch)

    print("Please check if everything's fine :)")

if __name__=="__main__":
    main()
