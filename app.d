import ldc.attributes : section;
import helper;

extern (C):

@section("license") __gshared ubyte[4] _lisence = [0x47, 0x50, 0x4c, 0x0]; // GPL\0

@section("kprobe/wake_up_new_task")
int on_new_task(pt_regs* ctx)
{
    auto t = cast(task_struct*) ctx.di; // rdi: 第一引数
    int pid, tgid;
    bpf_probe_read_kernel(&pid, pid.sizeof, &t.pid);
    bpf_probe_read_kernel(&tgid, tgid.sizeof, &t.tgid);

    immutable fmt = "D kprobe: new task pid=%d tgid=%d";
    bpf_trace_printk(fmt.ptr, fmt.length + 1, pid, tgid);

    return 0;
}
