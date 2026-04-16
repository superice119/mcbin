# mcbin — Armbian Build for MACCHIATObin Double Shot

This repository contains a GitHub Actions workflow to build [Armbian](https://www.armbian.com/) images for the **MACCHIATObin Double Shot** (Marvell Armada 8040).

## Build

Go to **Actions → Build Armbian → Run workflow**, then select:

| Parameter | Options | Default |
|-----------|---------|---------|
| Kernel branch | `current` / `edge` | `current` |
| OS release | `trixie` / `bookworm` / `noble` / `jammy` | `trixie` |

The workflow automatically retries up to **3 times** on failure using **incremental compilation** (no cache cleaning between retries).

Built images are published to [Releases](../../releases).

## Board

- SoC: Marvell Armada 8040 (quad-core Cortex-A72, arm64)
- Build type: Server (CLI, no desktop)
