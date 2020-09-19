# JVM JIT compilation metrics example

## Required Java version

Since this app uses `JEP 349: JFR Event Streaming`, need to use Java 14 or later.

JEP 349: https://openjdk.java.net/jeps/349

## How to build

```
$ ./gradlew --no-daemon clean build
```

## How to run the app

```
$ java -jar build/libs/jvm-jit-compilation-metrics-example-*.jar
```

## How to load for JIT compilation

e.g. Apache Bench

```
$ ab -n 10000 -c 20 http://localhost:8080/
```

<br>

---

## Exported JIT compilation metrics

e.g.

```
# HELP jvm_jit_compilation_total  
# TYPE jvm_jit_compilation_total counter
jvm_jit_compilation_total{package="java.util",succeded="true",} 333.0
jvm_jit_compilation_total{package="org.springframework.context",succeded="true",} 29.0
...
```

<br>

---

## How to see this app's metrics with Prometheus

Here is [example-prometheus.yml](prometheus/example-prometheus.yml)

```
$ cd /path/to/prometheus-directory
$ ./prometheus --config.file=/path/to/example-prometheus.yml
```

Example PromQL:

http://localhost:9090/graph?g0.range_input=5m&g0.expr=jvm_jit_compilation_total&g0.tab=0&g1.range_input=5m&g1.expr=sum(jvm_jit_compilation_total)%20by%20(instance)&g1.tab=0

![](http://static.matsumana.info/blog/jvm-jit-compilation-metrics-example1.png)
![](http://static.matsumana.info/blog/jvm-jit-compilation-metrics-example2.png)
