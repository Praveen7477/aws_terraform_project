#!/bin/bash

# Update system
apt-get update -y
apt-get upgrade -y

# Install nginx
apt-get install nginx -y

# Enable and start nginx
systemctl enable nginx
systemctl start nginx

# Create a beautiful HTML page
cat << 'EOF' > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Hello from Terraform 🚀</title>
    <style>
        body {
            margin: 0;
            height: 100vh;
            background: linear-gradient(135deg, #667eea, #764ba2);
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: white;
            text-align: center;
        }
        .card {
            background: rgba(0, 0, 0, 0.3);
            padding: 50px;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.4);
        }
        h1 {
            font-size: 3rem;
            margin-bottom: 10px;
        }
        p {
            font-size: 1.3rem;
        }
        .footer {
            margin-top: 25px;
            font-size: 0.9rem;
            opacity: 0.8;
        }
    </style>
</head>
<body>
    <div class="card">
        <h1>🚀 Hello World!</h1>
        <p>This EC2 instance was created using <strong>Terraform</strong></p>
        <p>Running on <strong>Ubuntu</strong> with <strong>Nginx</strong></p>
        <div class="footer">
            Built automatically using user_data 💙
        </div>
    </div>
</body>
</html>
EOF

# Restart nginx to be safe
systemctl restart nginx
