# Dockerfile para NobleStep Backend
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copiar proyecto y restaurar dependencias
COPY backend/*.csproj ./backend/
RUN dotnet restore ./backend/NobleStep.Api.csproj

# Copiar todo el código y compilar
COPY backend/ ./backend/
WORKDIR /src/backend
RUN dotnet publish NobleStep.Api.csproj -c Release -o /app/publish

# Imagen de runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

# Copiar archivos publicados
COPY --from=build /app/publish .

# Exponer puerto
EXPOSE 8080

# Variables de entorno por defecto
ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production

# Comando de inicio
ENTRYPOINT ["dotnet", "NobleStep.Api.dll"]
