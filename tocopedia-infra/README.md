# Tocopedia Infrastructure

Terraform config to provision the backend infrastructure: EC2 t4g.nano instance with Docker, S3 bucket for image uploads, EC2 Instance Connect Endpoint for SSH, and a dedicated IAM user for S3/EICE access.

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
2. Username: `tocopedia-terraform` — **uncheck** "Provide user access to the AWS Management Console"
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
terraform plan     # preview: ~9 resources (key pair, security group, EC2, S3 bucket + policy, IAM user + keys, EICE)
terraform apply    # type "yes" to confirm
```

Note the outputs after apply:

```
instance_id               = "i-xxxxxxxxxxxxxxxxx"
public_ip                 = "x.x.x.x"
ssh_command               = "ssh ubuntu@x.x.x.x"
s3_bucket_name            = "tocopedia-images"
deploy_access_key_id      = "AKIA..."
```

## Step 5 — SSH into the instance

Wait ~60 seconds after `terraform apply` for the instance to finish installing Docker.

```bash
ssh ubuntu@<public_ip>
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

A workflow in `.github/workflows/deploy-backend.yml` automatically deploys when changes to `tocopedia-backend/` are pushed to `main`. The image is built and pushed to GHCR, then deployed to EC2 via an EICE tunnel. Env vars are injected from GitHub secrets — no manual `.env` on the instance needed.

**First-time setup on the instance:**

```bash
git clone https://github.com/derryltaufik/tocopedia.git
```

**Set up GitHub secrets:**

1. Go to **Settings → Secrets and variables → Actions → Repository secrets → New repository secret**
2. Add the following:

| Secret | Value |
|---|---|
| `AWS_ACCESS_KEY_ID` | Access key of the `tocopedia-deploy` user (`terraform output deploy_access_key_id`) |
| `AWS_SECRET_ACCESS_KEY` | Secret key (`terraform output -raw deploy_secret_access_key`) |
| `AWS_S3_BUCKET` | S3 bucket name (`terraform output s3_bucket_name`) |
| `AWS_REGION` | AWS region (e.g. `ap-southeast-1`) |
| `INSTANCE_ID` | EC2 instance ID (`terraform output instance_id`) |
| `EC2_SSH_KEY` | Contents of your private SSH key (`cat ~/.ssh/id_ed25519`) |
| `MONGODB_URL` | MongoDB connection string (e.g. Atlas URL) |
| `JWT_SECRET` | Secret key for JWT token signing |
| `CLOUDFLARE_TUNNEL_TOKEN` | Cloudflare Tunnel token for the backend |

After setup, any push to `main` that changes `tocopedia-backend/` will automatically build, push to GHCR, and deploy via EICE.

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

### Create API token (minimal permissions)

1. Go to **Cloudflare Dashboard → My Profile → API Tokens → Create Token → Create Custom Token**
2. **Token name:** `tocopedia-pages-deploy`
3. **Permissions:**
   - Account — Cloudflare Pages — Edit
4. **Account Resources:** Include — *select only your account*
5. **Create Token** → copy the token

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
| SSH access | EC2 Instance Connect Endpoint (EICE) |
| Image storage | S3 bucket (`tocopedia-images`) with public read |
| IAM | `tocopedia-deploy` user for S3 uploads + EICE deploy access |

## IAM Policy Scope

The policy in `iam-policy.json` is for the **Terraform operator** user (`tocopedia-terraform`) and is scoped to:

- **Read-only describe** for all EC2 resources
- **Instance type locked** to `t4g.nano` (can't launch expensive instances)
- **Region locked** to `ap-southeast-1`
- **Stop/terminate** only instances tagged `Project=tocopedia`
- **S3** — create/delete/configure buckets matching `tocopedia-*`
- **IAM** — manage users and inline policies matching `tocopedia-*`
- **EC2 Instance Connect Endpoint** — create/delete in `ap-southeast-1`
