# Confidential Cluster Operator

This repository contains the downstream packaging for the Confidential Cluster Operator, designed for use with Red Hat OpenShift. It is based on the upstream community operator available at [github.com/trusted-execution-clusters/operator](https://github.com/trusted-execution-clusters/operator).

The primary purpose of this repository is to rename the API and product-related components from `trusted-execution-clusters` to `confidential-clusters` to align with product branding and conventions.

## Repository Structure

*   `base-operator/`: This is a Git submodule that tracks the upstream community operator repository. **Files in this directory should not be modified directly.**
*   `patches/`: This directory contains `.patch` files that are applied to the `base-operator` submodule to perform the necessary renaming and modifications.
*   `Makefile`: Provides a set of commands to manage this repository, including applying patches, building, and testing.

## Getting Started: Building and Testing

The following steps guide you through setting up a local test environment, building the operator, and running the test suites.

### Prerequisites

*   `docker` or `podman`
*   `kind`
*   `kubectl`
*   Rust toolchain (`cargo`)

### 1. Set Up the Test Environment

First, create a local `kind` cluster. This will also set up a local container registry.

```bash
make cluster-up
```

### 2. Patch the Submodule

Apply the renaming patches to the `base-operator` source code. This is a crucial step to transform the upstream code into the downstream product.

```bash
make patch-submodule
```

### 3. Build and Push the Operator Image

Build the operator container image and push it to the local registry inside the `kind` cluster.

```bash
make push
```

### 4. Install KubeVirt

The integration tests require KubeVirt to run virtual machines. Install it into the cluster:

```bash
make install-kubevirt
```

### 5. Run Tests

You can now run the unit and integration tests.

*   **Unit Tests:** These do not require a running cluster and are quick to execute.
    ```bash
    make test
    ```

*   **Integration Tests:** These run against the live `kind` cluster and validate the end-to-end functionality of the operator.
    ```bash
    make integration-tests
    ```

### 6. Cleanup

Once you are finished, you can delete the `kind` cluster to clean up all resources.

```bash
make cluster-down
```

## Submodule Updates (Dependabot)

This repository is configured with Dependabot to automatically create Pull Requests whenever the upstream `base-operator` submodule is updated.

After merging a Dependabot PR, you will need to re-apply the patches and ensure all tests pass before tagging a new release. If the upstream changes conflict with the patches, the patch files in the `patches/` directory may need to be regenerated.
