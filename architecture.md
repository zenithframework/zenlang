# Zenith Framework Architecture

## 1. Overview

Zenith is a high-performance web framework built on the Zenith programming language. It follows the **Model-View-Controller (MVC)** architectural pattern combined with full-stack component-based UI development, enabling developers to write complete web applications in a single language (`.zen`).

## 2. Core Architectural Principles

- **Developer Experience**: Minimal configuration ("convention over configuration"), expressive APIs, and integrated tooling
- **Performance**: Zero-overhead abstractions, compiled components, bytecode JIT compilation
- **Full-Stack Integration**: Seamless backend (Zenith) and frontend (Zenith UI components) development
- **Type Safety**: Static typing prevents classes of bugs at compile time
- **Security First**: Built-in protections against common vulnerabilities
- **Scalability**: Designed for high-traffic applications with support for caching, queuing, and load balancing

## 3. Layered Architecture

```
┌─────────────────────────────────────────────┐
│         HTTP Client / Browser               │
└─────────────────────────────────────────────┘
                      ↓↑
┌─────────────────────────────────────────────┐
│         HTTP Server / Web Container         │
│     (Handles incoming requests/responses)   │
└─────────────────────────────────────────────┘
                      ↓↑
┌─────────────────────────────────────────────┐
│            Routing Layer                    │
│     (URL pattern matching & dispatch)       │
└─────────────────────────────────────────────┘
                      ↓↑
┌─────────────────────────────────────────────┐
│         Middleware Stack                    │
│     (Auth, CSRF, Logging, etc.)            │
└─────────────────────────────────────────────┘
                      ↓↑
┌─────────────────────────────────────────────┐
│         Controller Layer                    │
│     (Business logic & request handling)     │
└─────────────────────────────────────────────┘
                      ↓↑
┌─────────────────────────────────────────────┐
│         Service / Business Logic            │
│     (Reusable business operations)          │
└─────────────────────────────────────────────┘
                      ↓↑
┌─────────────────────────────────────────────┐
│         Model & ORM Layer                   │
│     (Data access & relationships)           │
└─────────────────────────────────────────────┘
                      ↓↑
┌─────────────────────────────────────────────┐
│         Database Layer                      │
│     (MySQL, PostgreSQL, SQLite, etc.)      │
└─────────────────────────────────────────────┘

┌─────────────────────────────────────────────┐
│         UI Component Rendering              │
│     (Page & Component compilation)          │
└─────────────────────────────────────────────┘
```

## 4. Directory Structure Deep Dive

```
my_zenith_app/
│
├── app/                          # Application source code
│   ├── Http/
│   │   ├── Controllers/          # Request handlers (UserController.zen)
│   │   ├── Middleware/           # Request filters (AuthMiddleware.zen)
│   │   ├── Requests/             # Request validation (StoreUserRequest.zen)
│   │   └── Responses/            # Custom responses (custom_response.zen)
│   │
│   ├── Models/                   # ORM models (User.zen, Post.zen)
│   │   └── Relationships/        # Relationship definitions
│   │
│   ├── Views/                    # UI Components and Pages
│   │   ├── Pages/                # Full page components (Home.zen)
│   │   ├── Components/           # Reusable UI components (Button.zen)
│   │   ├── Layouts/              # Master layouts (app.zen)
│   │   └── Partials/             # Template snippets
│   │
│   ├── Services/                 # Business logic services
│   │   ├── UserService.zen       # User-related operations
│   │   └── EmailService.zen      # Email sending
│   │
│   ├── Jobs/                     # Background jobs/queues
│   │   └── SendEmail.zen
│   │
│   ├── Events/                   # Event definitions
│   │   └── UserCreated.zen
│   │
│   ├── Listeners/                # Event listeners
│   │   └── SendWelcomeEmail.zen
│   │
│   ├── Exceptions/               # Custom exceptions
│   │   └── ValidationException.zen
│   │
│   ├── Providers/                # Service providers (bootstrap)
│   │   ├── AppServiceProvider.zen
│   │   └── DatabaseServiceProvider.zen
│   │
│   └── Console/                  # CLI commands
│       └── Commands/
│           └── MakeUserCommand.zen
│
├── config/                       # Configuration files
│   ├── app.zen                   # App configuration
│   ├── database.zen              # Database connections
│   ├── cache.zen                 # Cache configuration
│   ├── auth.zen                  # Authentication config
│   ├── mail.zen                  # Email configuration
│   └── services.zen              # External services
│
├── database/
│   ├── migrations/               # Schema changes
│   │   └── 2025_01_01_000000_create_users_table.zen
│   ├── seeds/                    # Test data
│   │   └── UserSeeder.zen
│   └── factories/                # Model factories for testing
│       └── UserFactory.zen
│
├── routes/
│   ├── web.zen                   # Web routes (HTML responses)
│   ├── api.zen                   # API routes (JSON responses)
│   └── console.zen               # CLI routes
│
├── public/                       # Web-accessible files
│   ├── index.zen                 # Entry point
│   ├── css/                      # Stylesheets
│   ├── js/                       # Client-side scripts
│   └── assets/                   # Images, fonts, etc.
│
├── resources/
│   ├── lang/                     # Localization files
│   │   ├── en.zen
│   │   └── fr.zen
│   └── views/                    # Pre-compiled view cache
│
├── storage/
│   ├── app/                      # Application storage
│   ├── logs/                     # Application logs
│   └── cache/                    # Cache files
│
├── tests/
│   ├── Feature/                  # End-to-end tests
│   │   └── UserTest.zen
│   ├── Unit/                     # Unit tests
│   │   └── UserServiceTest.zen
│   └── TestCase.zen              # Base test class
│
├── bootstrap/                    # Application bootstrap
│   └── app.zen                   # Application initialization
│
├── .env.example                  # Environment file template
├── .env.testing                  # Testing environment
├── Zen.toml                      # Project manifest
├── zen.lock                      # Dependency lock file
├── README.md                     # Project documentation
└── .gitignore                    # Git ignore rules
```

