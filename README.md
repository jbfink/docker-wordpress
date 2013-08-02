This repo contains a recipe for making a [Docker](http://docker.io) container. 
To build, make sure you have Docker [installed](http://www.docker.io/gettingstarted/), clone this repo somewhere, and then run:
```
docker build -t <yourname>/wordpress .
```

Or, alternately, build DIRECTLY from the github repo like some sort of AMAZING FUTURO JULES-VERNESQUE SEA EXPLORER:
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

(note: you won't need the mysql root or the wordpress db password normally)

Then find the external port assigned to your container:

```
docker port <container-id> 80 
```

Visit in a webrowser, then fill out the form. No need to mess with wp-config.php, it's been auto-generated with proper values. 

