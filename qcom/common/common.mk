$(call inherit-product, device/qcom/common/base.mk)

# For PRODUCT_COPY_FILES, the first instance takes precedence.
# Since we want use QC specific files, we should inherit
# device-vendor.mk first to make sure QC specific files gets installed.
$(call inherit-product-if-exists, $(QCPATH)/common/config/device-vendor.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

#xie lei change vendor name begin
PRODUCT_BRAND := EHANG
#xie lei change vendor name end
PRODUCT_AAPT_CONFIG += hdpi mdpi

ifndef PRODUCT_MANUFACTURER
PRODUCT_MANUFACTURER := QUALCOMM
endif

PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.extension_library=libqti-perfd-client.so \
    persist.radio.apm_sim_not_pwdn=1 \
    persist.radio.sib16_support=1 \
    persist.radio.custom_ecc=1 \
    ro.frp.pst=/dev/block/bootdevice/by-name/config

PRODUCT_PRIVATE_KEY := device/qcom/common/qcom.key

$(call inherit-product, frameworks/native/build/phone-xhdpi-1024-dalvik-heap.mk)
#$(call inherit-product, frameworks/base/data/fonts/fonts.mk)
#$(call inherit-product, frameworks/base/data/keyboards/keyboards.mk)

#For fota support
#$(call inherit-product-if-exists, product_config/3rd/FotaUpdateApp/FotaUpdate.mk)

#Graphite Security Space
$(call inherit-product-if-exists, vendor/graphiteplus/device-vendor.mk)
