# smart-vertx-image
smart-vertx基础镜像
## 使用说明
1. 直接执行以下命令在根目录构建：docker build -t smart-base:1.0.0 .
2. 构建成功后新项目需要引用时直接新建dockerFile
```bash
from smart-base:1.0.0
```
3. 构建自有镜像 docker build -t smart-vertx-applicaiton:1.0.0 .
4. 启动自有镜像，支持传入环境变量如下：
```bash
JVM_PARAM --JVM启动需要的参数如：JVM_PARAM: -XX:+HeapDumpOnOutOfMemoryError -XX:+ExitOnOutOfMemoryError -XX:HeapDumpPath=./  -Xlog:gc:./gc.log
JVM_ARGS --main方法的args参数：JVM_ARGS: args1=1 args2=2
基础镜像集成了阿里arthas,进入容器直接执行 [listen.jvm.sh] 脚本即可实现attach JVM进程
```
![image](https://github.com/vertx-projects/smart-vertx-image/assets/139456680/2314fca9-26fb-4203-877c-d481f80cffe1)

