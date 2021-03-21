# MOT Reminder

## Prerequisite

Have az installed
Have az logged in

## What will be created

TODO complete the list of reaources that will be created by running the terraform scripts

## Bootstrapping

### Prepare the variables

Copy the file `bootstrap\template.tfvars` in `bootstrap\terraform.tfvars`

Edit `bootstrap\terraform.tfvars` with a valid subscription.

### Bootstrap

Use terraform locally to create the required bootstrapping resouces

```
cd bootstrap
terraform init
terraform apply
```

## Mot Reminder

### Initialisation

Use az to view the available subscriptions

```
az login
az account list --out table
```

Set the desired subscription (change the guid to your subscription id)

```
az account set --subscription="00000000-0000-0000-0000-000000000000"
```

Initialize the remote backend

```
cd mot_reminder
terraform init --backend-config=backend_config.tfvars
```