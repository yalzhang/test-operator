# Makefile for the downstream Confidential Cluster Operator

# Apply all patches to the base-operator submodule
.PHONY: patch-submodule
patch-submodule:
	@echo "Applying patches to base-operator..."
	@for patch in patches/*.patch; do \
		echo "Applying $$patch..."; \
		patch -p1 -d base-operator < $$patch; \
	done
	@echo "All patches applied."

# Revert the submodule to its original, clean state
.PHONY: clean-submodule
clean-submodule:
	@echo "Reverting base-operator submodule to its original state..."
	@git submodule deinit -f base-operator
	@git submodule update --init base-operator
	@echo "Submodule reverted."

# --- Passthrough targets to the submodule's Makefile ---

.PHONY: build
build:
	@$(MAKE) -C base-operator build

.PHONY: test
test:
	@$(MAKE) -C base-operator test

.PHONY: integration-tests
integration-tests:
	@$(MAKE) -C base-operator integration-tests

.PHONY: cluster-up
cluster-up:
	@$(MAKE) -C base-operator cluster-up

.PHONY: push
push:
	@$(MAKE) -C base-operator REGISTRY=localhost:5000 push

.PHONY: install-kubevirt
install-kubevirt:
	@$(MAKE) -C base-operator install-kubevirt

.PHONY: cluster-down
cluster-down:
	@$(MAKE) -C base-operator cluster-down

.PHONY: clean
clean:
	@$(MAKE) -C base-operator clean

.PHONY: help
help:
	@echo "Available commands:"
	@echo "  patch-submodule     - Apply all .patch files to the base-operator submodule."
	@echo "  clean-submodule     - Revert the base-operator submodule to its original state."
	@echo "  build               - Build the operator binaries."
	@echo "  test                - Run unit tests."
	@echo "  integration-tests   - Run the full integration test suite (requires a cluster)."
	@echo "  cluster-up          - Create a local 'kind' cluster for testing."
	@echo "  push                - Build and push container images to the local registry."
	@echo "  install-kubevirt    - Install KubeVirt into the test cluster."
	@echo "  cluster-down        - Delete the local 'kind' cluster."
	@echo "  clean               - Clean build artifacts within the submodule."