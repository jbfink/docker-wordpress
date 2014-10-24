(note: docker-wordpress *no longer* contains an sshd. It was probably a mistake to put one in in the first place, and you can now spawn arbitrary processes with use of the [docker exec](http://blog.docker.com/2014/10/docker-1-3-signed-images-process-injection-security-options-mac-shared-directories/) command. So do that, instead, like this:

```
docker exec -i -t docker-wordpress bash
```

easy!)

(note: [Eugene Ware](http://github.com/eugeneware) has a Docker wordpress container build on nginx with some other goodies; you can check out his work [here](http://github.com/eugeneware/docker-wordpress-nginx).)


(N.B. the way that Docker handles permissions may vary depending on your current Docker version. If you're getting errors like
```
dial unix /var/run/docker.sock: permission denied
```
when you run the below commands, simply use sudo. This is a [known issue](https://twitter.com/docker/status/366040073793323008).)


This repo contains a recipe for making a [Docker](http://docker.io) container for Wordpress, using Linux, Apache and MySQL. 
To build, make sure you have Docker [installed](http://www.docker.io/gettingstarted/), clone this repo somewhere, and then run:
```
docker build -rm -t <yourname>/wordpress .
```

Or, alternately, build DIRECTLY from the github repo like some sort of AMAZING FUTURO JULES-VERNESQUE SEA EXPLORER:
```
docker build -rm -t <yourname>/wordpress git://github.com/jbfink/docker-wordpress.git
```

Then run it, specifying your desired ports! Woo! 
```
docker run --name wordpress -d -p <http_port>:80 <yourname>/wordpress 
```


Check docker logs after running to see MySQL root password and Wordpress MySQL password, as so

```
echo $(docker logs wordpress | grep password)
```

(note: you won't need the mysql root or the wordpress db password normally)


Your wordpress container should now be live, open a web browser and go to http://localhost:<http_port>, then fill out the form. No need to mess with wp-config.php, it's been auto-generated with proper values. 


You can shutdown your wordpress container like this:
```
docker stop wordpress
```

And start it back up like this:
```
docker start wordpress
```

Enjoy your wordpress install courtesy of Docker!
