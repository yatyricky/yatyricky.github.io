ffmpeg.exe -i input.flac -acodec alac output.m4a
ffmpeg.exe -i input -c:a pcm_s24be out.aiff
ffmpeg.exe -i input -c:a pcm_s24le out.wav