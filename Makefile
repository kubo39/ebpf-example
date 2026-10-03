LDC := ldc2

.PHONY: generate-header
generate-header: vmlinux_d.h

.PHONY: vmlinux_d.h
vmlinux_d.h: vmlinux.h
	sed -E \
	  -e 's/^typedef __int128 unsigned (\w+);/typedef struct { unsigned long long _v[2]; } __attribute__((aligned(16))) \1;/' \
	  -e 's/^enum (\w+);$$/enum \1 { \1___fwd };/' \
	  $< > $@

.PHONY: vmlinux.h
vmlinux.h:
	bpftool btf dump file /sys/kernel/btf/vmlinux format c > $@

.PHONY: build
build:
	$(LDC) -mtriple=bpfel-unknown-linux-gnu \
		-betterC -O2 -g -gcc=clang -P=-I/usr/include/bpf \
		-singleobj -c app.d helper.c

.PHONY: clean
clean:
	$(RM) *.o
