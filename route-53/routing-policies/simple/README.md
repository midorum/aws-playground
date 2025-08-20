This example demonstrates how to manage a simple routing policy in AWS Route 53.

## Prerequisites

You should have a registered domain name in AWS Route 53 to proceed with this lab.

## How to Use

First, create some test infrastructure (a couple of EC2 instances) that will be used as routing targets. You can do this manually by running `terraform apply` in the `../infrastructure` folder. Please note the IP addresses in the output.

Next, initialize Terraform:

```
terraform init
```

View the configuration plan:

```
terraform plan -var hosted_zone_name=example.com. -var domain=testaz.example.com -var route_to='["93.32.3.143", "5.68.101.8"]'
```

Note how we pass the required parameters to the configuration:

- **hosted_zone_name**: The name of your hosted zone, for example: `example.com.`. You can find this value in the AWS Management Console.
- **domain**: The fully qualified domain name you want to route to the target resources. For example: `testaz.example.com`.
- **route_to**: A list of IP addresses to route to your domain name. Enter the IP addresses you obtained from the output when you created the test infrastructure.

Apply the configuration plan:

```
terraform apply -var hosted_zone_name=example.com. -var domain=testaz.example.com -var route_to='["93.32.3.143", "5.68.101.8"]'
```

You can check the created record in the terminal:

```
dig +short testaz.example.com @ns-843.awsdns-41.net
```

Explanation:

* `testaz.example.com` — The fully qualified domain name you chose to route to the target resources.
* `ns-843.awsdns-41.net` — The name server domain name for your hosted zone. You can find this value in the output of the previous `terraform apply` command as `primary_name_server`.

You can test how the created routing policy works with the following shell command:

```
(
  set +m  # disable job control to clean up output
  for i in {1..10}; do
    {
      curl -s "http://$(dig +short testaz.example.com @ns-843.awsdns-41.net. | shuf -n 1)/" \
        -H 'Host: testaz.example.com'
    } &
  done
  wait
)
```

Explanation:

* `( ... )` — Runs everything inside a subshell. Any settings changed (like `set +m`) affect only this block, not your main shell.
* `set +m` — Disables monitor mode (job control notifications) in Bash.
* `for i in {1..10}; do ... done` — A simple loop that runs 10 times.
* `{ ... } &` — Groups commands together as a compound command; `&` at the end runs that group in the background.
* `curl -s ...` — `curl` is the HTTP client sending requests; `-s` enables silent mode (hides the progress meter).
* `$( ... )` — Command substitution: runs a command and inserts its output.
* `dig +short testaz.example.com @ns-843.awsdns-41.net` — Asks the authoritative Route 53 name server directly for `testaz.example.com`; `+short` prints only the IP addresses.
* `| shuf -n 1` — Picks one random IP from the list.
* `-H 'Host: testaz.example.com'` — Adds a custom HTTP Host header; required when connecting directly by IP but still wanting the server to know which domain you’re requesting. This is important for virtual hosting, where multiple domains share the same IP.
* `wait` — Pauses the script until all background jobs finish.

This command allows you to bypass the system DNS cache and obtain the new DNS record values each time you make a request.

## Clean Up Your Infrastructure

Before moving on, destroy the records you created:

```
terraform destroy -var hosted_zone_name=example.com. -var domain=testaz.example.com -var route_to='["93.32.3.143", "5.68.101.8"]'
```

Also, do not forget to clean up the test infrastructure by running `terraform destroy` in the `../infrastructure` folder.

## Useful References

* https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record
* https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy-simple.html