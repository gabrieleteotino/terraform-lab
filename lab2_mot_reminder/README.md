# Bootstrapping

## Prepare the variables

Copy the file `bootstrap\template.tfvars` in `bootstrap\terraform.tfvars`

Edit `bootstrap\terraform.tfvars` with a valid subscription.

## Bootstrap

Use terraform locally to create the required bootstrapping resouces

```
cd bootstrap
terraform init
terraform apply
```