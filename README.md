# JVM JIT compilation metrics example

## Required Java version

Since this app uses `JEP 349: JFR Event Streaming`, need to use Java 14 or later.

JEP 349: https://openjdk.java.net/jeps/349

## Preparation

### Launch local Docker registry

```
$ docker run -d -p 5000:5000 --name registry registry:2.6
```

## How to build and push to the local Docker registry

```
$ make docker-push-app
$ make docker-push-mtail
```

## How to deploy to a local k8s cluster

```
$ make kubectl-create-example
```

## How to delete the app from a local k8s cluster

```
$ make kubectl-delete-example
```

## How to load for JIT compilation

*This command uses Apache Bench

```
$ make load-test
```

<br>

---

## Exported JIT compilation metrics

### By Micrometer

setting: [JitCompilationMetrics.java](src/main/java/info/matsumana/example/metrics/JitCompilationMetrics.java)

```
# HELP jvm_jit_compilation_total  
# TYPE jvm_jit_compilation_total counter
jvm_jit_compilation_total{package="java.util",} 333.0
jvm_jit_compilation_total{package="org.springframework.context",} 29.0
...
```
![](http://static.matsumana.info/blog/jvm-jit-compilation-metrics-example3_2.png)

### By mtail

setting: [jvm-jit-compilation.mtail](mtail/jvm-jit-compilation.mtail)

```
# HELP mtail_jvm_jit_compilation_total defined at jvm-jit-compilation.mtail:1:9-39
# TYPE mtail_jvm_jit_compilation_total counter
mtail_jvm_jit_compilation_total{filename="/app/jvm-unified-log/jit-compilation.log",package="java.util",prog="jvm-jit-compilation.mtail"} 1921
mtail_jvm_jit_compilation_total{filename="/app/jvm-unified-log/jit-compilation.log",package="java.util.concurrent",prog="jvm-jit-compilation.mtail"} 369
mtail_jvm_jit_compilation_total{filename="/app/jvm-unified-log/jit-compilation.log",package="org.springframework.util",prog="jvm-jit-compilation.mtail"} 554
...
```

![](http://static.matsumana.info/blog/jvm-jit-compilation-metrics-example4_2.png)

### Example PromQL

http://localhost:30000/graph?g0.range_input=5m&g0.expr=jvm_jit_compilation_total&g0.tab=0&g1.range_input=5m&g1.expr=mtail_jvm_jit_compilation_total&g1.tab=0&g2.range_input=5m&g2.expr=mtail_log_lines_total&g2.tab=0
