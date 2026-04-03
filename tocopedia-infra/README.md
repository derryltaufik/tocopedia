# Tocopedia Infrastructure

Terraform config to provision a single EC2 t4g.nano instance running the backend with Docker.

## Prerequisites

- [Terraform CLI](https://developer.hashicorp.com/terraform/install)
- AWS account
- SSH key pair (`ssh-keygen -t ed25519 -C "tocopedia"` if you don't have one)

## Step 1 — Create IAM Policy

1. Go to **IAM → Policies → Create policy**
2. Switch to **JSON** tab → paste contents of `iam-policy.json`
3. Name it `tocopedia-deploy-policy` → **Create policy**

## Step 2 — Create IAM User

1. **IAM → Users → Create user**
2. Username: `tocopedia-deploy` — **uncheck** "Provide user access to the AWS Management Console"
3. **Permissions** → "Attach policies directly" → search `tocopedia-deploy-policy` → attach
4. **Create user**
5. Open the user → **Security credentials** → **Create access key** → use case: **CLI**
6. Copy `Access key ID` and `Secret access key`

## Step 3 — Configure credentials and variables

```bash
cd tocopedia-infra

# AWS credentials
cp .env.example .env
# Edit .env — fill in AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY

# Terraform variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars — set ssh_public_key to output of: cat ~/.ssh/id_ed25519.pub
```

## Step 4 — Provision with Terraform

```bash
source .env

terraform init
terraform plan     # preview: 3 resources (key pair, security group, EC2)
terraform apply    # type "yes" to confirm
```

Note the outputs after apply:

```
public_ip   = "x.x.x.x"
ssh_command = "ssh -i ~/.ssh/id_ed25519 ubuntu@x.x.x.x"
api_url     = "http://x.x.x.x:3000"
```

## Step 5 — SSH into the instance

Wait ~60 seconds after `terraform apply` for the instance to finish installing Docker.

```bash
ssh -i ~/.ssh/id_ed25519 ubuntu@<public_ip>
```

Verify Docker is ready:

```bash
docker --version && docker compose version
```

## Step 6 — Deploy the backend

There are two ways to deploy: manually via SSH or automatically via GitHub Actions.

### Option A: Manual deploy

SSH into the instance and run:

```bash
git clone https://github.com/derryltaufik/tocopedia.git
cd tocopedia/tocopedia-backend

cp .env.example .env
vi .env
# Press i to enter insert mode, edit JWT_SECRET to a long random string
# Set MONGODB_URL to your Atlas connection string
# Press Esc, then type :wq and Enter to save and quit

docker compose up -d
docker compose ps    # api should show "Up"
```

For subsequent deploys:

```bash
cd ~/tocopedia
git pull origin main
cd tocopedia-backend
docker compose down
docker compose up -d --build
```

### Option B: Automatic deploy (CI/CD)

A workflow in `.github/workflows/deploy-backend.yml` automatically deploys when changes to `tocopedia-backend/` are merged to `main`. Env vars are injected from GitHub secrets — no manual `.env` on the instance needed.

**First-time setup on the instance:**

```bash
git clone https://github.com/derryltaufik/tocopedia.git
```

**Set up GitHub secrets:**

1. Go to **Settings → Secrets and variables → Actions → Repository secrets → New repository secret**
2. Add the following:

| Secret | Value |
|---|---|
| `EC2_HOST` | Public IP of the instance (`terraform output public_ip`) |
| `EC2_SSH_KEY` | Contents of your private SSH key (`cat ~/.ssh/id_ed25519`) |
| `APP_PORT` | Backend port (e.g. `3000`) |
| `MONGODB_URL` | MongoDB connection string (e.g. Atlas URL) |
| `JWT_SECRET` | Secret key for JWT token signing |

After setup, any merge to `main` that changes `tocopedia-backend/` will automatically deploy.

### Verify

Test from your local machine:

```bash
curl http://<public_ip>:3000/
# → {"status":"success"}
```

## Step 7 — Deploy the frontend (Cloudflare Pages)

A workflow in `.github/workflows/deploy-frontend.yml` automatically builds and deploys the Flutter web app when changes to `tocopedia-flutter/` are merged to `main`.

### One-time Cloudflare setup

1. Go to **Cloudflare Dashboard → Workers & Pages → Create → Pages → Direct Upload**
2. Name the project (e.g. `tocopedia`) → **Create project**
3. Skip the initial upload — GitHub Actions will handle it
4. Note your **Account ID** from the Cloudflare dashboard URL or sidebar

### Create API token

1. Go to **Cloudflare Dashboard → My Profile → API Tokens → Create Token**
2. Use the **Edit Cloudflare Workers** template
3. Under **Account Resources**, select your account
4. **Create Token** → copy the token

### Add GitHub secrets

Add these to **Settings → Secrets and variables → Actions → Repository secrets**:

| Secret | Value |
|---|---|
| `CLOUDFLARE_API_TOKEN` | API token from above |
| `CLOUDFLARE_ACCOUNT_ID` | Your Cloudflare account ID |
| `CLOUDFLARE_PAGES_PROJECT_NAME` | Project name (e.g. `tocopedia`) |
| `API_URL` | Backend URL (e.g. `http://18.140.65.18:3000`) |

After setup, any merge to `main` that changes `tocopedia-flutter/` will build and deploy automatically.

The frontend will be available at `https://<project-name>.pages.dev`.

## Step 8 — Seed the database (optional)

On the EC2 instance:

```bash
cd ~/tocopedia/tocopedia-backend
docker compose --profile local run --rm seed
```

## Tear down

From your local machine:

```bash
cd tocopedia-infra
source .env
terraform destroy
```

## Architecture

| Resource | Detail |
|---|---|
| Instance | `t4g.nano` (ARM64, 2 vCPU, 0.5 GB RAM) |
| OS | Ubuntu 24.04 LTS (Noble) |
| Region | `ap-southeast-1` (configurable) |
| Runtime | Docker + Compose (installed via user_data) |
| Ports | 22 (SSH), 3000 (API) |

## IAM Policy Scope

The policy in `iam-policy.json` is scoped to:

- **Read-only describe** for all EC2 resources
- **Instance type locked** to `t4g.nano` (can't launch expensive instances)
- **Region locked** to `ap-southeast-1`
- **Stop/terminate** only instances tagged `Project=tocopedia`
