This script helps you create a temporary AWS session in a Linux bash terminal using your access keys.

## Features

* Securely stores your access keys using a GPG-encrypted file
* You always work under temporary credentials
* Allows you to set the desired session duration (default: 3600 seconds)
* Adds an extra security layer with MFA
* Supports working under your own account or any granted role
* Deletes all temporary credentials when you exit the terminal session

## Usage

### Initial Setup

Ensure you have installed `gpg` and `jq`:

```
gpg --version
jq --version
```

Store your AWS access keys in a file named `keys` with the following format:

```
cat > keys <<EOF
AWS_ACCESS_KEY_ID=AKIA****************
AWS_SECRET_ACCESS_KEY=****************************************
ACCOUNT_ID=<aws_account_id>
IAM_USERNAME=<your_iam_username>
EOF
```

Encrypt the `keys` file using GPG:

```
gpg -c keys
```

Securely delete the original `keys` file:

```
shred -u keys
```

Make `login.sh` executable:

```
chmod +x login.sh
```

If you have assigned roles and want to use them in the CLI, create a file named `roles` next to `login.sh` and list the role ARNs as follows:

```
arn:aws:iam::<aws_account_id>:role/<iam_role_name_1>
arn:aws:iam::<aws_account_id>:role/<iam_role_name_2>
```

> Note: Both `keys.gpg` and `roles` files should be located next to `login.sh`.

### Creating a Temporary AWS Session

* Run and load into the current shell:
    ```
    source ./login.sh
    ```
* Enter your password for the GPG file
* Enter the desired session duration (minimum 900 seconds; default is 3600 seconds)
* Enter the MFA code for your account
* Choose the desired role for account-wide access
* Enjoy!

## Troubleshooting

### Entered Wrong Password for GPG File

Clear the GPG password cache and try again:

```
gpgconf --kill gpg-agent
```