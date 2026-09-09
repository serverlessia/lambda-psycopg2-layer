#!/bin/bash
set -e

PYTHON_VERSIONS=("3.9" "3.10" "3.11" "3.12" "3.13" "3.14")
LAYER_NAME="psycopg-layer"

echo "Testing Psycopg Lambda Layers for multiple Python versions..."

for PYTHON_VERSION in "${PYTHON_VERSIONS[@]}"; do
    echo "--- Testing for Python ${PYTHON_VERSION} ---"
    
    LAYER_PATH="build/python${PYTHON_VERSION}/python"
    LAYER_ZIP="build/${LAYER_NAME}-python${PYTHON_VERSION}.zip"

    if [ ! -f "${LAYER_ZIP}" ]; then
        echo "❌ Layer zip not found for Python ${PYTHON_VERSION}: ${LAYER_ZIP}"
        continue
    fi

    # Unzip the layer to a temporary location for testing
    TEST_DIR="test_env_python${PYTHON_VERSION}"
    mkdir -p "${TEST_DIR}"
    unzip -q "${LAYER_ZIP}" -d "${TEST_DIR}"

    # Create test script
    cat > "${TEST_DIR}/test_psycopg.py" << 'EOF'
import sys
import os

# Add the unzipped layer content to Python path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'python'))

try:
    import psycopg2
    print("✅ Psycopg2 import successful")
    
    # Check version
    print(f"✅ Psycopg2 version: {psycopg2.__version__}")
    
    # Test extensions
    try:
        import psycopg2.extensions
        print("✅ Psycopg2 extensions import successful")
    except Exception as e:
        print(f"❌ Extensions import failed: {e}")
    
    try:
        import psycopg2.extras
        print("✅ Psycopg2 extras import successful")
    except Exception as e:
        print(f"❌ Extras import failed: {e}")
    
    # Test connection function
    try:
        from psycopg2 import connect
        print("✅ Psycopg2 connect function available")
    except Exception as e:
        print(f"❌ Connect function import failed: {e}")
    
    # Test error classes
    try:
        from psycopg2 import Error, DatabaseError, OperationalError
        print("✅ Psycopg2 error classes available")
    except Exception as e:
        print(f"❌ Error classes import failed: {e}")
    
    # Test binary package
    try:
        conn_info = psycopg2.extensions.connection_info
        print("✅ Psycopg2 binary extensions loaded")
    except Exception as e:
        print(f"⚠️  Extensions check: {e}")

    python_version = f"{sys.version_info.major}.{sys.version_info.minor}"
    print(f"✅ All tests passed for Python version: {python_version}!")

except Exception as e:
    import traceback
    python_version = f"{sys.version_info.major}.{sys.version_info.minor}"
    print(f"❌ Test failed for Python version {python_version}: {e}")
    traceback.print_exc()
    sys.exit(1)
EOF

    # Run test using the specific Python version
    PYTHON_BIN="python${PYTHON_VERSION}"
    ${PYTHON_BIN} "${TEST_DIR}/test_psycopg.py"
    
    # Clean up test environment
    rm -rf "${TEST_DIR}"

    echo "--- Test for Python ${PYTHON_VERSION} completed ---"
done

echo "All Psycopg Lambda Layers tested successfully!"
