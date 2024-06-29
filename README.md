# Static Website Deployment on DigitalOcean using NGINX

Deploying a static website on a DigitalOcean Droplet using NGINX.

## Prerequisites

- A DigitalOcean account (Sign up [here](https://www.digitalocean.com/)).
- Basic knowledge of SSH and command-line interface.

## Steps

### 1. Create a DigitalOcean Droplet

1. Log in to your DigitalOcean account.
2. Click on the "Create" button and select "Droplets."
3. Choose an image: Select the latest version of Ubuntu.
4. Choose a plan: The basic plan is sufficient for a static website.
5. Choose a datacenter region: Select a region close to your target audience.
6. Authentication: Add your SSH key or create a new one if you don't have any.
7. Finalize and create: Click "Create Droplet."

### 2. Connect to Your Droplet

- Use SSH to connect to your Droplet.
```sh
ssh root@your_droplet_ip

