<?php
$CONFIG = array (
  'htaccess.RewriteBase' => '/',
  'memcache.local' => '\OC\Memcache\Redis',
  'memcache.locking' => '\OC\Memcache\Redis',
  'redis' => [
    'host' => 'redis',
    'port' => 6379,
  ],
  'apps_paths' =>
  array (
    0 =>
    array (
      'path' => '/var/www/html/apps',
      'url' => '/apps',
      'writable' => false,
    ),
    1 =>
    array (
      'path' => '/var/www/html/custom_apps',
      'url' => '/custom_apps',
      'writable' => true,
    ),
  ),
  'trusted_domains' =>
  array (
    0 => '{{ domain }}',
  ),
  'datadirectory' => '/var/www/html/data',
  'overwrite.cli.url' => 'https://{{ domain }}',
  'overwriteprotocol' => 'https',
  'mysql.utf8mb4' => true,
  'maintenance' => true,
  'mail_from_address' => 'drive',
  'mail_smtpmode' => 'smtp',
  'mail_smtpauthtype' => 'PLAIN',
  'mail_domain' => '{{ domain }}',
  'mail_smtpauth' => 1,
  'mail_smtphost' => 'mail.{{ domain }}',
  'mail_smtpname' => 'drive@{{ domain }}',
  'mail_smtppassword' => '{{ drive_smtp_password }}',
  'mail_smtpport' => '587',
  'mail_smtpsecure' => 'tls',
  'installed' => false,
  'user_backend_sql_raw' =>
  array (
    'db_type' => 'mariadb',
    'db_host' => 'mariadb',
    'db_port' => '3306',
    'db_name' => '{{ postfix_database_name }}',
    'db_user' => '{{ postfix_database_user }}',
    'db_password' => '{{ postfix_database_password }}',
    'mariadb_charset' => 'utf8mb4',
    'queries' =>
    array (
      'get_password_hash_for_user' => 'SELECT substr(password,15,3000) AS password_hash FROM mailbox WHERE username = BINARY :username',
      'user_exists' => 'SELECT EXISTS(SELECT 1 FROM mailbox WHERE username = :username)',
      'get_users' => 'select username as fqda from mailbox where username like :search or name like :search',
      'set_password_hash_for_user' => 'UPDATE mailbox SET password = CONCAT(\'{SHA512-CRYPT}\',:new_password_hash) WHERE username = BINARY :username',
      'delete_user' => 'SELECT EXISTS(SELECT 1 FROM mailbox WHERE username = :username)',
      'get_display_name' => 'SELECT name FROM mailbox where username = BINARY :username',
      'set_display_name' => 'UPDATE mailbox SET name = :new_display_name WHERE username = BINARY :username',
      'count_users' => 'SELECT COUNT(*) FROM mailbox',
      'delete_user' => 'SELECT EXISTS(SELECT 1 FROM mailbox WHERE username = :username)',
    ),
    'hash_algorithm_for_new_passwords' => 'sha512',
  ),
  'theme' => 'eelo',
  'loglevel' => 2,
  'preview_max_x' => 1024,
  'preview_max_y' => 1024,
  'app.mail.accounts.default' =>
    array (
      'email' => '%USERID%',
      'imapHost' => '{{ domain }}',
      'imapPort' => 993,
      'imapSslMode' => 'ssl',
      'smtpHost' => '{{ domain }}',
      'smtpPort' => 25,
      'smtpSslMode' => 'tls',
    ),
);
?>
