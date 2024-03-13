#!/bin/bash
# Instala gnupg y apt-transport-https si no están instalados
if ! dpkg -s gnupg apt-transport-https >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y gnupg apt-transport-https
fi

# Importa la clave GPG de Wazuh
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import && chmod 644 /usr/share/keyrings/wazuh.gpg

# Añade el repositorio de Wazuh
echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list

# Actualiza la información del paquete

apt-get update

echo "La instalación de la clave GPG y la configuración del repositorio de Wazuh se ha completado correctamente."