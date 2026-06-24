# ---------------------------------------------------------------------------
# ---------------------------------------------------------------------------

loadPackage(NAME Axlstar ESSENTIAL) 
loadLanguage(NAME axl PATH ${INFRA_BUILDSYSTEM_PATH}/languages)
set(AXL2CC "${AXLSTAR_AXL2CC}")
logStatus("AXL TOOLS : AXL2CC = ${AXLSTAR_AXL2CC}")
