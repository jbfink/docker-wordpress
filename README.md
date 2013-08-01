This repo contains a recipe for making a [Docker](http://docker.io) container. 
To build, make sure you have Docker [installed](http://www.docker.io/gettingstarted/), clone this repo somewhere, and then run:
```
docker build -t <yourname>/wordpress .
```

Or, alternately, build DIRECTLY from the github repo like some sort of SUPER FUTURISTIC FLYING CAR MECHANIC:
```
docker build -t <yourname>/wordpress git://github.com/jbfink/docker-wordpress.git
```

Then run it! Woo! 
```
docker run -d <yourname>/wordpress
```


Check docker logs after running to see MySQL root password and Wordpress MySQL password, as so

```
echo $(docker logs <container-id> | grep password)
```

Then find the external port assigned to your container:

```
docker port <container-id> 80 
```

Visit in a webrowser, then fill in the config. Database user is "wordpress", fill in the password with what you grepped earlier. Done! 
