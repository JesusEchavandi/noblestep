# NobleStep

Sistema de gestión empresarial con backend ASP.NET Core y frontend Angular.

## Estructura del Proyecto

```
NobleStep/
├── backend/          # API ASP.NET Core
├── frontend/         # Aplicación Angular
├── database/         # Scripts SQL
└── README.md
```

## Requisitos

- .NET 8.0 SDK
- Node.js 18+
- MySQL 8.0+

## Inicio Rápido

### Backend
```bash
cd backend
dotnet restore
dotnet run
```

### Frontend
```bash
cd frontend
npm install
npm start
```

### Base de Datos
Ejecutar los scripts en `database/` en orden:
1. `database-setup.sql` o `database-setup-corrected.sql`
2. Scripts adicionales según sea necesario

## Documentación

Para más detalles, consultar la carpeta `_trash/` que contiene documentación adicional y scripts auxiliares.
