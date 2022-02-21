all:	
	nasm -fbin src/x86/boot/bootloader.asm -o bin/bootloader.bin
	nasm -felf src/x86/kernel/kernel.asm -o objres/kernelasm.o
	kesslang -no-exit -c -bits-32 -o objres/kmain.o src/x86/kernel/kmain.kess
	ld -melf_i386 -Tlink.ld objres/*.o --oformat binary -o bin/kernel.bin
	cat bin/bootloader.bin bin/kernel.bin > bin/KessOS.bin
	@ # Prepare the image.
	sudo dd if=/dev/zero of=KessOS.img bs=1024 count=1440
	@ # Put the OS stuff in the image.
	sudo dd if=bin/KessOS.bin of=KessOS.img

burn_usb:
	sudo dd if=KessOS.img of=/dev/sdb

danger:
	make all burn_usb run


run:
	sudo qemu-system-x86_64 -hda /dev/sdb -monitor stdio -d int -no-reboot -D logfile.txt -M smm=off
