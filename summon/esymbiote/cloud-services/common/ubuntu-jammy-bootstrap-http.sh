#!/bin/sh

apt update
apt install -y git nginx

mkdir -p /var/www/test
cat > /var/www/test/index.html <<EOF
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>test</title>
</head>
<body>
    this is a test.
</body>
</html>
EOF

chown -R www-data.www-data /var/www

rm -f /etc/nging/sites-enabled/default
cat > /etc/nginx/sites-enabled/default <<EOF
server {
       listen 80;
       listen [::]:80;

       server_name _;

       location / {
       	root /var/www/test;
       	index index.html;
       }
}

EOF

systemctl reload nginx
systemctl enable nginx
systemctl start nginx
