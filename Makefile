.PHONY: create delete logs

create:
	microk8s kubectl create -k k8s/

delete:
	microk8s kubectl delete -k k8s/

logs:
	microk8s kubectl logs deployment/$(dep) --all-containers=true -f

pods:
	microk8s kubectl get pods