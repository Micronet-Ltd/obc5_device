/*
   Copyright (c) 2014, The Linux Foundation. All rights reserved.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are
   met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials provided
      with the distribution.
    * Neither the name of The Linux Foundation nor the names of its
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

   THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
   WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
   ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
   BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
   BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
   WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
   OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
   IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

#include "vendor_init.h"
#include "property_service.h"
#include "log.h"
#include "util.h"

#include "init_msm.h"

#define VIRTUAL_SIZE "/sys/class/graphics/fb0/virtual_size"
#define BUF_SIZE 64

void init_msm_properties(unsigned long msm_id, unsigned long msm_ver, char *board_type)
{
    char platform[PROP_VALUE_MAX];
    char cpusys[BUF_SIZE];
    char *pcpu;
    int rc, cpuid, fd;
    unsigned long virtual_size = 0;
    char str[BUF_SIZE];

    UNUSED(msm_id);
    UNUSED(msm_ver);

    rc = property_get("ro.board.platform", platform);
    if (!rc || !ISMATCH(platform, ANDROID_TARGET)){
        return;
    }

    rc = read_file2(VIRTUAL_SIZE, str, sizeof(str));
    if (rc) {
        virtual_size = strtoul(str, NULL, 0);
    }

    if(virtual_size >= 1080) {
        if (ISMATCH(board_type, "SBC")) {
            property_set(PROP_LCDDENSITY, "240");
            property_set(PROP_QEMU_NAVKEY, "0");
        } else
            property_set(PROP_LCDDENSITY, "480");
    } else if (virtual_size >= 720) {
        // For 720x1280 resolution
        property_set(PROP_LCDDENSITY, "320");
    } else if (virtual_size >= 480) {
        // For 480x854 resolution QRD.
        property_set(PROP_LCDDENSITY, "240");
    } else
        property_set(PROP_LCDDENSITY, "320");

    if (msm_id >= 239 && msm_id <= 243) {
        property_set("media.msm8939hw", "1");
    }

    if (msm_id >= 268 && msm_id <= 271) {
        property_set("media.msm8929hw", "1");
    }

    if (msm_id == 206) {
        property_set("vidc.enc.narrow.searchrange", "0");
    }	

    switch(msm_id){
        case 239:
        case 241:
        case 263:
            if (property_get("ro.earlyboot_cpus", platform)) {
                pcpu = platform;
                ERROR("ro.earlyboot_cpus:%s\n", pcpu);
                while (*pcpu) {
                    if (*pcpu > '0' && *pcpu < '8') {
                        cpuid = *pcpu - '0';
                        snprintf(cpusys, sizeof(cpusys), "/sys/devices/system/cpu/cpu%d/online", cpuid);
                        fd = open(cpusys, O_RDWR);
                        if (fd < 0) {
                            ERROR("Failed to open %s\n", cpusys);
                            return;
                        }
                        rc = write(fd, "1", 1);
                        if (rc < 0) {
                            ERROR("Failed to write %s\n", cpusys);
                        }
                        close(fd);
                    }
                    pcpu++;
                }
            }
            break;
    }
}
