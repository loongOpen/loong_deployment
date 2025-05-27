#!/bin/bash


if [ ! -e "../log" ]; then
	mkdir ../log
else
	echo 将删除最近20个以外的log文件
	cd ../log
	files=$(ls -lt | tail -n +21 | awk '{print $9}')
	for file in $files; do
		sudo rm -f "$file"
	done
fi
echo ==========

if [ "$(arch)" = "x86_64" ]; then
	tgtArch=x64
else
	tgtArch="a64"
fi

if [ $# -gt 0 ];then #参数不为零
	echo 仿真
	cd ../nabo_output
else
	cd ../bin
fi

sudo ./loong_driver_$tgtArch |sudo tee ../log/terminal_driver.txt

