<?php
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
