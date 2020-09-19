package info.matsumana.example.metrics;

import static java.util.stream.Collectors.joining;

import java.util.List;
import java.util.Map;
import java.util.function.Consumer;
import java.util.regex.Pattern;
import java.util.stream.Stream;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;

import org.springframework.context.annotation.Configuration;

import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Tag;
import jdk.jfr.Recording;
import jdk.jfr.RecordingState;
import jdk.jfr.consumer.EventStream;
import jdk.jfr.consumer.RecordedEvent;
import jdk.jfr.consumer.RecordedMethod;
import jdk.jfr.consumer.RecordingStream;

@Configuration
public class JitCompilationMetrics {

    private static final Pattern packageNameDelimiter = Pattern.compile("\\.");
    private static final Pattern classNamePrefix = Pattern.compile("^[A-Z]");

    private final MeterRegistry registry;
    private final EventStream eventStream = new RecordingStream();
    private final Recording recording = new Recording(Map.of("jdk.Compilation#enabled", "true",
                                                             "jdk.Compilation#threshold", "0 ms"));

    public JitCompilationMetrics(MeterRegistry registry) {
        this.registry = registry;
    }

    @PostConstruct
    void postConstruct() {
        recording.start();

        final Consumer<RecordedEvent> consumer = event -> {
            synchronized (recording) {
                if (recording.getState() != RecordingState.CLOSED) {
                    final boolean succeded = event.getBoolean("succeded");
                    final RecordedMethod method = event.getValue("method");
                    final String methodName = method.getType().getName();

                    // Note:
                    // Use the first three tokens as package label.
                    // Otherwise, too many metrics will be created then
                    // a monitoring system might affected heavy load.
                    final String pkg = Stream.of(packageNameDelimiter.split(methodName))
                                             .filter(token -> !classNamePrefix.matcher(token).find())
                                             .limit(3)
                                             .collect(joining("."));

                    final List<Tag> tags = List.of(Tag.of("package", pkg),
                                                   Tag.of("succeded", String.valueOf(succeded)));
                    final Counter counter = Counter.builder("jvm.jit.compilation")
                                                   .tags(tags)
                                                   .register(registry);
                    counter.increment();
                }
            }
        };

        eventStream.onEvent("jdk.Compilation", consumer);
        eventStream.startAsync();
    }

    @PreDestroy
    void preDestroy() {
        eventStream.close();
    }
}
