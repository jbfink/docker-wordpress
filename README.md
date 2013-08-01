This repo contains a recipe for making a [Docker](http://docker.io) container. 
To build, make sure you have Docker [installed](http://www.docker.io/gettingstarted/), clone this repo somewhere, and then run:
```
docker build -t <yourname>/lampstack .
```

Check docker logs after the build is complete to see MySQL root password, as so

```
echo $(docker logs <container-id> | sed -n 1p)
```
