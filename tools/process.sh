#!/bin/bash

clear

printf " --- UNIVERSAL INJECT GENERATOR V0.3 ---\n"
printf "          --- LINUX EDITION --- \n\n\n"

printf "[+] IDENTIFY FILES TO WORK WITH\n"
mv work work_old
rm -rf work_old
rm -rf hs.*
mkdir work
cp $2 work/hs.app
./tools/ctrtool-linux -x --contents work/ciacnt $1
mv work/ciacnt.0000.* work/inject.app

printf "[+] EXTRACT HS AND INJECT APP\n"
tools/3dstool-linux -x -f work/hs.app --header work/hs_hdr.bin --exh work/hs_exhdr.bin --plain work/hs_plain.bin --logo work/hs_logo.bin --exefs work/hs_exefs.bin --romfs work/hs_romfs.bin
tools/3dstool-linux -x -f work/inject.app --exh work/inject_exhdr.bin --exefs work/inject_exefs.bin
tools/3dstool-linux -x -f work/hs_exefs.bin --exefs-dir work/hs_exefs
tools/3dstool-linux -x -f work/inject_exefs.bin --exefs-dir work/inject_exefs

printf "[+] GENERATE NEW EXEFS\n"
cp work/inject_exefs/code.bin work/hs_exefs/code.bin
tools/3dstool-linux -c -z -t exefs -f work/hs_mod_exefs.bin --exefs-dir work/hs_exefs --header work/hs_exefs.bin
cp work/inject_exefs/banner.bnr work/hs_exefs/banner.bnr
cp work/inject_exefs/icon.icn work/hs_exefs/icon.icn
tools/3dstool-linux -c -z -t exefs -f work/hs_mod_banner_exefs.bin --exefs-dir work/hs_exefs --header work/hs_exefs.bin

printf "[+] GENERATE NEW ROMFS\n"
mkdir work/dummy_romfs
dd if=/dev/zero of=work/dummy_romfs/dummy.bin bs=1 count=16
tools/3dstool-linux -c -t romfs -f work/dummy_romfs.bin --romfs-dir work/dummy_romfs

printf "[+] MERGE EXHEADER\n"
tools/MergeExHeader-linux work/inject_exhdr.bin work/hs_exhdr.bin work/merge_exhdr.bin

printf "[+] REBUILD HS INJECT APP\n"

if [ -e work/hs_logo.bin ]
then tools/3dstool-linux -c -t cxi -f ${1%.*}_inject_no_banner.app --header work/hs_hdr.bin --exh work/merge_exhdr.bin --plain work/hs_plain.bin --logo work/hs_logo.bin --exefs work/hs_mod_exefs.bin --romfs work/dummy_romfs.bin 
else tools/3dstool-linux -c -t cxi -f ${1%.*}_inject_no_banner.app --header work/hs_hdr.bin --exh work/merge_exhdr.bin --plain work/hs_plain.bin --exefs work/hs_mod_exefs.bin --romfs work/dummy_romfs.bin
fi

if [ -e work/hs_logo.bin ]
then tools/3dstool-linux -c -t cxi -f ${1%.*}_inject_with_banner.app --header work/hs_hdr.bin --exh work/merge_exhdr.bin --plain work/hs_plain.bin --logo work/hs_logo.bin --exefs work/hs_mod_banner_exefs.bin --romfs work/dummy_romfs.bin
else tools/3dstool-linux -c -t cxi -f ${1%.*}_inject_with_banner.app --header work/hs_hdr.bin --exh work/merge_exhdr.bin --plain work/hs_plain.bin --exefs work/hs_mod_banner_exefs.bin --romfs work/dummy_romfs.bin
fi

for i in work/hs.app; do HS_ORIGINAL_SIZE=$(stat -c %s $i); done
for i in ${1%.*}_inject_no_banner.app; do HS_INJECT_N_SIZE=$(stat -c %s $i); done
for i in ${1%.*}_inject_with_banner.app; do HS_INJECT_B_SIZE=$(stat -c %s $i); done

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
