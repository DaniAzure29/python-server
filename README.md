# 🚀 Containerized Python Web App (Vanilla Python + Docker + Azure VM)

A lightweight web server built with vanilla Python, containerized using Docker, and ready to deploy on an Azure VM.

## 🔧 Features

- Written using Python's built-in `http.server` module (no frameworks)
- Includes multiple routes:
  - `/` → Home page (HTML)
  - `/about` → About page (HTML)
  - `/api/info` → JSON API
- Dockerized for easy deployment
- Tested locally before cloud deployment
- Azure-ready: runs on a Linux VM

---

## 📁 Project Structure

python-server/
├── app.py # Python web server
├── Dockerfile # Instructions to build container image
├── .dockerignore # Excludes unnecessary files
└── terraform/ # (Optional) IaC files for Azure VM deployment

---

## 🐳 Run Locally with Docker

### 1. Build the Image

```bash
docker build -t python-web-app .


```

### 2. Run the Container

docker run -d -p 8080:8080 --name python-web-container python-web-app

### 3. Test in Your Browser

http://localhost:8080

http://localhost:8080/about

http://localhost:8080/api/info

🪵 View Logs

docker logs python-web-container
Or follow live:

docker logs -f python-web-container
🧹 Stop & Clean Up

docker stop python-web-container
docker rm python-web-container

☁️ Deploy to Azure
You can provision a Linux VM using Azure CLI or Terraform and deploy this container for cloud access.

---

## 🌱 Load Environment Variables for Terraform

If you're using `.env` files to store sensitive data like your Azure credentials or VM details, you can load them into your terminal session before running Terraform.

### 1. Create a `.env` file

```dotenv
ARM_CLIENT_ID=your-azure-client-id
ARM_CLIENT_SECRET=your-azure-client-secret
ARM_SUBSCRIPTION_ID=your-subscription-id
ARM_TENANT_ID=your-tenant-id

🖥️ 2. Load .env in Your Terminal

✅ For Unix/macOS (Linux, WSL, bash, zsh):

export $(grep -v '^#' .env | xargs)
This exports each line as an environment variable in your current terminal session.

✅ For Windows (PowerShell):

Get-Content .env | ForEach-Object {
  if ($_ -match "^\s*([^#][^=]+)=(.+)$") {
    $name, $value = $Matches[1].Trim(), $Matches[2].Trim()
    [System.Environment]::SetEnvironmentVariable($name, $value, "Process")
  }
}
This reads the .env file and sets each variable for the current PowerShell session.

 ▶️  3. Run Terraform
Once your environment variables are loaded, you can safely use Terraform:

terraform init
terraform plan
terraform apply


🚫 Don't Forget
Add .env to your .gitignore and .dockerignore:

gitignore


.env
.env.*





🔒 .dockerignore Tips
Your .dockerignore should include:

.dockerignore
**pycache**/
_.pyc
venv/
.venv/
.env/
terraform/
_.tf
\*.tfvars

.

🧰 Deploying a Python Docker App on Azure Linux VM
🔸 Prerequisites
You’ve already provisioned a Linux VM on Azure (e.g., Ubuntu).

You have:

The public IP

Your VM username

Your SSH private key (or password)

Your local machine has scp and ssh (or use WSL/Git Bash on Windows).

✅ Step 1: SSH into Your Azure VM

ssh -i ~/.ssh/your-key.pem azureuser@<VM_PUBLIC_IP>

🐳 Step 2: Install Docker on the Linux VM

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker Packages
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify installation
sudo docker run hello-world

🧳 Step 3: Transfer Your App to the VM
From your local machine:

scp -r -i ~/.ssh/your-key.pem ./python-server azureuser@<VM_PUBLIC_IP>:/home/azureuser/
This copies your whole project folder to the VM.

📦 Step 4: SSH Back In and Build the Image
Back on the VM:


cd ~/python-server

# Build your Docker image
docker build -t python-web-app .

🚀 Step 5: Run Your Python App in a Container

Expose it to the public using port 80:

docker run -d -p 80:8080 --name webserver python-web-app

🌍 Step 6: Access the App in Your Browser
Open your browser and visit:

http://<VM_PUBLIC_IP>
Try the other routes too:

/about

/api/info

🧼 Bonus: Manage Your Container

# View logs
docker logs webserver

# Stop the container
docker stop webserver

# Remove it
docker rm webserver

🔒 Security Tip
Make sure only needed ports are open (usually just 80 or 443). You can manage this via:

Azure Portal → Networking

Or Terraform NSG rules



📜 License
MIT License — do what you want, just don’t blame me if you run rm -rf /.

✨ Author
Daniel Nwafor
Cloud Engineer & Python Tinkerer


```
