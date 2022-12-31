## Take a gpkg of waypoints of photo locations (produced by QGIS "Import geotagged photos")
## and copy the photos to a specified folder. The idea is that the gpkg of waypoints was
## produced in QGIS by manually selecting a subset of the photo points.

library(sf)
library(tidyverse)

photo_points_file = "/ofo-data/scratch-derek/tnc-2021-unit3-subsection-photopoints-80m-se.gpkg"
photo_subset_dest_folder = "/ofo-data/tnc-yuba-2021/unit3-subset" # no trailing slash

## Number of directories above the photo file to preserve the structure of when copying photos.
# For example, if a photo file is /ofo-data/tnc-yuba-2021/unit3/120m/100MEDIA/DJI_0387.JPG and
# folder_levels_to_preserve is set to 2, the following folder structure will be copied to
# the photo_subset_dest_folder: 120m/100MEDIA/DJI_0387.JPG
folder_levels_to_preserve = 3

photo_points = st_read(photo_points_file)

for(i in 1:nrow(photo_points)) {
  
  photo_point = photo_points[i,]
  photo_path = photo_point$photo
  
  # get the folders and file separately
  photo_path_parts = str_split(photo_path, pattern = fixed("/"))[[1]]
  
  # take the last x number as specified
  nparts = length(photo_path_parts)
  photo_path_parts_to_copy = photo_path_parts[(nparts-folder_levels_to_preserve):nparts]
  photo_path_parts_sans_file = photo_path_parts[(nparts-folder_levels_to_preserve):(nparts-1)]
  
  rel_dest_path = do.call(file.path, as.list(photo_path_parts_to_copy))
  rel_dest_path_sans_file = do.call(file.path, as.list(photo_path_parts_sans_file))
  
  
  abs_dest_path = file.path(photo_subset_dest_folder, rel_dest_path)
  abs_dest_path_sans_file = file.path(photo_subset_dest_folder, rel_dest_path_sans_file)
  
  if(!dir.exists(abs_dest_path_sans_file)) {
    dir.create(abs_dest_path_sans_file, recursive = TRUE)
  }
  
  file.copy(photo_path,abs_dest_path)
  
}