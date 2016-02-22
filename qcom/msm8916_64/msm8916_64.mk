DEVICE_PACKAGE_OVERLAYS := device/qcom/msm8916_64/overlay

TARGET_USES_QCOM_BSP := true
TARGET_HAS_NFC_CUSTOM_CONFIG := true
# Add QC Video Enhancements flag
TARGET_ENABLE_QC_AV_ENHANCEMENTS := true

DEVICE_PACKAGE_OVERLAYS := device/qcom/msm8916_64/overlay

#add by lyf for product_config begin
include product_config/product_config.mk
#add by lyf for product_config end


#QTIC flag
-include $(QCPATH)/common/config/qtic-config.mk

# media_profiles and media_codecs xmls for 8916
ifeq ($(TARGET_ENABLE_QC_AV_ENHANCEMENTS), true)
PRODUCT_COPY_FILES += device/qcom/msm8916_32/media/media_profiles_8916.xml:system/etc/media_profiles.xml \
                      device/qcom/msm8916_32/media/media_codecs_8916.xml:system/etc/media_codecs.xml \
                      device/qcom/msm8916_32/media/media_codecs_8939.xml:system/etc/media_codecs_8939.xml \
                      device/qcom/msm8916_32/media/media_codecs_8929.xml:system/etc/media_codecs_8929.xml
endif

TARGET_USES_QCA_NFC := false

PRODUCT_PROPERTY_OVERRIDES += \
           dalvik.vm.heapgrowthlimit=128m
$(call inherit-product, device/qcom/common/common64.mk)

PRODUCT_NAME := msm8916_64
PRODUCT_DEVICE := msm8916_64
#PRODUCT_BRAND := Android
#PRODUCT_MODEL := MSM8916 for arm64

ifeq ($(strip $(TARGET_USES_QTIC)),true)
# font rendering engine feature switch
-include $(QCPATH)/common/config/rendering-engine.mk
ifneq (,$(strip $(wildcard $(PRODUCT_RENDERING_ENGINE_REVLIB))))
# remove to fix open big file error in htmlviewer 
#    MULTI_LANG_ENGINE := REVERIE
endif
endif

PRODUCT_BOOT_JARS += qcmediaplayer \
                     WfdCommon \
                     qcom.fmradio \
                     oem-services
PRODUCT_BOOT_JARS += vcard
PRODUCT_BOOT_JARS += tcmiface

# default is nosdcard, S/W button enabled in resource
#PRODUCT_CHARACTERISTICS := nosdcard

#Android EGL implementation
PRODUCT_PACKAGES += libGLES_android

PRODUCT_PACKAGES += \
    libqcomvisualizer \
    libqcompostprocbundle \
    libqcomvoiceprocessing

# Audio configuration file
PRODUCT_COPY_FILES += \
    device/qcom/msm8916_32/audio_policy.conf:system/etc/audio_policy.conf \
    device/qcom/msm8916_32/audio_effects.conf:system/vendor/etc/audio_effects.conf \
    device/qcom/msm8916_32/mixer_paths_mtp.xml:system/etc/mixer_paths_mtp.xml \
    device/qcom/msm8916_32/mixer_paths_qrd_skuh.xml:system/etc/mixer_paths_qrd_skuh.xml \
    device/qcom/msm8916_32/mixer_paths_qrd_skui.xml:system/etc/mixer_paths_qrd_skui.xml \
    device/qcom/msm8916_32/mixer_paths_qrd_skuhf.xml:system/etc/mixer_paths_qrd_skuhf.xml \
    device/qcom/msm8916_32/mixer_paths_wcd9306.xml:system/etc/mixer_paths_wcd9306.xml \
    device/qcom/msm8916_32/mixer_paths_skuk.xml:system/etc/mixer_paths_skuk.xml \
    device/qcom/msm8916_32/mixer_paths_skul.xml:system/etc/mixer_paths_skul.xml \
    device/qcom/msm8916_32/mixer_paths.xml:system/etc/mixer_paths.xml \
    device/qcom/msm8916_32/sound_trigger_mixer_paths.xml:system/etc/sound_trigger_mixer_paths.xml \
    device/qcom/msm8916_32/sound_trigger_mixer_paths_wcd9306.xml:system/etc/sound_trigger_mixer_paths_wcd9306.xml \
    device/qcom/msm8916_32/sound_trigger_platform_info.xml:system/etc/sound_trigger_platform_info.xml \
    device/qcom/msm8916_64/aanc_tuning_mixer.txt:system/etc/aanc_tuning_mixer.txt


#ANT+ stack
PRODUCT_PACKAGES += \
    AntHalService \
    libantradio \
    antradio_app
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    camera2.portability.force_api=1
PRODUCT_PACKAGES += wcnss_service

# MSM IRQ Balancer configuration file
PRODUCT_COPY_FILES += \
    device/qcom/msm8916_64/msm_irqbalance.conf:system/vendor/etc/msm_irqbalance.conf

#wlan driver
PRODUCT_COPY_FILES += \
    device/qcom/msm8916_64/WCNSS_qcom_cfg.ini:system/etc/wifi/WCNSS_qcom_cfg.ini \
    device/qcom/msm8916_64/WCNSS_wlan_dictionary.dat:persist/WCNSS_wlan_dictionary.dat \
    device/qcom/msm8916_64/WCNSS_qcom_wlan_nv.bin:persist/WCNSS_qcom_wlan_nv.bin

