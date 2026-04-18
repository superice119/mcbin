# Enable CP110 SERDES PHY and fix CMA/DMA for MACCHIATObin Double Shot
#
# Without CONFIG_PHY_MVEBU_CP110_COMPHY=y, all CP110-attached devices
# (Ethernet eth0/eth1, SATA, PCIe, USB) fail with "deferred probe pending".
#
# Must be built-in (=y not =m): the comphy PHY nodes must be available
# before mvpp2/SATA/PCIe probe, otherwise they defer indefinitely.
#
# CMA: mvpp2 allocates ~2MB DMA buffers per interface (8 buffers/cpu × 4 cpu).
# Default 16MB CMA is exhausted before both interfaces probe. Set 64MB.

function custom_kernel_config__mcbin_cp110_comphy() {
	kernel_config_modifying_hashes+=("PHY_MVEBU_CP110_COMPHY=y" "CMA_SIZE_MBYTES=64")

	if [[ -f .config ]]; then
		display_alert "mcbin" "Enabling CONFIG_PHY_MVEBU_CP110_COMPHY=y (built-in) for CP110 SERDES PHY" "info"
		# Built-in so comphy PHY nodes exist before ethernet/SATA/PCIe probe
		./scripts/config --enable CONFIG_PHY_MVEBU_CP110_COMPHY
		# Increase default CMA pool to 64 MB (mvpp2 uses ~2MB per interface)
		./scripts/config --set-val CONFIG_CMA_SIZE_MBYTES 64
	fi
}
