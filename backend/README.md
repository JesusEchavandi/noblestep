# NobleStep API - Backend

ASP.NET Core 8 Web API for the NobleStep Footwear Management System.

## Running the API

```bash
# Restore packages
dotnet restore

# Build project
dotnet build

# Run the API
dotnet run
```

The API will be available at:
- HTTP: http://localhost:5000
- Swagger UI: http://localhost:5000

## API Documentation

Once running, visit http://localhost:5000 to access the interactive Swagger documentation.

## Configuration

Update `appsettings.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "server=localhost;port=3306;database=noblestepdb;user=root;password=YOUR_PASSWORD"
  }
}
```

## Default Users

- **admin** / admin123 (Administrator)
- **seller1** / admin123 (Seller)

## Database Setup

Run the database setup script from the root directory:
```bash
mysql -u root -p < ../database-setup.sql
```

## Testing

Use Swagger UI or tools like Postman to test the API endpoints.

### Quick Test:

1. POST /api/auth/login with:
```json
{
  "username": "admin",
  "password": "admin123"
}
```

2. Copy the token from response

3. Click "Authorize" in Swagger UI

4. Enter: `Bearer YOUR_TOKEN`

5. Test protected endpoints

## Features

- JWT Authentication
- Role-based Authorization
- CRUD Operations for all entities
- Sales reporting endpoints
- Automatic stock management
- Data validation
- Error handling
