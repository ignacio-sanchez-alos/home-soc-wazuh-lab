# 01 · Arquitectura del laboratorio

## Host

- Windows 10 · Ryzen 5 3600 · 16 GB RAM
- VirtualBox · VMs almacenadas en `D:\VMs\home-soc-lab`

## Red

Red **host-only** de VirtualBox `192.168.56.0/24` (adaptador 1 de cada VM).
Solo durante la instalación se añade un **adaptador 2 en NAT** para descargar paquetes; después se desactiva para que el laboratorio quede aislado.

```
                ┌─────────────────────────┐
                │  wazuh-manager          │
                │  192.168.56.10          │
                │  Dashboard :443         │
                │  Agentes   :1514/:1515  │
                └───────────▲─────────────┘
                            │ eventos (agente)
┌──────────────────┐        │        ┌──────────────────┐
│ atacante-kali    │ ─────► │ ─────► │ victima-ubuntu   │
│ 192.168.56.30    │ ataques│        │ 192.168.56.20    │
└──────────────────┘        │        │ agente Wazuh     │
                            │        └──────────────────┘
                 Red host-only 192.168.56.0/24 (aislada)
```

## Recursos por VM

| VM | RAM | vCPU | Disco |
|---|---|---|---|
| wazuh-manager | 4 GB | 2 | 50 GB (dinámico) |
| victima-ubuntu | 2 GB | 1 | 20 GB (dinámico) |
| atacante-kali | 2 GB | 2 | 25 GB (dinámico) |

Total ≈ 8 GB de RAM: deja margen a Windows con 16 GB.
