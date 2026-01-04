<?php
/**
 * Application Bootstrap
 * Initializes the application and handles routing
 */

// Load configuration
require_once __DIR__ . '/../config/config.php';

// Start session
session_start();

// Load database
require_once CONFIG_PATH . '/Database.php';

// Load base classes
require_once APP_PATH . '/models/Model.php';
require_once APP_PATH . '/controllers/Controller.php';

// Load router
require_once CONFIG_PATH . '/Router.php';

// Initialize router
new Router();
