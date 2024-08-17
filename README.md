# NixOS Config


## 查看与清理历史数据
### 查询当前可用的所有历史版本
```shell
nix profile history --profile /nix/var/nix/profiles/system
```

### 清理历史版本释放存储空间
```shell
# 清理 7 天之前的所有历史版本
sudo nix profile wipe-history --older-than 7d --profile /nix/var/nix/profiles/system
# 清理历史版本并不会删除数据，还需要手动 gc 下
sudo nix-collect-garbage --delete-old
```