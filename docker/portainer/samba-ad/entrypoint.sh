#!/bin/bash
set -e

# === Переменные окружения ===
REALM="${REALM:-LAB.LOCAL}"
DOMAIN="${DOMAIN:-LAB}"
ADMIN_PASS="${ADMIN_PASS:-Passw0rd!}"
DNS_BACKEND="${DNS_BACKEND:-SAMBA_INTERNAL}"
HOSTNAME="${HOSTNAME_OVERRIDE:-DC1}"

echo "Using hostname ${HOSTNAME}.${REALM,,}"

# === Установка hostname (опционально) ===
# hostnamectl set-hostname "${HOSTNAME}.${REALM,,}"

# === Provisioning Samba AD DC ===
if [ ! -f /var/lib/samba/private/sam.ldb ]; then
    echo "No existing AD database found, starting provisioning..."

    # Удаляем старый smb.conf, чтобы не мешал
    rm -f /etc/samba/smb.conf

    samba-tool domain provision \
        --realm="${REALM}" \
        --domain="${DOMAIN}" \
        --server-role=dc \
        --dns-backend="${DNS_BACKEND}" \
        --use-rfc2307 \
        --adminpass="${ADMIN_PASS}" \
        --option="server role=active directory domain controller"
fi

# === Запуск Samba в foreground ===
exec samba -i -s /etc/samba/smb.conf

