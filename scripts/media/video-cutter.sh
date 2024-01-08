#!/bin/bash


#ffmpeg -ss 0 -t 30 -i video-de-navidad.mp4  

ffmpeg -i video-de-navidad.mp4 -ss 00:00:00 -to 00:00:25 -c:v copy -c:a copy primer-video.mp4
ffmpeg -i video-de-navidad.mp4 -ss 00:00:25 -to 00:00:50 -c:v copy -c:a copy segundo-video.mp4
ffmpeg -i video-de-navidad.mp4 -ss 00:00:50 -to 00:01:30 -c:v copy -c:a copy tercer-video.mp4