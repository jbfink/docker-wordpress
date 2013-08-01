This repo contains a recipe for making a [Docker](http://docker.io) container. 
To build, make sure you have Docker [installed](http://www.docker.io/gettingstarted/), clone this repo somewhere, and then run:
```
docker build -t <yourname>/lampstack .
```

Or, alternately, build DIRECTLY from the github repo like some sort of SUPER FUTURISTIC FLYING CAR MECHANIC:
```
docker build -t <yourname>/lampstack git://github.com/jbfink/docker-lampstack.git
```

Then run it! Woo! 
```
docker run -d <yourname>/lampstack
```


Check docker logs after running to see MySQL root password, as so

```
echo $(docker logs <container-id> | sed -n 1p)
```
