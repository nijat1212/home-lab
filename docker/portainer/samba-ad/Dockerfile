FROM debian:12

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y gnupg ca-certificates && \
    apt-get update && \
    apt-get install -y samba smbclient krb5-user dnsutils winbind samba-dsdb-modules samba-vfs-modules && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /etc/samba/smb.conf

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

VOLUME ["/var/lib/samba", "/var/log/samba"]

CMD ["/entrypoint.sh"]

