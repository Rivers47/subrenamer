#!/bin/bash

sub_epi_regex='(?<=\[)\d\d(?=\])'
sub_extension_regex='\..*'
video_epi_regex='(?<=\[)\d\d(?=\])'
video_extension="mkv"
subtitle_extension="ass"
padding=
while getopts ":1:2:e:x:f:s:t:phv" option; do
   case $option in
      1) 
		  first_half="$OPTARG";;
	  2) 
		  second_half="$OPTARG";;
	  e)
	  	  sub_epi_regex="$OPTARG";;
	  t)
		  video_epi_regex="$OPTARG";;
	  x)
		  sub_extension_regex="$OPTARG";;
	  f)
		  video_extension="$OPTARG";;
	  s)
		  subtitle_extension="$OPTARG";;
	  p)
		  padding=$OPTARG;;
	  h)
          echo "-e subtitle_episode_regex [$sub_epi_regex] -x sub_extension_regex [$sub_extension_regex] -t video_episode_regex [$video_epi_regex] -f video_extension [$video_extension] -s subtitle_extension [$subtitle_extension] -[v]"
		  exit;; 
	  v)
		  test_run=true;;
  esac
done

echo get arguments:
echo "video fist half: $first_half"
echo "video second half: $second_half"
echo "subtitle episode regex: $sub_epi_regex"
echo "extension regex: $sub_extension_regex"
echo "video episode regex: $video_epi_regex"
echo 

if [ -z $test_run ] ; then
	mkdir -p 'done'
fi

count=0
for file in *".$subtitle_extension"
do
#	echo '************************************'
	echo Processing: "$file"
	epi=$(echo $file | grep -Po "$sub_epi_regex")
	extension=$(echo $file | grep -Po "$sub_extension_regex")
#	epi=${epi:1:2}
#	epi=${epi:1} #delete one char from both end
#	epi=${epi%?}
	if [ $padding ]
	then
		echo padding width $padding
		epi=$(printf "%0${padding}d" $epi)
	fi
	echo "Episode $epi"
	for video in *".$video_extension"
	do
		v_epi=$(echo $video | grep -Po "$video_epi_regex")
		if [[ $epi == $v_epi ]]
		then
			first_half=$(echo $video | grep -Po ".*(?=$video_epi_regex)")
			second_half=$(echo $video | grep -Po "(?<=$video_epi_regex).*(?=\.$video_extension)")
			break
		fi
	
	done
	echo -e "→\e[38;5;117m$first_half\e[38;5;164m$epi\e[38;5;183m$second_half\e[38;5;11m$extension\e[0m"
	name="$first_half$epi$second_half$extension"
	if [ -z $test_run ]
	then
	    cp -l "$file" "./done/$name"
	fi
#	echo '***********************************'
	echo 
	let count=count+1
done
if [ -z $test_run ]
then
	echo Processed $count files
fi
