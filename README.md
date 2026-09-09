# Psycopg Lambda Layer

[![CI](https://github.com/serverlessia/lambda-psycopg-layer/actions/workflows/ci.yml/badge.svg)](https://github.com/serverlessia/lambda-psycopg-layer/actions/workflows/ci.yml)
[![Python 3.9](https://img.shields.io/badge/python-3.9-blue.svg)](https://www.python.org/downloads/release/python-390/)
[![Python 3.10](https://img.shields.io/badge/python-3.10-blue.svg)](https://www.python.org/downloads/release/python-3100/)
[![Python 3.11](https://img.shields.io/badge/python-3.11-blue.svg)](https://www.python.org/downloads/release/python-3110/)
[![Python 3.12](https://img.shields.io/badge/python-3.12-blue.svg)](https://www.python.org/downloads/release/python-3120/)
[![Python 3.13](https://img.shields.io/badge/python-3.13-blue.svg)](https://www.python.org/downloads/release/python-3130/)
[![Python 3.14](https://img.shields.io/badge/python-3.14-blue.svg)](https://www.python.org/downloads/release/python-3140/)

Production-ready Psycopg layers for AWS Lambda supporting Python 3.9 through 3.14.

## 🚀 Quick Start

### Using Pre-built Layers

Download the latest layer for your Python version:

| Python Version | Download Link | Layer ARN |
|----------------|---------------|-----------|
| 3.9 | [Download](https://github.com/serverlessia/lambda-psycopg-layer/releases/latest/download/python3.9-v1.zip) | `arn:aws:lambda:region:account:layer:psycopg-python39:1` |
| 3.10 | [Download](https://github.com/serverlessia/lambda-psycopg-layer/releases/latest/download/python3.10-v1.zip) | `arn:aws:lambda:region:account:layer:psycopg-python310:1` |
| 3.11 | [Download](https://github.com/serverlessia/lambda-psycopg-layer/releases/latest/download/python3.11-v1.zip) | `arn:aws:lambda:region:account:layer:psycopg-python311:1` |
| 3.12 | [Download](https://github.com/serverlessia/lambda-psycopg-layer/releases/latest/download/python3.12-v1.zip) | `arn:aws:lambda:region:account:layer:psycopg-python312:1` |
| 3.13 | [Download](https://github.com/serverlessia/lambda-psycopg-layer/releases/latest/download/python3.13-v1.zip) | `arn:aws:lambda:region:account:layer:psycopg-python313:1` |
| 3.14 | [Download](https://github.com/serverlessia/lambda-psycopg-layer/releases/latest/download/python3.14-v1.zip) | `arn:aws:lambda:region:account:layer:psycopg-python314:1` |

### Upload to AWS Lambda

```bash
# Upload layer to AWS Lambda
aws lambda publish-layer-version \
  --layer-name psycopg-python314 \
  --description "Psycopg layer for Python 3.14" \
  --zip-file fileb://python3.14-v1.zip \
  --compatible-runtimes python3.14 \
  --compatible-architectures x86_64
```

### Use in Your Lambda Function

```python
import json
import os
import psycopg2
from psycopg2.extras import RealDictCursor

def lambda_handler(event, context):
    # Psycopg2 is now available!
    try:
        # Connect to PostgreSQL database
        conn = psycopg2.connect(
            host=os.environ['DB_HOST'],
            database=os.environ['DB_NAME'],
            user=os.environ['DB_USER'],
            password=os.environ['DB_PASSWORD'],
            port=os.environ.get('DB_PORT', '5432')
        )
        
        # Execute query
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("SELECT version();")
            result = cur.fetchone()
        
        conn.close()
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Database connection successful!',
                'version': result['version']
            })
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error: {str(e)}')
        }
```

## 📦 Layer Details

| Feature | Value |
|---------|-------|
| **Psycopg2 Version** | Latest (psycopg2-binary) |
| **Layer Size** | ~3.6MB (compressed) |
| **Architecture** | x86_64 |
| **PostgreSQL Support** | All PostgreSQL versions |
| **Python Versions** | 3.9, 3.10, 3.11, 3.12, 3.13, 3.14 |
| **Memory Usage** | ~171MB (uncompressed) |

## 🛠 Building from Source

### Prerequisites

- Python 3.9+ installed
- System dependencies for Psycopg2 compilation (psycopg2-binary includes pre-compiled binaries)

### Build All Versions

```bash
# Clone the repository
git clone https://github.com/serverlessia/lambda-psycopg-layer.git
cd lambda-psycopg-layer

# Build layers for all Python versions
./scripts/build-multi-version.sh

# Test all layers
./scripts/test-multi-version.sh
```

### Build Single Version

```bash
# Build for specific Python version (defaults to 3.14)
./scripts/build.sh
```

### DevContainer

Open in VS Code DevContainer for automatic multi-version building and testing:

1. Open project in VS Code
2. Use "Reopen in Container" command
3. Layers will be built and tested automatically

## 📊 Features

- **Full PostgreSQL Support**: All PostgreSQL features and data types
- **Connection Pooling**: Compatible with connection pooling libraries
- **Extensions**: Includes psycopg2.extras and psycopg2.extensions
- **Binary Package**: Pre-compiled binaries for fast Lambda cold starts
- **Error Handling**: Full exception hierarchy (Error, DatabaseError, OperationalError, etc.)

## 🚦 Status

| Component | Status | Notes |
|-----------|--------|-------|
| **Python 3.9** | ✅ Working | Full Psycopg2 support |
| **Python 3.10** | ✅ Working | Full Psycopg2 support |
| **Python 3.11** | ✅ Working | Full Psycopg2 support |
| **Python 3.12** | ✅ Working | Full Psycopg2 support |
| **Python 3.13** | ✅ Working | Full Psycopg2 support |
| **Python 3.14** | ✅ Working | Full Psycopg2 support |
| **CI/CD** | ✅ Active | Automated builds and releases |
| **DevContainer** | ✅ Ready | Multi-version support |

## 📝 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `./scripts/test-multi-version.sh`
5. Submit a pull request

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/serverlessia/lambda-psycopg-layer/issues)
- **Discussions**: [GitHub Discussions](https://github.com/serverlessia/lambda-psycopg-layer/discussions)
- **Documentation**: [Wiki](https://github.com/serverlessia/lambda-psycopg-layer/wiki)
