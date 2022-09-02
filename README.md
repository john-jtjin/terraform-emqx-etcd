# terraform-emqx-emqx-aws
> Deploy emqx 5.x on AWS


## Default configurations
> EMQX: EMQX 5.0.7

> AWS Region: us-southeast-1

## AWS AccessKey Pair
```bash
export access_key="aws_accesskey"
export secret_key="aws_secretkey"
```

## Deploy EMQX single node
```bash
terraform init
terraform apply -auto-approve
```

## Destroy
```bash
terraform destroy -auto-approve
```