#!/bin/bash
set -e

PYTHON_VERSIONS=("3.9" "3.10" "3.11" "3.12" "3.13" "3.14")
LAYER_NAME="psycopg-layer"

echo "Building Psycopg Lambda Layers for multiple Python versions..."

# Clean previous builds
rm -rf build/
mkdir -p build/

for PYTHON_VERSION in "${PYTHON_VERSIONS[@]}"; do
    echo "--- Building for Python ${PYTHON_VERSION} ---"
    
    BUILD_DIR="build/python${PYTHON_VERSION}"
    mkdir -p "${BUILD_DIR}/python"

    # Use the specific Python version's pip
    PYTHON_BIN="python${PYTHON_VERSION}"
    PIP_BIN="${PYTHON_BIN} -m pip"

    # Install Psycopg and dependencies
    ${PIP_BIN} install -r requirements.txt -t "${BUILD_DIR}/python/"

    # Remove unnecessary files to reduce layer size
    find "${BUILD_DIR}/python" -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
    find "${BUILD_DIR}/python" -name "*.pyc" -delete
    find "${BUILD_DIR}/python" -name "*.pyo" -delete
    find "${BUILD_DIR}/python" -name "*.pyd" -delete
    find "${BUILD_DIR}/python" -name "*.so" -exec strip {} + 2>/dev/null || true

    # Remove test files and documentation
    find "${BUILD_DIR}/python" -name "test*" -type f -delete
    find "${BUILD_DIR}/python" -name "tests" -type d -exec rm -rf {} + 2>/dev/null || true
    find "${BUILD_DIR}/python" -name "*.md" -delete
    find "${BUILD_DIR}/python" -name "*.txt" -not -name "requirements.txt" -delete

    # Create layer zip
    cd "${BUILD_DIR}"
    zip -r "${LAYER_NAME}-python${PYTHON_VERSION}.zip" python/
    mv "${LAYER_NAME}-python${PYTHON_VERSION}.zip" ../../build/
    cd ../..

    echo "Layer built successfully: build/${LAYER_NAME}-python${PYTHON_VERSION}.zip"
    echo "Layer size: $(du -h build/${LAYER_NAME}-python${PYTHON_VERSION}.zip | cut -f1)"
done

echo "All Psycopg Lambda Layers built successfully!"
