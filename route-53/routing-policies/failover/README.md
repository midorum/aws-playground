This example demonstrates how to manage a failover routing policy in AWS Route 53.

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
terraform plan -var hosted_zone_name=example.com. -var domain=testaz.example.com \
    -var primary_routes='["93.32.3.143"]' \
    -var secondary_routes='["5.68.101.8"]' \
    -var health_check_port=80 \
    -var health_check_resource_path="/health" \
    -var health_check_failure_threshold="3" \
    -var health_check_search_string="example"
```

Note how we pass the required parameters to the configuration:

- **hosted_zone_name**: The name of your hosted zone, for example: `example.com.`. You can find this value in the AWS Management Console.
- **domain**: The fully qualified domain name you want to route to the target resources. For example: `testaz.example.com`.
- **primary_routes**: A list of IPs that correspond to primary instances, e.g. `["10.0.1.1", "10.0.2.1"]`.
- **secondary_routes**: A list of IPs that correspond to secondary instances, e.g. `["10.0.3.1", "10.0.4.1"]`.

You can also pass optional parameters to configure health checks:

- **health_check_port**: The port of the endpoint to be checked.
- **health_check_resource_path**: The path that you want Amazon Route 53 to request when performing health checks.
- **health_check_failure_threshold**: The number of consecutive health checks that an endpoint must pass or fail.
- **health_check_search_string**: The string searched in the first 5120 bytes of the response body for the check to be considered healthy.

>
> This example supports only `HTTP` and `HTTP_STR_MATCH` health check types.
>

Apply the configuration plan:

```
terraform apply -var hosted_zone_name=example.com. -var domain=testaz.example.com \
    -var primary_routes='["93.32.3.143"]' \
    -var secondary_routes='["5.68.101.8"]' \
    -var health_check_port=80 \
    -var health_check_resource_path="/health" \
    -var health_check_failure_threshold="3" \
    -var health_check_search_string="example"
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

To simulate server failure, connect to the primary instance through the AWS Management Console via EC2 Instance Connect and stop the `httpd` service:

```
sudo systemctl stop httpd
```

You can check the current status of the `httpd` service with the following command:

```
systemctl status httpd
```

After you see that failover has switched to the secondary server, you can start the `httpd` service on the primary instance again and observe how Route 53 switches traffic back to the primary. These actions may take some time due to health check intervals.

```
sudo systemctl start httpd
```

## Clean Up Your Infrastructure

Before moving on, destroy the records you created:

```
terraform destroy -var hosted_zone_name=example.com. -var domain=testaz.example.com \
    -var primary_routes='["93.32.3.143"]' \
    -var secondary_routes='["5.68.101.8"]' \
    -var health_check_port=80 \
    -var health_check_resource_path="/health" \
    -var health_check_failure_threshold="3" \
    -var health_check_search_string="example"
```

Also, do not forget to clean up the test infrastructure by running `terraform destroy` in the `../infrastructure` folder.

## Useful References

* https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record#failover-routing-policy
* https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy-failover.html