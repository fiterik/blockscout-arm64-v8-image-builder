.PHONY: blockscout-backend blockscout-frontend

DOCKER_USERNAME:=0x6572696b
BLOCKSCOUT_BACKEND_VERSION:=7.0.0
BLOCKSCOUT_FRONTEND_VERSION:=1.37.6

all: build-all push-all

build-all: backend frontend
	@echo "✅ Done!"

push-all: push-backend push-frontend
	@echo "✅ Done!"

push-backend:
	@echo "🚀 Pushing blockscout backend to Docker..."
	@docker tag blockscout/blockscout:v$(BLOCKSCOUT_BACKEND_VERSION) 0x6572696b/blockscout-backend:v$(BLOCKSCOUT_BACKEND_VERSION)
	@docker push --quiet $(DOCKER_USERNAME)/blockscout-backend:v$(BLOCKSCOUT_BACKEND_VERSION)
	@echo "✅ Done! Use 'docker pull $(DOCKER_USERNAME)/blockscout-backend:v$(BLOCKSCOUT_BACKEND_VERSION)' to pull the image."

push-frontend:
	@echo "🚀 Pushing blockscout frontend to Docker..."
	@docker tag blockscout/frontend:v$(BLOCKSCOUT_FRONTEND_VERSION) $(DOCKER_USERNAME)/blockscout-frontend:v$(BLOCKSCOUT_FRONTEND_VERSION)
	@docker push --quiet $(DOCKER_USERNAME)/blockscout-frontend:v$(BLOCKSCOUT_FRONTEND_VERSION)
	@echo "✅ Done! Use 'docker pull $(DOCKER_USERNAME)/blockscout-frontend:v$(BLOCKSCOUT_FRONTEND_VERSION)' to pull the image."

backend:
	@echo "🧹 Cleaning up blockscout backend",
	@rm -rf ./blockscout

	@echo "🚀 Cloning blockscout backend..."
	@git clone --quiet https://github.com/blockscout/blockscout.git ./blockscout

	@echo "🔧 Checking out blockscout v$(BLOCKSCOUT_BACKEND_VERSION)..."
	@(cd blockscout && git checkout -q v$(BLOCKSCOUT_BACKEND_VERSION))

	@echo "🔨 Building blockscout [$(BLOCKSCOUT_BACKEND_VERSION)]"
	(cd blockscout && docker buildx build -f ./docker/Dockerfile -t blockscout/blockscout:v$(BLOCKSCOUT_BACKEND_VERSION) .)

frontend:
	@echo "🧹 Cleaning up blockscout..."
	@rm -rf ./blockscout-frontend

	@echo "🚀 Cloning blockscout frontend..."
	@git clone --quiet https://github.com/blockscout/frontend.git ./blockscout-frontend

	@echo "🔧 Cloning blockscout frontend [v$(BLOCKSCOUT_FRONTEND_VERSION)]"
	@(cd ./blockscout-frontend && git checkout -q v$(BLOCKSCOUT_FRONTEND_VERSION))

	@echo "🔨 Building blockscout..."
	(cd blockscout-frontend && docker buildx build -f ./Dockerfile -t blockscout/frontend:v$(BLOCKSCOUT_FRONTEND_VERSION) .)