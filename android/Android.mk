#
# Copyright (C) 2019-2021 The Android-x86 Open Source Project
#
# Licensed under the GNU General Public License Version 2 or later.
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.gnu.org/licenses/gpl.html
#

LOCAL_PATH := $(dir $(call my-dir))

# Build version.h
include $(CLEAR_VARS)

LOCAL_MODULE := alsa_utils_headers
LOCAL_MODULE_CLASS := HEADER_LIBRARIES

intermediates := $(call local-generated-sources-dir)

GEN := $(intermediates)/version.h
$(GEN): $(LOCAL_PATH)configure.ac
	@mkdir -p $(@D); \
	sed -n "/^AC_INIT.* \([0-9.]*\))/s//\#define SND_UTIL_VERSION_STR \"\1\"/p" $< > $@

LOCAL_GENERATED_SOURCES := $(GEN)

# Common flags
ALSA_UTILS_CFLAGS := \
	-Wno-absolute-value -Wno-enum-conversion -Wno-missing-field-initializers \
	-Wno-parentheses -Wno-pointer-arith -Wno-sign-compare \
	-Wno-unused-parameter -Wno-unused-variable

LOCAL_EXPORT_C_INCLUDE_DIRS := \
	$(dir $(GEN)) \
	$(LOCAL_PATH)include \
	$(LOCAL_PATH)android

include $(BUILD_HEADER_LIBRARY)

# Build amixer command
include $(CLEAR_VARS)

LOCAL_CFLAGS := $(ALSA_UTILS_CFLAGS) -D_GNU_SOURCE

LOCAL_SRC_FILES := \
	amixer/amixer.c \
	amixer/volume_mapping.c

LOCAL_MODULE := alsa_amixer
LOCAL_SHARED_LIBRARIES := libasound
LOCAL_HEADER_LIBRARIES := alsa_utils_headers

include $(BUILD_EXECUTABLE)

# Build aplay command
include $(CLEAR_VARS)

LOCAL_CFLAGS := $(ALSA_UTILS_CFLAGS)

LOCAL_SRC_FILES := \
	aplay/aplay.c

LOCAL_MODULE := alsa_aplay
LOCAL_SHARED_LIBRARIES := libasound
LOCAL_HEADER_LIBRARIES := alsa_utils_headers

include $(BUILD_EXECUTABLE)

# Build alsactl command
include $(CLEAR_VARS)

LOCAL_CFLAGS := $(ALSA_UTILS_CFLAGS) \
	-DSYS_ASOUNDRC=\"/data/local/tmp/asound.state\" \
	-DSYS_LOCKFILE=\"/data/local/tmp/asound.state.lock\" \
	-DSYS_PIDFILE=\"/data/local/tmp/alsactl.pid\"

LOCAL_SRC_FILES := $(addprefix alsactl/,\
	alsactl.c \
	clean.c \
	daemon.c \
	init_parse.c \
	init_ucm.c \
	lock.c \
	monitor.c \
	state.c \
	utils.c)

LOCAL_MODULE := alsa_ctl
LOCAL_SHARED_LIBRARIES := libasound
LOCAL_HEADER_LIBRARIES := alsa_utils_headers

include $(BUILD_EXECUTABLE)

# Build alsaucm command
include $(CLEAR_VARS)

LOCAL_CFLAGS := $(ALSA_UTILS_CFLAGS)

LOCAL_SRC_FILES := \
        alsaucm/dump.c \
        alsaucm/usecase.c \

LOCAL_MODULE := alsa_ucm
LOCAL_SHARED_LIBRARIES := libasound
LOCAL_HEADER_LIBRARIES := alsa_utils_headers

include $(BUILD_EXECUTABLE)
