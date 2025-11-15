#!/bin/bash
set -e

echo ">>> Starting CTF VM provisioning"

##############################################
# SYSTEM PREP
##############################################
echo ">>> Updating system and installing required packages"
apt update -y
apt install -y apache2 php libapache2-mod-php php-mysql ufw openssh-server

systemctl enable apache2
systemctl enable ssh

##############################################
# FIREWALL
##############################################
echo ">>> Configuring UFW firewall"
ufw --force enable
ufw allow apache
ufw allow ssh
ufw reload

##############################################
# DEPLOY VULNERABLE PING APP
##############################################
echo ">>> Deploying vulnerable PHP ping application"

cat << 'EOF2' > /var/www/html/ping.php
<?php
$ip = '';
$output = '';
if (isset($_GET['target'])) {
    $target = $_GET['target'];
    $blacklist = array(';', '&&', '||', '|');
    $target = str_replace($blacklist, '', $target);
    $command = "ping -c 4 " . $target;
    $output = shell_exec($command);
}
?>
<!DOCTYPE html>
<html>
<head>
<title>Vulnerable Ping Tool</title>
<style>
body { font-family: monospace; background: #222; color: #0f0; }
.container { max-width: 600px; margin: 50px auto; padding: 20px; border: 1px solid #0f0; }
input[type="text"] { width: 80%; padding: 5px; margin-bottom: 10px; }
pre { background: #333; padding: 10px; white-space: pre-wrap; word-wrap: break-word; }
</style>
</head>
<body>
<div class="container">
<h1>CTF Ping Test</h1>
<p>Try to break this simple ping tool.</p>
<form method="GET">
<input type="text" name="target" placeholder="Enter IP or hostname" />
<input type="submit" value="Ping" />
</form>

<?php if (!empty($output)): ?>
<h2>Command Output:</h2>
<pre><?php echo htmlspecialchars($output); ?></pre>
<?php endif; ?>
</div>
</body>
</html>
EOF2

chown -R www-data:www-data /var/www/html/

##############################################
# USER SETUP
##############################################
echo ">>> Creating user account"
useradd -m pa
echo "pa:password123" | chpasswd

##############################################
# CREATE PLACEHOLDER FLAGS
##############################################
echo ">>> Creating flag placeholders"

echo "ZmxhZ3t1c2VyLWNhcHR1cmVkMjAyNX0=" > /home/pa/user.txt
echo "ZmxhZ3tyb290LWJlZm9yZWNocmlzdG1hczIwMjV9" > /root/root.txt

chown pa:pa /home/pa/user.txt
chmod 600 /home/pa/user.txt
chmod 600 /root/root.txt



##############################################
# PRIVILEGE ESCALATION MISCONFIGURATIONS
##############################################
echo ">>> Applying system configurations"

# SUID find
chmod u+s /usr/bin/find

# Allow pa to run nano with no password
echo "pa ALL=(ALL) NOPASSWD: /usr/bin/nano" >> /etc/sudoers

# Remove pa from admin groups
gpasswd -d pa sudo  || true
gpasswd -d pa adm   || true
gpasswd -d pa lxd   || true

##############################################
# CLEANUP
##############################################
echo ">>> Cleaning up"
rm -f /home/pa/.bash_history
rm -f /root/.bash_history

echo ">>> Provisioning complete!"