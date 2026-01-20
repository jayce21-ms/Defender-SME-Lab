# Defender-SME-Lab v2.0
> **Cloud Security Research & Detection Engineering Framework**

## 🎯 Project Overview
This repository serves as a centralized environment for validating **Microsoft Defender for Cloud (MDC)** controls and developing **Foundry Agent** orchestration logic. It is designed to provide high-fidelity security telemetry while maintaining strict alignment with corporate SOC governance.

## 🏗️ Architecture (v2.0 Pivot)
Following our January research cycle, the architecture has been modernized for **tenant-agnostic portability**:
* **Infrastructure as Code:** All resources are deployed via modular Bicep templates (`/infra`).
* **Governance First:** Mandatory `#SOC_Exclusion` tagging and out-of-band telemetry routing to prevent production noise.
* **Agent Integration:** Direct hooks for Foundry Agent automation and real-time response validation.

## 📁 Repository Structure
* **`/infra`**: Contains Bicep templates for rapid, compliant deployment of Linux/Windows research nodes.
* **`/docs`**: Contains Post-Incident Reviews (PIR) and strategic roadmap documentation.
* **`.github/workflows`**: CI/CD pipelines for automated infrastructure validation.

## 📈 Current Status: Sprint 1 (January 2026)
- [x] **Local Environment Modernization:** Standardized on Az-CLI 2.82.0 via Homebrew.
- [x] **Incident Resolution:** Published [PIR-Jan-2026](docs/PIR-Jan-2026.md) regarding SOC telemetry alignment.
- [ ] **Next Milestone:** Deployment of the Foundry-Integrated Sandbox in the Guardian environment.

---
**Lead Engineer:** Jayce Hill  
**Contact:** jaycehill@microsoft.com