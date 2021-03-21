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

### Testing submodules

To test a submodule put appropriate values in the variables file `[submodulefolder]\debug.terraform.tfvars`

```
terraform init
terraform plan -var-file="debug.terraform.tfvars"
```

Before running `apply` manually create all the resources needed by the submodule.

For example most submodules require a resource group to exist. Other needed resources can be inferred looking at the variables.

When all the required resources are created yun can deploy the submodule

```
terraform plan -var-file="debug.terraform.tfvars"
terraform apply -var-file="debug.terraform.tfvars"
terraform apply -var-file="debug.terraform.tfvars" --auto-approve
```

When the testing is finished remember to destroy the debug resources

```
terraform destroy -var-file="debug.terraform.tfvars"
terraform destroy -var-file="debug.terraform.tfvars" --auto-approve
```