## 5. Request Lifecycle

### Detailed Flow

```
1. CLIENT REQUEST
   │
   ├─ HTTP Request arrives at public/index.zen
   │
   ├─ Zenith Bootstrap (bootstrap/app.zen)
   │  ├─ Load .env configuration
   │  ├─ Initialize service container
   │  ├─ Register service providers
   │  └─ Boot application
   │
   ├─ Router (routes/web.zen or routes/api.zen)
   │  ├─ Match URL pattern
   │  ├─ Extract parameters
   │  └─ Identify controller & method
   │
   ├─ BEFORE MIDDLEWARE
   │  ├─ Authentication (verify user identity)
   │  ├─ Authorization (check permissions)
   │  ├─ CSRF protection validation
   │  ├─ Rate limiting
   │  ├─ Request logging
   │  └─ Custom middleware
   │
   ├─ CONTROLLER
   │  ├─ Extract request data
   │  ├─ Validate input (Requests/)
   │  ├─ Call business logic (Services/)
   │  ├─ Query models (Models/)
   │  └─ Return response (View or JSON)
   │
   ├─ VIEW RENDERING (if applicable)
   │  ├─ Compile UI components (Views/)
   │  ├─ Pass data to template
   │  ├─ Generate HTML
   │  └─ Optimize output
   │
   ├─ AFTER MIDDLEWARE
   │  ├─ Add security headers
   │  ├─ Set cookies/sessions
   │  ├─ Response logging
   │  └─ Custom middleware
   │
   └─ HTTP RESPONSE
      └─ Send to client (HTML, JSON, redirect, etc.)
```

## 6. Key Components Explained

### 6.1 Controllers
Handle HTTP requests and orchestrate business logic:
```zen
class UserController {
    fn show(id: int): View {
        let user = User.findOrFail(id);
        return view("users.show", { user: user });
    }
}
```

### 6.2 Models (ORM)
Represent database entities with relationships:
```zen
class User extends Model {
    fn posts(): HasMany<Post> {
        return this.hasMany(Post);
    }
}
```

### 6.3 Views (Components)
Render HTML using Zenith UI syntax:
```zen
page UserShow(user: User, posts: array<Post>) {
    fn render() {
        <div>{user.name}</div>
    }
}
```

### 6.4 Middleware
Process requests before reaching controllers:
```zen
class AuthMiddleware implements Middleware {
    fn handle(request: Request, next: fn): Response {
        if !auth().check() {
            return redirect("/login");
        }
        return next(request);
    }
}
```

### 6.5 Services
Encapsulate business logic:
```zen
class UserService {
    fn create_user(data: map): User {
        let user = new User(data);
        user.save();
        return user;
    }
}
```

## 7. Data Flow Architecture

```
    USER INPUT (Form/API)
            │
            ↓
    Request Validation
    (Form Request class)
            │
            ↓
    Controller Method
            │
    ┌───────┼───────┐
    │       │       │
    ↓       ↓       ↓
Services  Models  Cache
    │       │       │
    └───────┼───────┘
            │
            ↓
    Database Query/Write
            │
            ↓
    Response Construction
    (View or JSON)
            │
            ↓
    Output to Client
```

## 8. Service Container & Dependency Injection

The Service Container manages dependencies:

```zen
// Register services in AppServiceProvider
fn register() {
    container.singleton(UserService, fn() {
        return new UserService(db());
    });
}

// Use injected dependencies in controller
class UserController {
    fn constructor(service: UserService) {
        this.service = service;
    }
    
    fn store() {
        let user = this.service.create_user(request.all());
    }
}
```

## 9. Configuration Management

Configuration follows a layered approach:

```
.env (local overrides)
    ↓
config/*.zen (default values)
    ↓
Environment values
    ↓
Fallback defaults
```

## 10. Security Architecture

