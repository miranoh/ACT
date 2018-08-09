# trajectories
An Automatic Centroid Tracking tool for analyzing vocal tract actions in MRI speech production data

## Tracking a single object
### Demo
1. Once downloading __ARTiCenT__ ZIP folder from github, open _centroid.m_ in matlab
2. Copy <filename> (e.g., _'videos/velar_implosive.mp4'_) and paste it in line 11 (vidPath = ...)
3. Run centroid.m
4. Click and drag on the image to draw an ROI (as instructed in the command window)
5. Adjust the ROI (if necessary), and double-click on the ROI when finished editing
6. Click on the object you want to track (in the ROI), and press enter

Now you'll see an online traking of the object (vertical trajectories, mean intensity, etc).
The tracked data is saved in the __results__ folder with selected ROI and seed values as the filename.

### Your data
Add your video file in the __videos__ folder, and copy _'videos/<filename.format>'_ to line 11 (vidPath = ...).

## Tracking two objects
1. Open _centroid_2ROI.m_
2. Change the video file in line 11 (vidPath = ...)
3. Run _centroid_2ROI.m_
4. Repeat 4-6 above twice for two different ROIs

Now you'll see two objects being tracked (vertical movement).
Both horizontal and vertical trajectories are saved in the __results__ folder.
