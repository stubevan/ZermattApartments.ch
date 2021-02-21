#!/usr/bin/env bash
#===============================================================================
#
#          FILE: build_html.sh
# 
#         USAGE: ./build_html.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 20/12/2019 12:38
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

IFS=$'\n'
SOURCE_FILE="$1"
TARGET=$(basename ${SOURCE_FILE} | awk -F. '{print $1}' )
BASE_TARGET=$(basename ${SOURCE_FILE} | awk -F. '{print $1}' | sed 's/_availability//' | sed 's/_review//' | sed 's/_map//' )
TARGET_FILE=$(dirname ${SOURCE_FILE})/../site/${TARGET}.html
TEMPLATE=$(dirname ${SOURCE_FILE})/base.template
CONTACT_SPLIT=40

echo "Building HTML for file -> ${SOURCE_FILE}"

HEADER_TEXT=$(cat ${SOURCE_FILE} | awk -F= '/^!!!!HEADER_TEXT!!!!/ {print $2}')
BASE_POSITION=$(cat ${SOURCE_FILE} | awk -F= '/^!!!!BASE_POSITION!!!!/ {print $2}')
BOX_HEIGHT=$(cat ${SOURCE_FILE} | awk -F= '/^!!!!BOX_HEIGHT!!!!/ {print $2}')
AVAILABILITY_POSITION=$(cat ${SOURCE_FILE} | awk -F= '/^!!!!AVAILABILITY_POSITION!!!!/ {print $2}')
TITLE=$(cat ${SOURCE_FILE} | awk -F= '/^!!!!TITLE!!!!/ {print $2}')

CONTENT=$(cat ${SOURCE_FILE} | sed -n '/!!!!CONTENT!!!!/,$p' | sed 's/!!!!CONTENT!!!!//'  )

CSS=""
if [[ $TARGET != "home" ]]; then
	CSS="<link rel=\"stylesheet\" type=\"text/css\" media=\"screen,print\" href=\"${BASE_TARGET}_files/${BASE_TARGET}.css\" />"
fi

TITLE_CODE=""
if [[ "${TITLE}" != "" ]]; then
TITLE_CODE="
<div id=\"id5\" style=\"height: 51px; left: 30px; position: absolute; top: -3px; width: 739px; z-index: 1; \" class=\"style_SkipStroke_2 shape-with-text\">
	<div class=\"text-content graphic_textbox_layout_style_default_External_339_51\" style=\"padding: 0px; \">
		<div class=\"graphic_textbox_layout_style_default\">
			<p style=\"padding-bottom: 0pt; padding-top: 0pt; \" class=\"paragraph_style_3\">${TITLE}</p>
		</div>
	</div>
</div>
"
fi

AVAILABILITY=" "
if [[ ${AVAILABILITY_POSITION} != "" ]]; then
	let CONTACT_POSITION=${AVAILABILITY_POSITION}+${CONTACT_SPLIT}
AVAILABILITY="
<div id=\"id12\" style=\"height: 27px; left: 200px; position: absolute; top: ${AVAILABILITY_POSITION}px; width: 178px; z-index: 1; \" class=\"style_SkipStroke_1 shape-with-text\">
	<div class=\"text-content graphic_textbox_layout_style_default_External_178_27\" style=\"padding: 0px; \">
		<div class=\"graphic_textbox_layout_style_default\">
			<p style=\"padding-bottom: 0pt; padding-top: 0pt; \" class=\"paragraph_style_home_5\"><a class=\"class_home_5\" href=\"${BASE_TARGET}_availability.html\" \" title=\"Apartment Availability \">Availability</a></p>
		</div>
		</div>
</div>

<div id=\"id12 \" style=\"height: 27px; left: 639px; position: absolute; top: ${AVAILABILITY_POSITION}px; width: 178px; z-index: 1; \" class=\"style_SkipStroke_1 shape-with-text \">
	<div class=\"text-content graphic_textbox_layout_style_default_External_178_27 \" style=\"padding: 0px; \">
		<div class=\"graphic_textbox_layout_style_default \">
			<p style=\"padding-bottom: 0pt; padding-top: 0pt; \" class=\"paragraph_style_home_5 \"><a class=\"class_home_5 \" href=\"${BASE_TARGET}_review.html \" title=\"Apartment Reviews\">Reviews</a></p>
		</div>
	</div>
</div>
<div id=\"id6\" style=\"height: 49px; left: 85px; position: absolute; top: ${CONTACT_POSITION}px; width: 729px; z-index: 1;\" class=\"style_SkipStroke_1 shape-with-text\">
	<div class=\"text-content graphic_textbox_layout_style_default_External_729_49\" style=\"padding: 0px; \">
		<div class=\"graphic_textbox_layout_style_default\">
			<p style=\"padding-bottom: 0pt; padding-top: 0pt; \" class=\"paragraph_style_home_99\">For rates and to reserve please call Ann on <a class=\"class_home_99\" href=\"tel:+41788209730\">+41 (0)78 820 97 30</a> or email <a class=\"class_home_99\" href=\"mailto:ann@zermattapartments.ch?subject=\" title=\"Mail Ann\">ann@zermattapartments.ch</a></p>
		</div>
	</div>
</div>
"
fi



cat ${TEMPLATE} | sed "s/!!!!HEADER_TEXT!!!!/${HEADER_TEXT}/" \
	| sed "s/!!!!BASE_POSITION!!!!/${BASE_POSITION}px/" \
	| sed "s/!!!!BOX_HEIGHT!!!!/${BOX_HEIGHT}px/" \
	| awk '{if ($0 == "!!!!CSS!!!!") print css; else print $0}' css="${CSS}" \
	| awk '{if ($0 == "!!!!AVAILABILITY!!!!") print change_string; else print $0}' change_string="${AVAILABILITY}" \
	| awk '{if ($0 == "!!!!TITLE!!!!") print change_string; else print $0}' change_string="${TITLE_CODE}" \
	| awk '{if ($0 == "!!!!CONTENT!!!!") print change_string; else print $0}' change_string="${CONTENT}" > ${TARGET_FILE}

# If it's a review then iterate through the content
if [[ $(echo $SOURCE_FILE | grep -c review) == 1 ]]; then
	TMP_FILE=$$.tmp
	cat ${TARGET_FILE} \
		| sed "s/^REVIEW_TITLE-\(.*\)$/\<p style=\"padding-bottom: 0pt; padding-top: 0pt; \" class=\"Body\"\>\<strong\>\1\<br \/\>\<\/strong\>\<\/p\>/" \
		| sed "s/^REVIEW_CONTENT-\(.*\)$/\<p style=\"padding-bottom: 0pt; padding-top: 0pt; \" class=\"Body\"\>\1\<br \/\>\\<br\><\/p\>/" > ${TMP_FILE}
	mv ${TMP_FILE} ${TARGET_FILE}
fi
