# ebpf example

## 試す

```console
make generate-header # btfをvmlinuxから取得、importCできるように置換
make build # bpfプログラムをビルド
sudo bpftool prog loadall app.o /sys/fs/bpf/dexec autoattach
```

別のターミナルで実行:

```console
sudo bpftool prog tracelog
```

## 注意点

- 再ロードするときは `sudo rm -rf /sys/fs/bpf/dexec` で古いものを外しておく。
- `.eh.frame` まわりも生成される(bpfはunwind使わないので本来不要)のでskipされるよ警告が出るが、とりあえず実行に支障はない。
- D言語のcharはBTFで `DW_ATE_UTF` になる(BTFはDWARFのデバッグ情報の定義を流用してるので)、BTFはこの定義をサポートしてないので使えない。ubyteで回避するかupstreamのLLVMではなおってるらしいのでLDCをビルドし直すかすればいける。
