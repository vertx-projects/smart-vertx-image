# smart-vertx-image
smart-vertx基础镜像
## 使用说明
1.直接执行以下命令在根目录构建：docker build -t smart-base:1.0.0 .
2.构建成功后新项目需要引用时直接新建dockerFile
```bash
from smart-base:1.0.0
```
3.构建自有镜像 docker build -t smart-vertx-applicaiton:1.0.0 .
4.启动自有镜像，支持传入环境变量如下：
```bash
JVM_PARAM --JVM启动需要的参数如：JVM_PARAM: -XX:+HeapDumpOnOutOfMemoryError -XX:+ExitOnOutOfMemoryError -XX:HeapDumpPath=./  -Xlog:gc:./gc.log
JVM_ARGS --main方法的args参数：args1=1 args2=2
```
