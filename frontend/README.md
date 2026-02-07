# NobleStep Web - Frontend

Angular 18+ frontend application for the NobleStep Footwear Management System.

## Running the Application

```bash
# Install dependencies
npm install

# Start development server
npm start
# or
ng serve
```

The application will be available at: http://localhost:4200

## Default Login

**Administrator:**
- Username: `admin`
- Password: `admin123`

**Seller:**
- Username: `seller1`
- Password: `admin123`

## Development

```bash
# Start dev server
ng serve

# Build for production
ng build --configuration production

# Run tests
ng test
```

## Features

- ✅ JWT Authentication
- ✅ Role-based Access Control
- ✅ Product Management
- ✅ Category Management
- ✅ Customer Management
- ✅ Sales Module
- ✅ Reports & Analytics
- ✅ Responsive Design
- ✅ Real-time Validation

## Project Structure

```
src/app/
├── auth/           # Authentication components
├── products/       # Product management
├── categories/     # Category management
├── customers/      # Customer management
├── sales/          # Sales module
├── reports/        # Reports and analytics
├── dashboard/      # Dashboard
├── layout/         # Layout components
├── models/         # TypeScript interfaces
└── services/       # HTTP services
```

## Configuration

Update API URL if needed in service files (default: http://localhost:5000/api)

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)

## UI Framework

- Bootstrap 5
- Custom CSS
- Responsive design
