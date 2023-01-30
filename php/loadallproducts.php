<?php
error_reporting(0);
include_once("dbconnect.php");
$search = $_GET["search"];
$results_per_page = 10;
$pageno = (int)$_GET['pageno'];
$page_first_result = ($pageno - 1) * $results_per_page;
if ($search =="all"){
	
$sqlloadproduct = "SELECT * FROM tbl_products ORDER BY product_name DESC";
}else{
	$sqlloadproduct = "SELECT * FROM tbl_products WHERE BY product_name LIKE '%$search%' ORDER BY product_name DESC";
}

$result = $conn->query($sqlloadproduct);
$number_of_result = $result -> num_rows;
$number_of_page = ceil ($number_of_result / $results_per_page);
$sqlloadproduct = $sqlloadproduct . "LIMIT $page_first_result , $results_per_page";
$result = $conn->query($sqlloadproduct);

if($result->num_rows > 0){
$productsarray["products"] = array ();
	while ($row = $result->fetch_assoc()){
		$prlist = array();
	$prlist['product_id'] = $row['product_id'];
	$prlist['user_id'] = $row['user_id'];
	$prlist['prodcut_name'] = $row['product_name'];
	$prlist['product_desc'] = $row['product_desc'];
	$prlist['product_price'] = $row['product_price'];
	$prlist['product_guest'] = $row['product_guest'];
	$prlist['product_state'] = $row['product_state'];
	$prlist['prodcut_local'] = $row['prodcut_local'];
	$prlist['product_lat'] = $row['product_lat'];
	$prlist['product_lng'] = $row['product_lng'];
	array_push($productsarray["products"],$prlist);
	}
	$response = array('status' => 'success','numofpage' => "$number_of_page",'numberofresult'=> "$number_of_result",'data' => $productsarray);
	sendJsonResponse($response);
	
}
else{
	$response = array('status' => 'failed','numofpage' => "$number_of_page",'numberofresult'=> "$number_of_result",'data' => $productsarray);
	sendJsonResponse($response);
	}
	function sendJsonResponse($sentArray)
{
	header('content-Type: application/json');
	echo json_encode($sentArray);
}

?>