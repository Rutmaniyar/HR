<?php
/**
 * Router Class
 * Handles URL routing to appropriate controllers
 */

class Router {
    private $controller = 'DashboardController';
    private $method = 'index';
    private $params = [];
    
    public function __construct() {
        $url = $this->parseUrl();
        
        // Handle root/login redirect
        if (empty($url)) {
            if (!isset($_SESSION['user_id'])) {
                $this->controller = 'AuthController';
                $this->method = 'login';
            }
        } else {
            // Check for controller
            $controllerPath = APP_PATH . '/controllers/' . ucfirst($url[0]) . 'Controller.php';
            if (file_exists($controllerPath)) {
                $this->controller = ucfirst($url[0]) . 'Controller';
                unset($url[0]);
            }
        }
        
        // Require controller file
        $controllerFile = APP_PATH . '/controllers/' . $this->controller . '.php';
        if (!file_exists($controllerFile)) {
            $this->show404();
            return;
        }
        
        require_once $controllerFile;
        $this->controller = new $this->controller;
        
        // Check for method
        if (isset($url[1])) {
            if (method_exists($this->controller, $url[1])) {
                $this->method = $url[1];
                unset($url[1]);
            }
        }
        
        // Get params
        $this->params = $url ? array_values($url) : [];
        
        // Call controller method with params
        call_user_func_array([$this->controller, $this->method], $this->params);
    }
    
    private function parseUrl() {
        if (isset($_GET['url'])) {
            return explode('/', filter_var(rtrim($_GET['url'], '/'), FILTER_SANITIZE_URL));
        }
        return [];
    }
    
    private function show404() {
        http_response_code(404);
        require_once VIEWS_PATH . '/errors/404.php';
        exit();
    }
}
