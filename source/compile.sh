#!/bin/bash
# Clone Repository, clone submodules and make BaseTools for compiling OVMF
cd ${DATA_DIR}
git clone https://github.com/tianocore/edk2.git
cd ./edk2
git checkout ${LAT_V}
git submodule update --init
make -C BaseTools

# Compile OVMF with TPM (including Network TLS support) and Secure boot support
OvmfPkg/build.sh -b RELEASE -a X64 -t GCC5 -D TPM_ENABLE -D TPM_CONFIG_ENABLE -D SECURE_BOOT_ENABLE -D NETWORK_TLS_ENABLE
mkdir -p ${DATA_DIR}/${LAT_V}
mkdir -p ${DATA_DIR}/temp-${LAT_V}/usr/share/qemu/ovmf-x64
cp Build/OvmfX64/RELEASE_GCC5/FV/OVMF.fd ${DATA_DIR}/temp-${LAT_V}/usr/share/qemu/ovmf-x64/OVMF-pure-efi-tpm.fd
cp Build/OvmfX64/RELEASE_GCC5/FV/OVMF_CODE.fd ${DATA_DIR}/temp-${LAT_V}/usr/share/qemu/ovmf-x64/OVMF_CODE-pure-efi-tpm.fd
cp Build/OvmfX64/RELEASE_GCC5/FV/OVMF_VARS.fd ${DATA_DIR}/temp-${LAT_V}/usr/share/qemu/ovmf-x64/OVMF_VARS-pure-efi-tpm.fd
cd ${DATA_DIR}/temp-${LAT_V}

# Create tar package
tar -czvf ${DATA_DIR}/${LAT_V}/OVMF.tar.gz .

## Cleanup
rm -rf ${DATA_DIR}/edk2 ${DATA_DIR}/temp-${LAT_V}
chown $UID:$GID ${DATA_DIR}/$LAT_V/*