```
┌─────────────────────────────────────┐
│      Request Arrives                │
└────────────┬────────────────────────┘
             │
             ↓
┌─────────────────────────────────────┐
│   1. HTTPS/TLS Encryption           │
└────────────┬────────────────────────┘
             │
             ↓
┌─────────────────────────────────────┐
│   2. IP Whitelist / Rate Limiting    │
└────────────┬────────────────────────┘
             │
             ↓
┌─────────────────────────────────────┐
│   3. CSRF Token Validation           │
└────────────┬────────────────────────┘
             │
             ↓
┌─────────────────────────────────────┐
│   4. Authentication                 │
│      (Verify user identity)         │
└────────────┬────────────────────────┘
             │
             ↓
┌─────────────────────────────────────┐
│   5. Authorization                  │
│      (Check permissions)            │
└────────────┬────────────────────────┘
             │
             ↓
┌─────────────────────────────────────┐
│   6. Input Validation               │
│      (Sanitize & validate data)     │
└────────────┬────────────────────────┘
             │
             ↓
┌─────────────────────────────────────┐
│   7. SQL Injection Prevention       │
│      (Parameterized queries)        │
└────────────┬────────────────────────┘
             │
             ↓
┌─────────────────────────────────────┐
│   8. XSS Prevention                 │
│      (Output encoding)              │
└────────────┬────────────────────────┘
             │
             ↓
┌─────────────────────────────────────┐
│   9. Session Management             │
│      (Secure session tokens)        │
└────────────┬────────────────────────┘
             │
             ↓
┌─────────────────────────────────────┐
│   Safe Response                     │
└─────────────────────────────────────┘
```

## 11. Performance Architecture

### Caching Strategy
```
Request
    │
    ├─ Check Page Cache (full response)
    ├─ Check Query Cache (database results)
    ├─ Check Component Cache (rendered HTML)
    └─ If miss → Process normally → Cache result
```

### Optimization Techniques
- **HTTP Caching**: Leverage browser caching with proper headers
- **Database Query Optimization**: Use eager loading, indexes, query analysis
- **Component Memoization**: Cache rendered components
- **Compression**: Gzip/Brotli response compression
- **CDN Integration**: Serve static assets globally
- **Async Operations**: Background job queues for long tasks

## 12. Testing Architecture

```
Tests
├── Unit Tests
│   ├── Model tests
│   ├── Service tests
│   └── Utility tests
├── Feature Tests
│   ├── Controller tests
│   ├── Middleware tests
│   └── API endpoint tests
└── Acceptance Tests
    ├── End-to-end workflows
    └── User journey tests
```

## 13. Deployment Architecture

```
┌─────────────────────────┐
│  Source Code (GitHub)   │
└────────────┬────────────┘
             │
             ↓
┌─────────────────────────┐
│  CI/CD Pipeline         │
│  (Test & Build)         │
└────────────┬────────────┘
             │
             ↓
┌─────────────────────────┐
│  Docker Image           │
│  (Containerized App)    │
└────────────┬────────────┘
             │
             ↓
┌─────────────────────────┐
│  Registry               │
│  (Harbor / Docker Hub)  │
└────────────┬────────────┘
             │
      ┌──────┴──────┬──────────┐
      │             │          │
      ↓             ↓          ↓
┌──────────────┐ ┌────────┐ ┌─────────┐
│ Kubernetes   │ │Docker  │ │ Lambda  │
│ Cluster      │ │Compose │ │         │
└──────────────┘ └────────┘ └─────────┘
```

## 14. Extension Points

### Plugin System
```zen
interface Plugin {
    fn boot(): null;
    fn register(): null;
}

class MyPlugin implements Plugin {
    fn boot() {
        // Initialize plugin
    }
    
    fn register() {
        // Register services
    }
}
```

### Event System
```zen
// Define custom events
event UserCreated(user: User)

// Listen for events
listen(UserCreated, fn(event) {
    send_welcome_email(event.user);
});
```

## 15. Scaling Strategies

### Horizontal Scaling
- Stateless design allows multiple instances
- Load balancing across instances
- Shared session storage (Redis)
- Shared cache layer (Redis/Memcached)

### Vertical Scaling
- Optimize database queries
- Add caching layers
- Enable bytecode compilation
- Use connection pooling

### Database Scaling
- Read replicas
- Database sharding
- Query optimization
- Proper indexing

## 16. Monitoring & Logging

```
Application
    │
    ├─ Request Logging
    ├─ Error Logging
    ├─ Database Query Logging
    ├─ Performance Metrics
    └─ Custom Metrics
            │
            ↓
    Log Aggregation
    (ELK, Datadog, etc.)
            │
            ↓
    Monitoring & Alerts
```

## 17. Development vs Production

### Development
- Full debugging information
- Detailed error pages
- Automatic code reloading
- SQL query logging
- Mock external services

### Production
- Optimized bytecode
- Error logging to external services
- Performance monitoring
- Security headers enabled
- Rate limiting active

## 18. Future Architecture Enhancements

- **Microservices**: Support for service mesh integration
- **GraphQL**: Native GraphQL support alongside REST
- **Real-time**: WebSocket support for real-time features
- **Event Sourcing**: Alternative to traditional persistence
- **CQRS**: Command Query Responsibility Segregation
- **AI Integration**: ML model serving and inference

---

See also: [Zenith Language](./ZenithLanguage.md) | [Web Framework](./ZenWebFramework.md) | [Compiler](./ZenithCompiler.md) | [Package Manager](./ZenPackageManager.md)
