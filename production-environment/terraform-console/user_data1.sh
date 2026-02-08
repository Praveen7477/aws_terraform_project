#!/bin/bash
apt-get update -y
apt-get install nginx -y
systemctl start nginx
systemctl enable nginx

cat << 'EOF' > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bruce Lee Edition 🐉</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            height: 100vh;
            /* Using a high-quality Bruce Lee wallpaper */
            background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), 
                        url('https://images.alphacoders.com/605/605152.jpg');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: 'Segoe UI', Arial, sans-serif;
            color: white;
            overflow: hidden;
        }

        .glass-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 40px;
            border-radius: 20px;
            text-align: center;
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.8);
            max-width: 500px;
        }

        h1 {
            font-size: 3.5rem;
            margin: 0;
            color: #ffcc00; /* Classic Bruce Lee Yellow */
            text-transform: uppercase;
            letter-spacing: 2px;
            text-shadow: 2px 2px 10px rgba(0,0,0,0.5);
        }

        p {
            font-size: 1.2rem;
            line-height: 1.6;
            font-style: italic;
        }

        .quote {
            margin-top: 20px;
            border-top: 1px solid #ffcc00;
            padding-top: 20px;
            font-weight: bold;
        }

        .btn {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 25px;
            background: #ffcc00;
            color: black;
            text-decoration: none;
            border-radius: 50px;
            font-weight: bold;
            transition: 0.3s;
        }

        .btn:hover {
            transform: scale(1.1);
            background: #fff;
        }
    </style>
</head>
<body>
    <div class="glass-card">
        <h1>Be Water</h1>
        <p>"Empty your mind, be formless, shapeless — like water."</p>
        <div class="quote">
            Terraform Node: <strong>Active</strong><br>
            Server Status: <strong>Legendary</strong>
        </div>
        <a href="#" class="btn">Learn More</a>
    </div>
</body>
</html>
EOF

systemctl restart nginx