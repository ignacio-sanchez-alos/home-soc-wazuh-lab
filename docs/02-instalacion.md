# 02 · Instalación paso a paso

> Antes de empezar: en VirtualBox → *Archivo → Preferencias → General → Carpeta predeterminada de máquinas* = `D:\VMs\home-soc-lab`.

## Paso 0 · Red host-only

VirtualBox → *Archivo → Herramientas → Network Manager* → pestaña *Host-only Networks*:
- Debe existir una red `192.168.56.1/24`. Si no, **Crear**.
- DHCP desactivado (usaremos IPs fijas).

## Paso 1 · Servidor Wazuh (OVA oficial)

1. Descarga la OVA oficial desde la documentación de Wazuh (*Installation guide → Virtual Machine (OVA)*).
2. VirtualBox → *Archivo → Importar servicio virtualizado* → la OVA → carpeta base `D:\VMs\home-soc-lab`.
3. Ajustes de la VM: 4 GB RAM, 2 CPU, adaptador 1 = host-only, adaptador 2 = NAT.
4. Arranca e inicia sesión con las credenciales que indica la documentación de la OVA. **Cámbialas en el primer arranque.**
5. Pon la IP fija `192.168.56.10` en la interfaz host-only.
6. Desde Windows abre `https://192.168.56.10` → debe cargar el dashboard.

📸 Captura: dashboard de Wazuh funcionando → `docs/img/01-dashboard.png`

## Paso 2 · Víctima Ubuntu Server

1. Nueva VM `victima-ubuntu` (2 GB, 1 CPU, 20 GB) con la ISO de Ubuntu Server 24.04 LTS.
2. Durante la instalación marca **Install OpenSSH server**.
3. IP fija `192.168.56.20` en la interfaz host-only (netplan).
4. Instala el agente: en el dashboard → *Agents → Deploy new agent* → Linux DEB amd64 → servidor `192.168.56.10` → nombre `victima-ubuntu`. Copia y ejecuta en la víctima los comandos que genera.
5. Comprueba en el dashboard que el agente aparece como **Active**.
6. Ejecuta `scripts/victima-setup.sh` (logs de iptables y FIM en tiempo real).

📸 Captura: agente activo → `docs/img/02-agente-activo.png`

## Paso 3 · Atacante Kali

1. Importa la imagen oficial de Kali para VirtualBox en `D:\VMs\home-soc-lab`.
2. Adaptador 1 = host-only, IP fija `192.168.56.30`.

## Paso 4 · Cargar decoders y reglas propias

En el manager (copiando el contenido de este repo):

```bash
sudo cp decoders/local_decoder.xml /var/ossec/etc/decoders/local_decoder.xml
sudo cp rules/local_rules.xml      /var/ossec/etc/rules/local_rules.xml
sudo /var/ossec/bin/wazuh-analysisd -t        # valida la sintaxis
sudo systemctl restart wazuh-manager
```

Prueba cada regla con una línea de log real usando `sudo /var/ossec/bin/wazuh-logtest`.

## Paso 5 · Aislar el laboratorio

Desactiva el adaptador NAT de las tres VMs antes de lanzar ningún escenario.

## Paso 6 · Escenarios

Para cada escenario: lanzar → ver la alerta en el dashboard → capturas → rellenar el informe desde [reports/plantilla-incidente.md](../reports/plantilla-incidente.md).
