This should generate a working lampstack. Check docker logs after running to see MySQL root password, as so:

```
echo $(docker logs <container-id> | sed -n 1p)
```
