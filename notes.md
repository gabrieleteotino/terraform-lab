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

## Powershell cheats

Remove all states using a regext pattern

```
terraform state list | Select-String -Pattern "network_rules" | foreach { terraform state rm $_}

terraform state list | sls "network_rules" | foreach { terraform state rm $_}
```