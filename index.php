<?php

$name = $_ENV['NAME'] ?? 'World';
echo sprintf('Hello %s!', htmlspecialchars($name)); 