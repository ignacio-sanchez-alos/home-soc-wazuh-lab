# 🛡️ Home SOC Wazuh Lab

> Laboratorio casero de Blue Team / SOC: detección, correlación de logs y respuesta a incidentes sobre ataques simulados en un entorno aislado, usando [Wazuh](https://wazuh.com) como SIEM/XDR.
> **Ignacio Sánchez Alós** · Máster en Ciberseguridad (CEU) · 2026

## Objetivo

Montar un mini-SOC en casa para practicar el día a día de un analista: generar actividad maliciosa controlada, detectarla en el SIEM, investigarla y documentarla como un incidente real.

## Arquitectura

| Máquina | Rol | SO | IP (red host-only) |
|---|---|---|---|
| `wazuh-manager` | SIEM: manager, indexer y dashboard | OVA oficial de Wazuh (Amazon Linux) | 192.168.56.10 |
| `victima-ubuntu` | Endpoint monitorizado con agente Wazuh | Ubuntu Server 24.04 LTS | 192.168.56.20 |
| `atacante-kali` | Simulación de ataques | Kali Linux | 192.168.56.30 |

Todas las VMs corren en VirtualBox en una red **host-only aislada**: ningún ataque sale del laboratorio. Detalle en [docs/01-arquitectura.md](docs/01-arquitectura.md).

## Escenarios de detección

| # | Escenario | Fuente de log | Regla | MITRE ATT&CK |
|---|---|---|---|---|
| 01 | Fuerza bruta SSH | `auth.log` (sshd) | 100010 | T1110.001 – Password Guessing |
| 02 | Escaneo de puertos | `kern.log` (iptables LOG) | 100101 | T1046 – Network Service Discovery |
| 03 | Modificación de `/etc/passwd` | FIM (syscheck) | 100200 | T1136.001 / T1098 |

## Estructura del repositorio

```
├── docs/        Arquitectura y guía de instalación paso a paso
├── decoders/    Decoders propios de Wazuh
├── rules/       Reglas propias de detección y correlación
├── scripts/     Configuración de la víctima
└── reports/     Informes de incidente (plantilla + uno por escenario)
```

## Estado

- [x] Infraestructura desplegada (servidor Wazuh + víctima Ubuntu)
- [x] Agente Wazuh conectado en la víctima (192.168.56.20)
- [x] Incidente 01 – Fuerza bruta SSH detectado y documentado ([informe](reports/INC-01-fuerza-bruta-ssh.md))
- [ ] Incidente 02 – Escaneo de puertos detectado y documentado
- [x] Incidente 03 – FIM sobre `/etc/passwd` detectado y documentado ([informe](reports/INC-03-modificacion-passwd-fim.md))

## Lecciones aprendidas

_Se completa al terminar los escenarios: qué falló, cómo se diagnosticó y qué se aprendió._

## Agradecimientos

Proyecto inspirado en el laboratorio de mi compañero de máster [Carlos Munaiz](https://github.com/TechAdminPro/home-soc-wazuh-lab).

## Licencia

[MIT](LICENSE)
