# docker build -t uefi .
FROM ubuntu:16.04
LABEL maintainer "Adrian L. Shaw <adrian.l.shaw@gmail.com" 

RUN apt-get update -qq && apt-get install -y \
qemu-system-x86 ovmf udev dosfstools gnu-efi parted mtools make gcc
WORKDIR /uefi/

RUN dd if=/dev/zero of=uefi.img bs=512 count=93750 && \
parted uefi.img -s -a minimal mklabel gpt && \
parted uefi.img -s -a minimal mkpart EFI FAT16 2048s 93716s && \
parted uefi.img -s -a minimal toggle 1 boot

ENTRYPOINT [ "make", "qemu" ]
