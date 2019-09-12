#!/usr/bin/python

# This script is meant to save the chosen script,
# with it's full path into "bank" directory.
# Precious scripts need proper place for them :)

import sys
import os
import mcass_utils

def check_arguments():
    if len(sys.argv) < 2:
        sys.stderr.write("ERROR:"   + \
                os.linesep          + \
                "Usage: "           + \
                sys.argv[0]         + \
                " <path to script>" + \
                os.linesep)
        sys.exit(1)

def make_sure_bank_exists():
    if not os.path.isdir(mcass_utils.get_bank_location()):
        print("WARNING"                           + \
                os.linesep                        + \
                "Bank doesn't exist! Creating..." + \
                os.linesep)
        os.mkdir(mcass_utils.get_bank_location())

def check_if_file_exists(file_name):
    if not os.path.isfile(file_name):
        sys.stderr.write("ERROR:"        + \
                os.linesep               + \
                "Provided path ("        + \
                absolute_path(file_name) + \
                ") is invalid"           + \
                os.linesep)
        sys.exit(1)

def create_dir_branch(dir_branch):
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

def main():
    check_arguments()
    make_sure_bank_exists()

    script_file_names = sys.argv[1:]
    should_warn_about_home = False

    for file_name in script_file_names:
        check_if_file_exists(file_name)

        (directory_branch, was_home_used) = \
                mcass_utils.recreate_directory_branch_in_bank(file_name)
    
        create_dir_branch(directory_branch)

        if was_home_used:
            should_warn_about_home = True

        mcass_utils.copy_file_with_permissions(file_name, directory_branch)

    if should_warn_about_home:
        print("WARNING:"                                            + \
                os.linesep                                          + \
                "Scripts located in 'home' directory"               + \
                " will be placed into directory with the same name" + \
                " but stripped from the 'username' directory"       + \
                os.linesep)

    print("Please check if everything's fine :)")

if __name__=="__main__":
    main()
