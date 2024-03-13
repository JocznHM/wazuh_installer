#!/bin/bash
# Instala gnupg y apt-transport-https si no están instalados
#!/bin/bash

echo "__        __              _       _           _        _ _           "
echo "\ \      / /_ _ _____   _| |__   (_)_ __  ___| |_ __ _| | | ___ _ __ "
echo " \ \ /\ / / _| |_  / | | | |_ \  | | |_ \/ __| __/ _\ | | |/ _ \ |__|"
echo "  \ V  V / (_| |/ /| |_| | | | | | | | | \__ \ || (_| | | |  __/ |   "
echo "   \_/\_/ \__|_/___|\__|_|_| |_| |_|_| |_|___/\__\__|_|_|_|\___|_|   "

echo "By JocznHM"
echo "-------------Script para automatizar la instalación del agente wazuh----------------"
echo "....."
echo "....."
echo "....."
echo "....."


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
echo "....."
echo "....."
echo "....."

echo "La instalación de la clave GPG y la configuración del repositorio de Wazuh se ha completado correctamente."
echo "....."
echo "....."


echo "Instalando el agente Wazuh..."
echo "....."
echo "....."
WAZUH_MANAGER="10.0.0.2" apt-get install -y wazuh-agent;

# Instalar el paquete wazuh-agent
if dpkg -l | grep -q "wazuh-agent"; then
    echo "Agente Wazuh instalado correctamente."
    echo "Activando el agente Wazuh como un servicio..."
    echo "....."
    echo "....."
    
    # Recargar el daemon y habilitar/iniciar el servicio si la instalación fue exitosa
    systemctl daemon-reload
    systemctl enable wazuh-agent
    systemctl start wazuh-agent
else
    echo "No se pudo instalar el paquete wazuh-agent. Por favor, verifique la instalación manualmente."
fi