#!/usr/bin/env bash
# Configuración de la víctima (victima-ubuntu) · Home SOC Wazuh Lab
# Uso: sudo bash victima-setup.sh
set -euo pipefail

LAB_NET="192.168.56.0/24"
OSSEC_CONF="/var/ossec/etc/ossec.conf"

# 1) Registrar en kern.log las conexiones nuevas que llegan desde la red del laboratorio
#    (fuente de datos del escenario 02). Limitado para no inundar el log.
if ! iptables -C INPUT -s "$LAB_NET" -m conntrack --ctstate NEW -m limit --limit 50/second -j LOG --log-prefix "IPTABLES-SCAN: " 2>/dev/null; then
  iptables -I INPUT -s "$LAB_NET" -m conntrack --ctstate NEW -m limit --limit 50/second -j LOG --log-prefix "IPTABLES-SCAN: "
fi
apt-get install -y iptables-persistent >/dev/null
netfilter-persistent save

# 2) Asegurar que el agente lee kern.log
if ! grep -q "/var/log/kern.log" "$OSSEC_CONF"; then
  sed -i 's#</ossec_config>#  <localfile>\n    <log_format>syslog</log_format>\n    <location>/var/log/kern.log</location>\n  </localfile>\n</ossec_config>#' "$OSSEC_CONF"
fi

# 3) FIM en tiempo real sobre /etc (escenario 03)
if ! grep -q 'realtime="yes"[^>]*>/etc<' "$OSSEC_CONF"; then
  sed -i 's#<directories>/etc,/usr/bin,/usr/sbin</directories>#<directories realtime="yes" report_changes="yes">/etc</directories>\n    <directories>/usr/bin,/usr/sbin</directories>#' "$OSSEC_CONF"
fi

systemctl restart wazuh-agent
echo "[OK] Víctima configurada: iptables LOG + kern.log + FIM en tiempo real sobre /etc"
