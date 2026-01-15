# 训推平台部署

训推平台相关组件说明[参考](https://taichuai.feishu.cn/wiki/UBRFwKeu3ieqjnkohwaczKWHnlg?sheet=FYJvEj)

# 训推平台组成部分

* taichu-studio
* taichu-web
* taichu-maas
* logging
* minio
* nacos

```


modelscope download --model Qwen/Qwen3-4B-Instruct-2507 --local_dir ./


rsync -avz --exclude '*.sql' --exclude '.git' ~/work/code/py_code/taichuai/app-deployment app:/root/
rsync -avz --exclude 'training/data/*.sql' ~/work/code/py_code/taichuai/app-deployment app:/root/

git config --global --add safe.directory /root/app-deployment


docker run -ti --rm -v /Users/huzhi/work/code/py_code/taichuai/app-deployment/training/models:/models -w /models \
python:3.12.1-bullseye bash





```
