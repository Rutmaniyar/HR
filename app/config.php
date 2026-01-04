<?php
/**
 * Application Configuration
 * Load environment variables and define constants
 */

// Load environment variables from .env file
function loadEnv($path) {
    if (!file_exists($path)) {
        return false;
    }
    
    $lines = file($path, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    foreach ($lines as $line) {
        if (strpos(trim($line), '#') === 0) {
            continue;
        }
        
        list($name, $value) = explode('=', $line, 2);
        $name = trim($name);
        $value = trim($value);
        
        if (!array_key_exists($name, $_ENV)) {
            $_ENV[$name] = $value;
            putenv("$name=$value");
        }
    }
    return true;
}

// Load .env file
loadEnv(__DIR__ . '/../.env');

// Define path constants
define('ROOT_PATH', dirname(__DIR__));
define('APP_PATH', ROOT_PATH . '/app');
define('CONFIG_PATH', ROOT_PATH . '/config');
define('PUBLIC_PATH', ROOT_PATH . '/public');
define('VIEWS_PATH', APP_PATH . '/views');

// Database configuration
define('DB_HOST', getenv('DB_HOST') ?: 'localhost');
define('DB_NAME', getenv('DB_NAME') ?: 'hr_system');
define('DB_USER', getenv('DB_USER') ?: 'root');
define('DB_PASSWORD', getenv('DB_PASSWORD') ?: '');
define('DB_CHARSET', getenv('DB_CHARSET') ?: 'utf8mb4');

// Application configuration
define('APP_NAME', getenv('APP_NAME') ?: 'HR Management System');
define('APP_URL', getenv('APP_URL') ?: 'http://localhost');
define('APP_ENV', getenv('APP_ENV') ?: 'development');

// Session configuration
define('SESSION_LIFETIME', getenv('SESSION_LIFETIME') ?: 7200);
define('SESSION_NAME', getenv('SESSION_NAME') ?: 'hr_session');

// Security configuration
define('CSRF_TOKEN_NAME', getenv('CSRF_TOKEN_NAME') ?: 'csrf_token');

// Timezone
date_default_timezone_set(getenv('TIMEZONE') ?: 'Europe/London');

// UK Working Time Regulations
define('MAX_WEEKLY_HOURS', getenv('MAX_WEEKLY_HOURS') ?: 48);
define('ALERT_THRESHOLD_HOURS', getenv('ALERT_THRESHOLD_HOURS') ?: 45);

// Error reporting
if (APP_ENV === 'development') {
    error_reporting(E_ALL);
    ini_set('display_errors', 1);
} else {
    error_reporting(0);
    ini_set('display_errors', 0);
}

// Session settings
ini_set('session.cookie_httponly', 1);
ini_set('session.use_only_cookies', 1);
ini_set(
    'session.cookie_secure',
    (APP_ENV === 'production' || (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off')) ? 1 : 0
);
ini_set('session.cookie_samesite', 'Strict');
