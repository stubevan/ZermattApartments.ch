Website Builder for https://zermattapartments.ch

This static site was originally created using iWeb and stood unchanged for
some time.  Changes were needed but the brief was to keep the site as is.
It's a relatvely low volume site so the work required to do a full rebuild 
was not justified.

The site is deployed on Swisscom servers - using lightspeed.  

## Dependencies
* Lightbox - https://lokeshdhakar.com/projects/lightbox2/ - used 
* Matomo - for analytics

## Directory structure
* 20200111 Site Pictures - Including Originals -> All images
* build - the raw text content and the shell script required to create the associated html
* site - the finished product.  This also contains the css and javascript files.  It is this directory which should be copied to the production server

Pages changes should made as follows:
* each page has an associated .content file in the build directory
* to create the associated html run the script *build_html.sh* with the associated content file as a parameter
* the html file is created in the /site directory
* the content file also contains positional information - hopefully self explanotory.  All elements are placed absolutely so any changes need to bear this in mind

## Outstanding Work - also outlined in issues:
* each page has its own CSS directory which means that there is duplication.  Also not all of the naming is consistent.  SO a change made on one page may not look the same on another.  This required some renaming during the work to keep things simple
* the images and CSS should ideally be located in the build directory and then copied across
* Ideally this should be a jekyll (or equivalent) site!
