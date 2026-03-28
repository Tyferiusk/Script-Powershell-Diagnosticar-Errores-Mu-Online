# 🔧 MU Online Diagnostic Tool

**Herramienta GUI en PowerShell para diagnosticar problemas de conexión en servidores MU Online.**

![Versión](https://img.shields.io/badge/version-5.8-blue)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-green)
![Licencia](https://img.shields.io/badge/license-MIT-lightgrey)

---

## ✨ Características

- ✅ Detección automática de IP del servidor desde `main.exe`
- ✅ Prueba de conectividad TCP y traceroute
- ✅ Verificación de firewall y Windows Defender
- ✅ Análisis de puertos alternativos para detectar bloqueo de ISP
- ✅ Listado completo de procesos y dependencias del sistema
- ✅ Generación de reporte detallado en texto
- ✅ Interfaz gráfica amigable

---

## 🛡️ ¿Es seguro?

**SÍ, este script es 100% seguro y legítimo.**

- 🔓 **Código abierto** - Puedes revisar cada línea
- 📖 **Solo lectura** - No modifica archivos del sistema
- 🚫 **No envía datos** - Los reportes se guardan localmente
- 👤 **Requiere tu consentimiento** - Debes ejecutarlo manualmente como Administrador

Este script es una herramienta de diagnóstico, **NO** es malware, virus, ni software malicioso.

---

## 📋 Requisitos

- Windows 7, 8, 10 o 11
- PowerShell 5.1 o superior
- Permisos de Administrador (necesarios para leer conexiones de red)

---

## 🚀 Cómo usar

1. **Ejecuta PowerShell como Administrador**
2. Navega hasta la carpeta del script
3. Ejecuta:
   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   .\Diagnostico-MU.ps1
