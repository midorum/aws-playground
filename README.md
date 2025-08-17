# AWS Playground

A collection of small, hands-on exercises for exploring various AWS services and concepts.  
This project is designed for self-paced learning and experimentation using Terraform, Bash scripts, and clear step-by-step guides.

## What You'll Find Here
- **Terraform configurations** – to create and manage AWS resources quickly.
- **Bash scripts** – for automation and command-line interactions with AWS.
- **Markdown guides** – explaining concepts, configurations, and best practices.

## Goals
- Learn AWS concepts by doing.
- Practice Terraform for Infrastructure as Code (IaC).
- Automate cloud tasks using Bash and AWS CLI.
- Keep experiments version-controlled with Git.

## Project Structure

```
aws-playground/
│
├── <service-name>/               # Terraform configurations for experiments with AWS services
│
├── terraform-aws-modules/        # Custom or reusable Terraform modules
│
├── scripts/                      # Utility bash scripts
│
├── docs/                         # Documentation and notes
│
└── README.md                     # Entry point with overview and navigation
```

## Getting Started

1. **Clone the repo**

    ```bash
    git clone https://github.com/midorum/aws-playground.git
    cd aws-playground
    ````

2. **Install prerequisites**

   * AWS CLI
   * Terraform
   * Bash

3. **Set up a shared Terraform plugin cache (recommended)**

   This prevents Terraform from downloading large provider files for each lab separately.

   ```bash
   mkdir -p ~/.terraform.d/plugin-cache
   echo 'export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"' >> ~/.bashrc
   source ~/.bashrc
   ```

4. **Configure your AWS credentials**

   ```bash
   aws configure
   ```

5. **Run a sample lab**

   ```bash
   cd route-53/routing-policies/
   terraform init
   terraform apply
   ```

## Notes

* Each lab is self-contained and can be run independently.
* **Use the shared plugin cache** to save disk space and speed up `terraform init`.
* Use at your own AWS account — resources created **may incur costs**.
* Cleanup after each lab to avoid unwanted charges.

## License

Licensed under the MIT License. See LICENSE file in the project root for details.
