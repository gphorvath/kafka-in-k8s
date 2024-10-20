CLUSTER_NAME=kube-cluster

create-cluster:
	@echo "Creating a new cluster..."
	k3d cluster create $(CLUSTER_NAME) \
	--agents 3 \
	--k3s-node-label topology.kubernetes.io/zone=zone-a@agent:0 \
	--k3s-node-label topology.kubernetes.io/zone=zone-b@agent:1 \
	--k3s-node-label topology.kubernetes.io/zone=zone-c@agent:2
	@echo "Cluster created!"

describe:
	kubectl describe service kafka-svc
	kubectl get poddisruptionbudgets

deploy-kafka:
	@echo "Deploying Kafka..."
	kubectl apply -f kafka.yaml
	@echo "Kafka deployed!"

apply-pdb:
	@echo "Applying PodDisruptionBudget..."
	kubectl apply -f kafka-pdb.yaml
	@echo "PodDisruptionBudget applied!"

delete-cluster:
	@echo "Deleting the cluster..."
	k3d cluster delete $(CLUSTER_NAME)
	@echo "Cluster deleted!"