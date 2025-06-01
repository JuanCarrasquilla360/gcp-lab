<?php

// Pruebas unitarias simples para la aplicación
// Autor: Laboratorio DevOps

class SimpleTest {
    private $passed = 0;
    private $failed = 0;
    
    public function assertEquals($expected, $actual, $message = '') {
        if ($expected === $actual) {
            $this->passed++;
            echo "✅ PASS: $message\n";
        } else {
            $this->failed++;
            echo "❌ FAIL: $message\n";
            echo "   Expected: " . var_export($expected, true) . "\n";
            echo "   Actual:   " . var_export($actual, true) . "\n";
        }
    }
    
    public function assertTrue($condition, $message = '') {
        $this->assertEquals(true, $condition, $message);
    }
    
    public function assertContains($needle, $haystack, $message = '') {
        $condition = strpos($haystack, $needle) !== false;
        $this->assertTrue($condition, $message);
    }
    
    public function printResults() {
        echo "\n=== RESULTADOS DE PRUEBAS ===\n";
        echo "Pasadas: {$this->passed}\n";
        echo "Fallidas: {$this->failed}\n";
        echo "Total: " . ($this->passed + $this->failed) . "\n";
        
        if ($this->failed > 0) {
            echo "❌ ALGUNAS PRUEBAS FALLARON\n";
            exit(1);
        } else {
            echo "✅ TODAS LAS PRUEBAS PASARON\n";
        }
    }
}

// Función para capturar output de la aplicación
function captureAppOutput($env = []) {
    // Simular variables de entorno
    foreach ($env as $key => $value) {
        $_ENV[$key] = $value;
    }
    
    ob_start();
    include __DIR__ . '/../index.php';
    $output = ob_get_clean();
    
    // Limpiar variables de entorno
    foreach ($env as $key => $value) {
        unset($_ENV[$key]);
    }
    
    return $output;
}

// Ejecutar pruebas
$test = new SimpleTest();

echo "=== EJECUTANDO PRUEBAS DE LA APLICACIÓN ===\n\n";

// Prueba 1: Output por defecto
$output = captureAppOutput();
$test->assertEquals('Hello World!', $output, 'Output por defecto debe ser "Hello World!"');

// Prueba 2: Output con variable NAME personalizada
$output = captureAppOutput(['NAME' => 'DevOps']);
$test->assertEquals('Hello DevOps!', $output, 'Output con NAME=DevOps debe ser "Hello DevOps!"');

// Prueba 3: Output con variable NAME vacía
$output = captureAppOutput(['NAME' => '']);
$test->assertEquals('Hello !', $output, 'Output con NAME vacío debe ser "Hello !"');

// Prueba 4: Verificar que se usa htmlspecialchars
$output = captureAppOutput(['NAME' => '<script>alert("xss")</script>']);
$test->assertContains('&lt;script&gt;', $output, 'Debe escapar caracteres HTML peligrosos');

// Prueba 5: Verificar que la función sprintf funciona correctamente
$output = captureAppOutput(['NAME' => 'Test%User']);
$test->assertContains('Test%User', $output, 'Debe manejar correctamente caracteres especiales en sprintf');

// Prueba 6: Verificar longitud del output
$output = captureAppOutput(['NAME' => 'Azure']);
$test->assertTrue(strlen($output) > 0, 'El output no debe estar vacío');

// Prueba 7: Verificar formato del mensaje
$output = captureAppOutput(['NAME' => 'CI/CD']);
$test->assertTrue(strpos($output, 'Hello ') === 0, 'El mensaje debe comenzar con "Hello "');
$test->assertTrue(strpos($output, '!') === strlen($output) - 1, 'El mensaje debe terminar con "!"');

$test->printResults(); 