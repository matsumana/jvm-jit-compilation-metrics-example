.PHONY: all

# app
gradlew-clean-build:
	./gradlew --no-daemon clean build
docker-build-app: gradlew-clean-build
	docker build -t localhost:5000/jvm-jit-compilation-metrics-example-app:latest .
docker-push-app: docker-build-app
	docker push localhost:5000/jvm-jit-compilation-metrics-example-app:latest

# mtail
docker-build-mtail:
	docker build -t localhost:5000/jvm-jit-compilation-metrics-example-mtail:latest ./mtail
docker-push-mtail: docker-build-mtail
	docker push localhost:5000/jvm-jit-compilation-metrics-example-mtail:latest

# kubectl
kubectl-create-example:
	kubectl apply -f manifests -R
kubectl-delete-example:
	kubectl delete -f manifests -R
kubectl-get:
	kubectl get deployment -o wide
	kubectl get svc -o wide
	kubectl get pod -o wide

# MISC
load-test:
	ab -n 10000 -c 20 http://localhost:30001/
