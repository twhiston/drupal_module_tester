# Include common Makefile code.
BASE_IMAGE_NAME = php
VERSIONS = prod dev ci local
OPENSHIFT_NAMESPACES = 7.0

# Include common Makefile code.
include hack/common.mk
