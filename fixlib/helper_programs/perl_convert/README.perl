There are several files in this directory.  First you should
notice that since the directory for perl differs on the sgi
and linux machines I have created .sgi and .linux versions.
Secondly, there is the actual perl script that processes the
data files and then there are convertALL files which are simple
shell scripts that will convert anything in the current directory
which has .dat as it's file ending.

Example usage on a linux machine:

./baufix_converter.linux datafile.dat

Produces datafile.dat.data

Or maybe you want to convert all the files in the directory:

./baufix_convertALL

This will result in .data files for all .dat files

