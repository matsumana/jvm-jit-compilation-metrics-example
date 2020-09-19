package info.matsumana.example.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import reactor.core.publisher.Mono;

@RestController
public class RootController {

    @GetMapping("/")
    Mono<String> index() {
        return Mono.just("It works!");
    }
}
