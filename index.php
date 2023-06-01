<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Galería de Imágenes</title>
    <style>
      .container {
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
        gap: 20px;
        margin-top: 50px;
      }

      .tray {
        border: 1px solid #000;
        width: 300px;
        height: auto;
        padding: 10px;
        text-align: center;
        font-size: 14px;

      }

      .tray-title {
        font-size: 24px;
        font-weight: bold;
        text-decoration: underline;
      }

      .tray-date {
        font-size: 20px;
        font-weight: bold;
        text-decoration: underline;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <?php
      $directory = "./";
      $images = glob($directory . "/*.png");
      $imageGroups = array();

      foreach ($images as $image) {
          $date = date("Y/m/d", filemtime($image));
          $imageGroups[$date][] = $image;
      }

      krsort($imageGroups);

      foreach ($imageGroups as $date => $imageGroup) {
          echo '<div class="tray">';
          echo '<h3>' . $date . '</h3>';
          foreach ($imageGroup as $image) {
              echo '<a href="' . $image . '">' . basename($image) . '</a><br>';
          }
          echo '</div>';
      }
      ?>
    </div>
  </body>
</html>
