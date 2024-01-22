### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# global properties
properties() { '
kernel.string=ExampleKernel by osm0sis @ xda-developers
kernel.for=KernelForDriver
kernel.compiler=SDPG
kernel.made=User @Host
kernel.version=4.4.xxx
message.word=ooflol
build.date=2077
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=X00TD
device.name2=X00T
device.name3=Zenfone Max Pro M1 (X00TD)
device.name4=ASUS_X00TD
device.name5=ASUS_X00T
supported.versions=
supported.patchlevels=
'; } # end properties

### AnyKernel install
## boot files attributes
boot_attributes() {
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 755 755 $ramdisk/init* $ramdisk/sbin;
} # end attributes


block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh;

# Put Android Version on cmdline
android_ver=$(file_getprop /system/build.prop ro.build.version.release);
patch_cmdline androidboot.version androidboot.version=$android_ver

# boot install
dump_boot; # use split_boot to skip ramdisk unpack, e.g. for devices with init_boot ramdisk

#Remove old kernel stuffs from ramdisk
 rm -rf $ramdisk/init.special_power.sh
 rm -rf $ramdisk/init.darkonah.rc
 rm -rf $ramdisk/init.spectrum.rc
 rm -rf $ramdisk/init.spectrum.sh
 rm -rf $ramdisk/init.boost.rc
 rm -rf $ramdisk/init.trb.rc
 rm -rf $ramdisk/init.azure.rc
 rm -rf $ramdisk/init.PBH.rc
 rm -rf $ramdisk/init.Pbh.rc
 rm -rf $ramdisk/init.overdose.rc

backup_file init.rc;
remove_line init.rc "import /init.darkonah.rc";
remove_line init.rc "import /init.spectrum.rc";
remove_line init.rc "import /init.boost.rc";
remove_line init.rc "import /init.trb.rc"
remove_line init.rc "import /init.azure.rc"
remove_line init.rc "import /init.PbH.rc"
remove_line init.rc "import /init.Pbh.rc"
remove_line init.rc "import /init.overdose.rc"
replace_string init.rc "cpuctl cpu,timer_slack" "mount cgroup none /dev/cpuctl cpu" "mount cgroup none /dev/cpuctl cpu,timer_slack";

# init.tuna.rc
backup_file init.tuna.rc;
insert_line init.tuna.rc "nodiratime barrier=0" after "mount_all /fstab.tuna" "\tmount ext4 /dev/block/platform/omap/omap_hsmmc.0/by-name/userdata /data remount nosuid nodev noatime nodiratime barrier=0";
append_file init.tuna.rc "bootscript" init.tuna;

# fstab.tuna
backup_file fstab.tuna;
patch_fstab fstab.tuna /system ext4 options "noatime,barrier=1" "noatime,nodiratime,barrier=0";
patch_fstab fstab.tuna /cache ext4 options "barrier=1" "barrier=0,nomblk_io_submit";
patch_fstab fstab.tuna /data ext4 options "data=ordered" "nomblk_io_submit,data=writeback";
append_file fstab.tuna "usbdisk" fstab;

# remove spectrum profile
if [ -e $ramdisk/init.spectrum.rc ];then
  rm -rf $ramdisk/init.spectrum.rc
  ui_print "delete /init.spectrum.rc"
fi
if [ -e $ramdisk/init.spectrum.sh ];then
  rm -rf $ramdisk/init.spectrum.sh
  ui_print "delete /init.spectrum.sh"
fi
if [ -e $ramdisk/sbin/init.spectrum.rc ];then
  rm -rf $ramdisk/sbin/init.spectrum.rc
  ui_print "delete /sbin/init.spectrum.rc"
fi
if [ -e $ramdisk/sbin/init.spectrum.sh ];then
  rm -rf $ramdisk/sbin/init.spectrum.sh
  ui_print "delete /sbin/init.spectrum.sh"
fi
if [ -e $ramdisk/etc/init.spectrum.rc ];then
  rm -rf $ramdisk/etc/init.spectrum.rc
  ui_print "delete /etc/init.spectrum.rc"
fi
if [ -e $ramdisk/etc/init.spectrum.sh ];then
  rm -rf $ramdisk/etc/init.spectrum.sh
  ui_print "delete /etc/init.spectrum.sh"
fi
if [ -e $ramdisk/init.aurora.rc ];then
  rm -rf $ramdisk/init.aurora.rc
  ui_print "delete /init.aurora.rc"
fi
if [ -e $ramdisk/sbin/init.aurora.rc ];then
  rm -rf $ramdisk/sbin/init.aurora.rc
  ui_print "delete /sbin/init.aurora.rc"
fi
if [ -e $ramdisk/etc/init.aurora.rc ];then
  rm -rf $ramdisk/etc/init.aurora.rc
  ui_print "delete /etc/init.aurora.rc"
fi

# rearm perfboostsconfig.xml
if [ ! -f /vendor/etc/perf/perfboostsconfig.xml ]; then
	mv /vendor/etc/perf/perfboostsconfig.xml.bak /vendor/etc/perf/perfboostsconfig.xml;
	mv /vendor/etc/perf/perfboostsconfig.xml.bkp /vendor/etc/perf/perfboostsconfig.xml;
fi

# rearm commonresourceconfigs.xml
if [ ! -f /vendor/etc/perf/commonresourceconfigs.xml ]; then
	mv /vendor/etc/perf/commonresourceconfigs.xml.bak /vendor/etc/perf/commonresourceconfigs.xml;
	mv /vendor/etc/perf/commonresourceconfigs.xml.bkp /vendor/etc/perf/commonresourceconfigs.xml;
fi

# rearm targetconfig.xml
if [ ! -f /vendor/etc/perf/targetconfig.xml ]; then
	mv /vendor/etc/perf/targetconfig.xml.bak /vendor/etc/perf/targetconfig.xml;
	mv /vendor/etc/perf/targetconfig.xml.bkp /vendor/etc/perf/targetconfig.xml;
fi

# rearm targetresourceconfigs.xml
if [ ! -f /vendor/etc/perf/targetresourceconfigs.xml ]; then
	mv /vendor/etc/perf/targetresourceconfigs.xml.bak /vendor/etc/perf/targetresourceconfigs.xml;
	mv /vendor/etc/perf/targetresourceconfigs.xml.bkp /vendor/etc/perf/targetresourceconfigs.xml;
fi

# rearm powerhint.xml
if [ ! -f /vendor/etc/powerhint.xml ]; then
	mv /vendor/etc/powerhint.xml.bak /vendor/etc/powerhint.xml;
	mv /vendor/etc/powerhint.xml.bkp /vendor/etc/powerhint.xml;
fi
# end ramdisk changes

write_boot; # use flash_boot to skip ramdisk repack, e.g. for devices with init_boot ramdisk
## end boot install