PRODUCT_PACKAGES += \
    wpa_supplicant_overlay.conf \
    p2p_supplicant_overlay.conf

PRODUCT_COPY_FILES += \
    device/qcom/msm8916_64/.bt_nv.bin:persist/.bt_nv.bin
	
# NFC packages
ifeq ($(TARGET_HAS_NFC_CUSTOM_CONFIG),true)

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.nfc.xml:system/etc/permissions/android.hardware.nfc.xml \
    frameworks/native/data/etc/android.hardware.nfc.hce.xml:system/etc/permissions/android.hardware.nfc.hce.xml \
    device/qcom/msm8916_64/nfc/libnfc-brcm.conf:system/etc/libnfc-brcm.conf \
    device/qcom/msm8916_64/nfc/libnfc-nxp-PN547C2_example.conf:system/etc/libnfc-nxp.conf \
	device/qcom/msm8916_64/nfc/route_example.xml:system/etc/param/router.xml \
	device/qcom/msm8916_64/nfc/libpn547_fw.so:/system/vendor/firmware/libpn547_fw.so 
   
ifeq ($(TARGET_BUILD_VARIANT),user)
    NFCEE_ACCESS_PATH := device/qcom/msm8916_64/nfc/nfcee_access.xml
else
    NFCEE_ACCESS_PATH := device/qcom/msm8916_64/nfc/nfcee_access_debug.xml
endif

PRODUCT_COPY_FILES += \
    $(NFCEE_ACCESS_PATH):system/etc/nfcee_access.xml	

# NFC packages
PRODUCT_PACKAGES += \
    libnfc-nci \
	libnfc_nci_jni \
	nfc_nci.pn54x.default\
	NfcNci \
	Tag \
	com.android.nfc_extras   

TARGET_ENABLE_SMARTCARD_SERVICE := false
ifeq ($(TARGET_ENABLE_SMARTCARD_SERVICE),true)
PRODUCT_PACKAGES += \
    SmartcardService \
    org.simalliance.openmobileapi \
    org.simalliance.openmobileapi.xml
#PRODUCT_BOOT_JARS += org.simalliance.openmobileapi:com.android.nfc_extras:com.gsma.services.nfc
# SmartcardService, SIM1,SIM2,eSE1 not including eSE2,SD1 as default
ADDITIONAL_BUILD_PROPERTIES += persist.nfc.smartcard.config=SIM1,SIM2,eSE1
endif

# Broadcom-proprietary interfaces and API's
PRODUCT_PACKAGES += \
    com.broadcom.nfc \
    com.broadcom.nfc.xml

# Broadcom implements AID-filter feature for Verizon
PRODUCT_PACKAGES += \
    com.vzw.nfc \
    com.vzw.nfc.xml \
	AidFilterTester

# NFC EXTRAS add-on API

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/com.android.nfc_extras.xml:system/etc/permissions/com.android.nfc_extras.xml
endif #TARGET_USES_BRCM_NFC

#added by xuegang
PRODUCT_PACKAGES += QrtFactoryKit

#NXP smart
PRODUCT_PACKAGES += climax_hostSW
PRODUCT_PACKAGES += tfa9897
PRODUCT_PACKAGES += libtfa9897

#CANbus tools
PRODUCT_PACKAGES += \
	libcan \
	candump \
	cansend \
	bcmserver \
	can-calc-bit-timing \
	canbusload \
	canfdtest \
	cangen \
	cangw \
	canlogserver \
	canplayer \
	cansniffer \
	isotpdump \
	isotprecv \
	isotpsend \
	isotpserver \
	isotpsniffer \
	isotptun \
	isotpperf \
	log2asc \
	log2long \
	slcan_attach \
	slcand \
	slcanpty

PRODUCT_COPY_FILES += device/qcom/msm8916_64/Tfa98xx.cnt:system/etc/Tfa98xx.cnt
# Defined the locales
PRODUCT_LOCALES += th_TH vi_VN tl_PH hi_IN ar_EG ru_RU tr_TR pt_BR bn_IN mr_IN ta_IN te_IN zh_HK \
        in_ID my_MM km_KH sw_KE uk_UA pl_PL sr_RS sl_SI fa_IR kn_IN ml_IN ur_IN gu_IN or_IN

# Add the overlay path
ifeq ($(strip $(TARGET_USES_QTIC)),true)
PRODUCT_PACKAGE_OVERLAYS := $(QCPATH)/qrdplus/Extension/res-overlay \
        $(PRODUCT_PACKAGE_OVERLAYS)
endif

#added by shengweiguang for cd-rom iso copy begin 2015/10/27 begin
PRODUCT_COPY_FILES += device/qcom/msm8916_32/EHANGAUTOINST.ISO:system/etc/EHANGAUTOINST.ISO
#added by shengweiguang for cd-rom iso copy end	 2015/10/27  end

PRODUCT_SUPPORTS_VERITY := true
PRODUCT_SYSTEM_VERITY_PARTITION := /dev/block/bootdevice/by-name/system
