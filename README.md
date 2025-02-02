# Vault and Consul Local Setup

This setup deploys a Vault instance using Consul as the storage backend, configured for mutual TLS (mTLS) and secured with AWS KMS auto-unseal. The Docker Compose environment allows Vault and Consul to run in isolated containers, securely storing and managing secrets.

## Prerequisites

- Docker and Docker Compose should be installed on your local machine.
- An AWS account for Key Management Service (KMS) to enable auto-unseal for Vault.
- Certificates for mutual TLS (mTLS) are already generated and stored in the /certs directories.

## Project Overview

- Vault is a tool for securely accessing secrets, with Consul acting as the storage backend.
- Consul is a service discovery and configuration tool, storing Vault’s data.
- mTLS ensures that all communication between Vault, Consul, and clients is encrypted and authenticated.

## Directory Structure

The project directory structure is as follows:

```
.
├── consul/
│   ├── config/                     # Consul configuration files
│   │   └── certs/                  # TLS certificates for Consul 
│   └── data/                       # Consul data directory 
├── main-vault/
│   ├── certs/                      # TLS certificates for Vault 
│   ├── config/                     # Vault configuration file
│   ├── .env                        # Environment file for AWS credentials 
└── docker-compose.yml              # Docker Compose setup for Vault and Consul

```

## Components

1. Docker Compose (docker-compose.yml)

- Consul:

	- Stores Vault’s data in a single node. This is sufficient for local development and testing, where you are the only user querying Vault from your local machine.
	- Secured with mutual TLS (mTLS) to encrypt and authenticate both incoming and outgoing connections.

- Vault:

	- Uses Consul as its storage backend.
	- Secured with mTLS to ensure all API and client communications are encrypted and verified.
	- Uses AWS KMS auto-unseal, meaning that after a restart, Vault can automatically unseal itself using an AWS KMS key.
	- `disable_mlock = false` is enabled to secure sensitive information in memory, preventing it from being swapped to disk.


2. Consul Configuration (consul.hcl)

- TLS Configuration:

	- `verify_incoming = true` ensures that all incoming requests to Consul are verified using mTLS.
	- `verify_outgoing = true` ensures that all outgoing requests from Consul (including to Vault) are also verified using mTLS.
	- The internal RPC communication between Consul nodes is also verified using mTLS.

- Service Discovery:

	- Consul enables service discovery, helping Vault locate its storage backend securely.

- Data Directory:

	- `/consul/data` stores Consul’s data, ensuring persistence across container restarts.


3. Vault Configuration (vault-config.hcl)

- Consul Storage Backend:

	- Vault uses Consul as its storage backend, storing all Vault secrets securely in Consul.

- mTLS:

	- Vault’s API communication (tcp listener) is secured with mTLS (tls_require_and_verify_client_cert = true), ensuring that only authenticated clients can connect.

- AWS KMS Auto-Unseal:

	- The seal "awskms" block configures Vault to use AWS KMS for auto-unsealing. This requires AWS credentials to be provided in the .env file:
		- `AWS_REGION`: Your AWS region.
		- `AWS_ACCESS_KEY_FILE`: Path to the file containing your AWS access key.
		- `AWS_SECRET_KEY_FILE`: Path to the file containing your AWS secret key.
		- `VAULT_AWSKMS_SEAL_KEY_ID`: The KMS Key ID used to auto-unseal Vault.


## Running the Setup

1. Clone the Repository

Make sure you are in the project directory.

```
git clone https://github.com/Anon5234/Secrets_Management.git
cd Secrets_Management
```

2. Configure AWS Credentials

Create a `.env` file inside the main-vault directory with the following content:

```
AWS_REGION=your-aws-region
AWS_ACCESS_KEY_FILE=path-to-aws-access-key
AWS_SECRET_KEY_FILE=path-to-aws-secret-key
VAULT_AWSKMS_SEAL_KEY_ID=your-kms-key-id
```

This file provides Vault with the necessary credentials to use AWS KMS for auto-unseal.

3. Start the Services

Run the following command to start both Consul and Vault:

```
docker-compose up -d
```

This will start Consul and Vault containers in detached mode. Vault will automatically attempt to unseal using AWS KMS after startup.

4. Check the Status of Vault

Once the services are up and running, check the status of Vault:

```
vault status --client-cert=/path/to/client.crt --client-key=/path/to/client.key --ca-cert=/path/to/vault-ca.crt
```

You need to provide the client certificate, private key, and CA certificate to authenticate with Vault via mTLS.

5. Stopping the Services

To stop the services, run:

```
docker-compose down
```


## Notes

1. Mlock:

`disable_mlock = false` is set, which prevents sensitive data from being swapped to disk. This adds an extra layer of security.

2. Consul:

`bootstrap_expect = 1` is used for simplicity in a local setup. Future improvements will consider running multiple Consul nodes (e.g., `bootstrap_expect = 3`) for high availability.

3. Health Checks:

Consul and Vault both have health checks configured to ensure that they are running and functioning correctly.
