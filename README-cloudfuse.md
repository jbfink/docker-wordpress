docker-wordpress with cloudfuse
-------------------------------

This particular branch of docker-wordpress has a lot of extra stuff for it to work with cloudfuse -- check the Dockerfile for more info. When the container is run, whatever your Swift install is will live at /var/www/wp-content/files and you can write to it from the web interface.

Remaining problems to be fixed:

* The Swift mount is /var/www/wp-content/files, which is fine for a single Docker container, but if another container is run it will mount the exact same filespace, which means that files could get clobbered and confusion could happen.
** fix: take unique name of docker container, put that in swift, and then mount *that* per container. e.g. instead of /var/www/wp-content/files as a hard link, symlink it to the container ID.
* The cloudfuse mount in supervisord is hacky - it works, but logs have a bunch of errors about the cloudfuse command exiting. Well yeah, it exits, its' not a foreground program.
** Either make a script that never dies and use that to run the cloudfuse mount command *or* figure out how to make the darn thing work with /etc/fstsab.

 
