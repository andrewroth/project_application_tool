<?
/*
 * page_Spt_home.php
 *
 * This is a generic template for the page_Spt_home.php page.
 *
 * Required Template Variables:
 *  $pageLabels :   The values of the labels to display on the page.
 *
 */
 
// First load the common Template Tools object
// This object handles the common display of our form items and
// text formmatting tools.
$fileName = 'objects/TemplateTools.php';
$path = Page::findPathExtension( $fileName );
require_once( $path.$fileName);

$templateTools = new TemplateTools();


// load the page labels
$templateTools->loadPageLabels( $pageLabels );


?>

<p class="text"><a href="<? echo $sptLink;?>">Click here to go to the summer project tool.</a></p>

<p class="text">Note: You can now <a href="https://spt.campusforchrist.org/security/login">log in directly</a> at the spt.</p>

<? include("notice.php"); ?>
