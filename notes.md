## Bash/Powershell

Most of the commands found online are for bash, here is the equivalent in Powershell

Import an existing docker container using the container name

Bash
```
terraform import docker_container.container2 $(docker inspect --format '{{.Id}}' grafana_container)
```

Powershell
```
docker inspect --format='{{.Id}}' grafana_container | % { terraform import docker_container.container2 $_ }
```