# Enable CP110 SERDES PHY driver for MACCHIATObin Double Shot
#
# Without CONFIG_PHY_MVEBU_CP110_COMPHY, all CP110-attached devices
# (Ethernet eth0/eth1, SATA, PCIe, USB) fail with "deferred probe pending"
# and never initialize on Armbian 6.12.x kernel.

function custom_kernel_config__mcbin_cp110_comphy() {
	# Add to kernel_config_modifying_hashes so Armbian's cache invalidation
	# detects our change and forces a rebuild when this option changes.
	kernel_config_modifying_hashes+=("PHY_MVEBU_CP110_COMPHY=m")

	# Only modify .config if it exists (the hook runs twice; once without).
	if [[ -f .config ]]; then
		display_alert "mcbin" "Enabling CONFIG_PHY_MVEBU_CP110_COMPHY=m for CP110 SERDES PHY" "info"
		opts_m+=("PHY_MVEBU_CP110_COMPHY")
	fi
}
