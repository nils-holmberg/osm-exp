#!/bin/bash

# Step 1: Get dimensions of both images
control_info=$(identify -format "%w %h" news_media_control.png)
treatment_info=$(identify -format "%w %h" news_media_treatment.png)

# Step 2: Extract width and height
read control_width control_height <<< "$control_info"
read treatment_width treatment_height <<< "$treatment_info"

# Step 3: Calculate total pixels to determine smaller image
control_pixels=$((control_width * control_height))
treatment_pixels=$((treatment_width * treatment_height))

# Step 4: Identify smaller image and set target dimensions
if [ "$control_pixels" -le "$treatment_pixels" ]; then
    smaller_width=$control_width
    smaller_height=$control_height
    larger_image="news_media_treatment.png"
    output_image="news_media_treatment_resized.png"
else
    smaller_width=$treatment_width
    smaller_height=$treatment_height
    larger_image="news_media_control.png"
    output_image="news_media_control_resized.png"
fi

# Step 5: Scale and crop larger image to match smaller image dimensions
convert "$larger_image" -resize "${smaller_width}x${smaller_height}^" -gravity Center -crop "${smaller_width}x${smaller_height}+0+0" +repage "$output_image"

# Step 6: Output result
echo "Smaller image dimensions: ${smaller_width}x${smaller_height}"
echo "Larger image ($larger_image) has been resized and cropped to $output_image"
