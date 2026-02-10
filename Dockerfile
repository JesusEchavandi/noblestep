# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy csproj and restore dependencies
COPY backend/NobleStep.Api.csproj backend/
RUN dotnet restore backend/NobleStep.Api.csproj

# Copy everything else and build
COPY backend/ backend/
RUN dotnet publish backend/NobleStep.Api.csproj -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Copy published app
COPY --from=build /app/publish .

# Expose port (Railway uses PORT env variable)
EXPOSE 8080

# Set environment variable for ASP.NET Core to listen on all interfaces
# Railway sets the PORT variable dynamically, but we default to 8080
ENV ASPNETCORE_URLS=http://+:${PORT:-8080}

# Run the application
CMD ASPNETCORE_URLS=http://*:$PORT dotnet NobleStep.Api.dll
