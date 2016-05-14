#!/bin/bash

clear

printf " --- UNIVERSAL INJECT GENERATOR v0.6 ---\n"
printf "          --- LINUX EDITION --- \n\n\n"

printf "[+] IDENTIFY SYSTEM ARCHITECTURE\n"
PLATFORM="$(uname)"

#Differentiate between 64 and 32 bit linux
if [ "$PLATFORM" == "Linux" ]
then PLATFORM="$PLATFORM-$(uname -m)"
fi

printf "[+] IDENTIFY FILES TO WORK WITH\n"
mv work work_old
rm -rf work_old
rm -rf hs.*
mkdir work
cat $2 > work/hs.app
./tools/ctrtool-"$PLATFORM" -x --contents work/ciacnt $1 &>/dev/null
mv work/ciacnt.0000.* work/inject.app

printf "[+] EXTRACT HS AND INJECT APP\n"
./tools/3dstool-"$PLATFORM" -x -f work/hs.app --header work/hs_hdr.bin --exh work/hs_exhdr.bin --plain work/hs_plain.bin --logo work/hs_logo.bin --exefs work/hs_exefs.bin &>/dev/null
./tools/3dstool-"$PLATFORM" -x -f work/inject.app --exh work/inject_exhdr.bin --exefs work/inject_exefs.bin --romfs work/inject_romfs.bin &>/dev/null
./tools/3dstool-"$PLATFORM" -x -f work/hs_exefs.bin --exefs-dir work/hs_exefs &>/dev/null
./tools/3dstool-"$PLATFORM" -x -f work/inject_exefs.bin --exefs-dir work/inject_exefs &>/dev/null

printf "[+] GENERATE NO BANNER EXEFS\n"
cp work/hs_exefs/banner.bnr work/inject_exefs/banner.bnr
./tools/3dstool-"$PLATFORM" -c -z -t exefs -f work/inject_no_banner_exefs.bin --exefs-dir work/inject_exefs --header work/inject_exefs.bin &>/dev/null

printf "[+] GENERATE DUMMY ROMFS\n"
mkdir work/dummy_romfs
cp tools/dummy.bin work/dummy_romfs/dummy.bin
./tools/3dstool-"$PLATFORM" -c -t romfs -f work/dummy_romfs.bin --romfs-dir work/dummy_romfs &>/dev/null
if [ ! -e work/inject_romfs.bin ]
then mv work/dummy_romfs.bin work/inject_romfs.bin
fi

printf "[+] MERGE EXHEADER\n"
./tools/MergeExHeader-"$PLATFORM" work/inject_exhdr.bin work/hs_exhdr.bin work/merge_exhdr.bin &>/dev/null

printf "[+] REBUILD HS INJECT APP\n"

if [ -e work/hs_logo.bin ]
then ./tools/3dstool-"$PLATFORM" -c -t cxi -f ${1%.*}_inject_no_banner.app --header work/hs_hdr.bin --exh work/merge_exhdr.bin --plain work/hs_plain.bin --logo work/hs_logo.bin --exefs work/inject_no_banner_exefs.bin --romfs work/inject_romfs.bin &>/dev/null
else ./tools/3dstool-"$PLATFORM" -c -t cxi -f ${1%.*}_inject_no_banner.app --header work/hs_hdr.bin --exh work/merge_exhdr.bin --plain work/hs_plain.bin --exefs work/inject_no_banner_exefs.bin --romfs work/inject_romfs.bin &>/dev/null
fi

if [ -e work/hs_logo.bin ]
then ./tools/3dstool-"$PLATFORM" -c -t cxi -f ${1%.*}_inject_with_banner.app --header work/hs_hdr.bin --exh work/merge_exhdr.bin --plain work/hs_plain.bin --logo work/hs_logo.bin --exefs work/inject_exefs.bin --romfs work/inject_romfs.bin &>/dev/null
else ./tools/3dstool-"$PLATFORM" -c -t cxi -f ${1%.*}_inject_with_banner.app --header work/hs_hdr.bin --exh work/merge_exhdr.bin --plain work/hs_plain.bin --exefs work/inject_exefs.bin --romfs work/inject_romfs.bin &>/dev/null
fi

for i in work/hs.app; do HS_ORIGINAL_SIZE=$(ls -l $i | awk '{print $5}'); done
for i in ${1%.*}_inject_no_banner.app; do HS_INJECT_N_SIZE=$(ls -l $i | awk '{print $5}'); done
for i in ${1%.*}_inject_with_banner.app; do HS_INJECT_B_SIZE=$(ls -l $i | awk '{print $5}'); done

mv ${1%.*}_inject_no_banner.app ./
mv ${1%.*}_inject_with_banner.app ./

printf "[+] HS APP ORIGINAL SIZE  : $HS_ORIGINAL_SIZE bytes\n"
printf "[+] HS APP INJECT (N) SIZE: $HS_INJECT_N_SIZE bytes\n"

if [ $HS_ORIGINAL_SIZE -lt $HS_INJECT_N_SIZE ]
then printf "/!\ INJECT APP IS BIGGER THAN HS APP\n"
fi

printf "[+] HS APP INJECT (B) SIZE: $HS_INJECT_B_SIZE bytes\n"

if [ $HS_ORIGINAL_SIZE -lt $HS_INJECT_B_SIZE ]
then printf "/!\ INJECT APP IS BIGGER THAN HS APP\n"
fi
