#!/bin/bash

apt update
apt install -y apache2

cat <<EOF > /var/www/html/index.html
<html>
<head>
  <title>Churrops!! o/</title>
</head>
<body>
<h1>Churrops!!! o/</h1>
<p>hostname is: $(hostname)</p>
</body>
</html>
EOF
