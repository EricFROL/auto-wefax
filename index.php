<!doctype html>
<html>
	<head>
		<meta http-equiv="content-type" content="text/html; charset=utf-8" />
		</style>
	</head>
	<body>
  <?php 
  $directory = "./data/wefax-images";
  $images = glob($directory . "/*.png");
  
  foreach($images as $image)
  {
    echo "<img src=".$image."> \n  ";
  }
  ?>
</body>
</html>
