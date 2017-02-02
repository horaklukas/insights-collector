<?php
	$pathToJson = __DIR__ . '/db.json';
	$json = file_get_contents($pathToJson);
	$db = json_decode($json);

	$dataPath = isset($_GET['path']) ? $_GET['path'] : '';
	$data = $dataPath === '' ? $db : (isset($db->$dataPath) ? $db->$dataPath : null);

	if (!$data) {
		header($_SERVER["SERVER_PROTOCOL"]." 404 Not Found", true, 404);
		exit('');
	} 

	header('Content-Type: application/json');
	echo json_encode($data);

?>