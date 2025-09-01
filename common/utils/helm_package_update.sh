# Commands to update and build new Helm package versions
# Inputs:
#   - PLATFORM_NAME: The name of the platform the chart is for
#   - CHART_NAME: The name of the Helm chart to update

PLATFORM_NAME=$1
CHART_NAME=$2
VERSION_NAME=$3

# Check if any of the required variables are empty
if [ -z "$PLATFORM_NAME" ] || [ -z "$CHART_NAME" ] || [ -z "$VERSION_NAME" ]; then
  # If any variable is missing, print a single error message and exit
  echo "Error: PLATFORM_NAME (=$PLATFORM_NAME), CHART_NAME (=$CHART_NAME), and VERSION_NAME (=$VERSION_NAME) are all required arguments."
  exit 1
fi

# Get the directory of this script - /path/to/common/utils/helm_package_update.sh
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
REPO_ROOT=${SCRIPT_DIR}/../..
CHART_PARENT_DIR=${REPO_ROOT}/${PLATFORM_NAME}/helm/charts

# --- Step 0 - Build ---

# TODO (navneetkapur): Auto-update Chart.yaml version to next version. This will
# include removing VERSION as a required parameter to this script.

# cd ${CHART_PARENT_DIR}/${CHART_NAME} || exit 1
# if [ -f "Chart.yaml" ]; then
#   yq eval -i ".version = \"$VERSION_NAME\"" Chart.yaml
# else
#   echo "Error: Chart.yaml not found"
#   exit 1
# fi

# --- Step 1 - Build ---
cd ${CHART_PARENT_DIR} || exit 1
helm package ${CHART_NAME}
mv ${CHART_NAME//_/-}-${VERSION_NAME}.tgz ${REPO_ROOT}/docs/ || exit 1
echo "DONE: tgz generated and moved to ${REPO_ROOT}/docs"

# --- Step 2 - Install and Update index ---
cd ${REPO_ROOT}/docs || exit 1
helm repo index . --url https://nkapur.github.io/platform_modules
echo "DONE: index updated"