#!/bin/bash

java ${JVM_PARAM} --add-opens  java.base/java.lang=ALL-UNNAMED -jar -javaagent:arthas/arthas-agent.jar app.jar ${JVM_ARGS}