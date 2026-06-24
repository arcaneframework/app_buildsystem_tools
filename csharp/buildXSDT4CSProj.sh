#!/bin/bash

CURRENT_DIR=`pwd`
PROJECT_NAME=${1}

# check options
if [[ "${PROJECT_NAME}" != "Law" && "${PROJECT_NAME}" != "Gump" && "${PROJECT_NAME}" != "CMakeList" && "x$2" == "x" ]]; then
  echo Usage : "`basename $0` Law|Gump|CMakeList"
  exit 1
fi
if [[ "x$ARCANEFRAMEWORK_ROOT" == "x" ]]; then
  ARCANEFRAMEWORK_ROOT="../.."
  echo "WARNING ARCANEFRAMEWORK_ROOT NOT SET : var is then set to  ../.."
fi

# csharp namespace and xsd file
if [[ ${PROJECT_NAME} == "CMakeList" ]]; then
  PROJECT_NAMESPACE="${PROJECT_NAME}Generator"
  XSD_FILE_NAME="Makefile"
else
  PROJECT_NAMESPACE="${PROJECT_NAME}Compiler"
  XSD_FILE_NAME=${PROJECT_NAME}
fi

# build T4 
#cd ../../axlstar/TextTransform
cd $ARCANEFRAMEWORK_ROOT/axlstar/TextTransform
dotnet publish --output "${CURRENT_DIR}/TextTransformT4"

# build poject csharp
cd ${CURRENT_DIR}/${PROJECT_NAMESPACE}

# delete existing builds
#rm -rf bin obj

## generate all cs file from .tt using TextTransform.dll
ALL_FILES_T4=`ls *.tt`
for CURRENT_FILE_T4 in ${ALL_FILES_T4}; do
  dotnet ../TextTransformT4/TextTransform.dll --namespace ${PROJECT_NAMESPACE} ${CURRENT_FILE_T4}
done

## generate all .cs file from .xsd
xsd ${XSD_FILE_NAME}.xsd /classes /namespace:${PROJECT_NAMESPACE} /outputdir:.

## compile the project
dotnet publish

# clean .cs from .tt and .xsd, and TextTranform dll 
for CURRENT_FILE_T4 in ${ALL_FILES_T4}; do
  rm "${CURRENT_FILE_T4%.tt}.cs"
done
rm ${XSD_FILE_NAME}.cs
rm -rf ../TextTransformT4
cd ${CURRENT_DIR}

