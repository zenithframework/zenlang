# Zenith Web Framework

## 1. Overview

The Zenith Web Framework is a modern, high-performance, opinionated web framework built on the Zenith programming language. It follows the Model-View-Controller (MVC) architectural pattern, drawing significant inspiration from established frameworks like Laravel but optimized for Zenith's unique capabilities, including native UI components, type safety, and full-stack development in a single language.

**Key Stats:**
- **Language**: Zenith (.zen)
- **Paradigm**: MVC + Full-Stack Components
- **Performance**: Bytecode compilation with JIT optimization
- **Deployment**: Docker, Kubernetes, Serverless compatible

## 2. Core Principles

- **Developer Experience**: Zenith provides an intuitive, minimalist API with powerful scaffolding tools to accelerate development.
- **Performance**: Zero-overhead abstractions, compiled views, and efficient bytecode execution enable fast response times.
- **Full-Stack Integration**: Seamlessly write both backend logic and frontend UI components in the same language (`.zen`).
- **Type Safety**: Static typing catches errors at compile time, ensuring robust applications.
- **Security First**: Built-in protections against common vulnerabilities (CSRF, XSS, SQL injection).
- **AI-Powered**: Future capabilities for AI-driven scaffolding and code generation.

## 3. Directory Structure

A typical Zenith web application structure:

```
my_zenith_app/
├── app/
│   ├── Http/
│   │   ├── Controllers/        # Request handlers
│   │   │   ├── HomeController.zen
│   │   │   ├── UserController.zen
│   │   │   └── ...
│   │   ├── Middleware/         # HTTP middleware
│   │   │   ├── AuthMiddleware.zen
│   │   │   ├── LoggingMiddleware.zen
│   │   │   └── ...
│   │   └── Requests/           # Request validation
│   ├── Models/                 # Database models
│   │   ├── User.zen
│   │   ├── Post.zen
│   │   └── ...
│   ├── Views/                  # UI components
│   │   ├── HomePage.zen
│   │   ├── UserProfile.zen
│   │   ├── components/
│   │   │   ├── Button.zen
│   │   │   ├── Header.zen
│   │   │   └── ...
│   │   └── layouts/
│   │       ├── app.zen
│   │       └── auth.zen
│   └── Services/               # Business logic
│       ├── UserService.zen
│       ├── AuthService.zen
│       └── ...
├── config/
│   ├── app.zen                 # Application configuration
│   ├── database.zen            # Database config
│   ├── cache.zen               # Cache config
│   └── auth.zen                # Authentication config
├── database/
│   ├── migrations/             # Schema migrations
│   │   ├── 2025_01_01_000000_create_users_table.zen
│   │   └── ...
│   └── seeds/                  # Database seeds
│       ├── UserSeeder.zen
│       └── ...
├── routes/
│   ├── web.zen                 # Web routes
│   └── api.zen                 # API routes
├── public/
│   ├── index.zen               # Entry point
│   ├── css/
│   ├── js/
│   └── assets/
├── resources/
│   ├── lang/                   # Localization files
│   └── views/                  # Compiled view cache
├── storage/
│   ├── logs/
│   └── cache/
├── tests/
│   ├── Feature/
│   └── Unit/
├── Zen.toml                    # Project manifest
├── zen.lock                    # Dependency lock file
└── README.md
```

## 4. Key Components

### 4.1 Routing

Define application routes in `routes/web.zen` (for HTML responses) and `routes/api.zen` (for JSON APIs):

```zen
// routes/web.zen

import { HomeController, UserController } from "app/Http/Controllers";

// Simple route
Route.get("/", HomeController.index);
Route.get("/about", HomeController.about);

// Route with parameter
Route.get("/users/:id", UserController.show);

// POST route
Route.post("/users", UserController.store);
Route.put("/users/:id", UserController.update);
Route.delete("/users/:id", UserController.destroy);

// Route grouping with prefix
Route.group("/admin", {
    Route.get("/dashboard", AdminController.dashboard);
    Route.get("/users", AdminController.list_users);
    Route.post("/users", AdminController.create_user);
}, middleware: ["auth", "is_admin"]);

// Named routes
Route.get("/profile", UserController.profile).name("profile");
Route.post("/logout", AuthController.logout).name("logout");

// Route with controller class shorthand
Route.resource("/posts", PostController); // Creates full CRUD routes
```

### 4.2 Controllers

Controllers handle HTTP requests and return responses:

```zen
import { User, Post } from "app/Models";
import { UserRequest } from "app/Http/Requests";

class UserController {
    
    // List all users
    fn index(request: Request): View {
        let users = User.all().paginate(15);
        return view("users/index", { users: users });
    }

    // Show single user
    fn show(request: Request, id: int): View {
        let user = User.findOrFail(id);
        let posts = user.posts().latest().limit(10).get();
        return view("users/show", { user: user, posts: posts });
    }

    // Create form
    fn create(): View {
        return view("users/create");
    }

    // Store new user
    fn store(request: UserRequest): Response {
        let user = User.create(request.validated());
        return redirect("/users/" + user.id).with("success", "User created!");
    }

    // Edit form
    fn edit(id: int): View {
        let user = User.findOrFail(id);
        return view("users/edit", { user: user });
    }

    // Update user
    fn update(request: UserRequest, id: int): Response {
        let user = User.findOrFail(id);
        user.update(request.validated());
        return redirect("/users/" + user.id).with("success", "User updated!");
    }

    // Delete user
    fn destroy(id: int): Response {
        let user = User.findOrFail(id);
        user.delete();
        return redirect("/users").with("success", "User deleted!");
    }
}
```

### 4.3 Models (ORM)

Models represent database tables and provide an elegant Active Record interface:

```zen
class User extends Model {
    // Table name (defaults to lowercase plural "users")
    protected table: string = "users";
    
    // Fillable attributes (for mass assignment)
    protected fillable: array<string> = ["name", "email", "password"];
    
    // Hidden attributes (never included in JSON)
    protected hidden: array<string> = ["password", "remember_token"];
    
    // Cast attributes to specific types
    protected casts: map<string, string> = {
        "email_verified_at": "datetime",
        "is_active": "bool"
    };

    // Relationships
    fn posts(): HasMany<Post> {
        return this.hasMany(Post, "user_id", "id");
    }

    fn comments(): HasMany<Comment> {
        return this.hasMany(Comment, "user_id", "id");
    }

    // Query scopes
    fn scope_active(query: Query): Query {
        return query.where("is_active", "=", true);
    }

    fn scope_recently_created(query: Query): Query {
        return query.where("created_at", ">", Date.now().subDays(7));
    }

    // Accessors and mutators
    fn get_full_name(): string {
        return this.first_name + " " + this.last_name;
    }

    fn set_password(value: string) {
        this.attributes["password"] = hash(value);
    }

    // Event hooks
    fn creating() {
        this.uuid = uuid();
    }

    fn updated() {
        cache_forget("user_" + this.id);
    }
}

// Model usage
let user = User.find(1);                              // Find by ID
let user = User.where("email", "=", "alice@ex.com").first(); // Query
let users = User.where("is_active", "=", true).get(); // Get many
let users = User.active().recently_created().get();  // Use scopes
let user = User.create({ "name": "Bob", "email": "bob@ex.com" }); // Create
user.email = "new@ex.com";
user.save();                                          // Update
user.delete();                                        // Delete

// Relationships
let posts = user.posts().get();                       // Get related posts
let post = user.posts().where("published", "=", true).first();
```

### 4.4 Views (UI Components)

Views use Zenith's native UI component syntax. Components are first-class and can be composed:

```zen
// components/Button.zen
component Button(
    text: string, 
    onClick: fn(), 
    type: string = "button",
    disabled: bool = false
) {
    <button 
        class={"btn", "btn-" + type}
        onclick={onClick}
        disabled={disabled}
    >
        {text}
    </button>
}

// components/Card.zen
component Card(title: string, content: string) {
    <div class="card">
        <div class="card-header">
            <h2>{title}</h2>
        </div>
        <div class="card-body">
            {content}
        </div>
    </div>
}

// pages/HomePage.zen
page HomePage(users: array<User>) {
    layout: "app";
    let greeting: string = "Welcome";

    fn render() {
        <div class="container">
            <h1>{this.greeting} to Zenith!</h1>
            <p>We have {users.length()} users registered.</p>
            
            <Button 
                text="Add User" 
                onClick={this.show_modal}
                type="primary"
            />
            
            for user in users {
                <Card 
                    title={user.name}
                    content={user.email}
                />
            }
        </div>
    }

    fn show_modal() {
        // Handle modal display
    }
}

// pages/UserProfile.zen
page UserProfile(user: User, posts: array<Post>) {
    layout: "app";

    fn render() {
        <div class="profile-container">
            <div class="profile-header">
                <img src={user.avatar_url} alt={user.name} />
                <h1>{user.name}</h1>
                <p>{user.bio}</p>
            </div>

            <div class="posts">
                <h2>Posts ({posts.length()})</h2>
                
                if posts.length() == 0 {
                    <p class="text-muted">No posts yet.</p>
                } else {
                    for post in posts {
                        <div class="post">
                            <h3>{post.title}</h3>
                            <p>{post.excerpt}</p>
                            <a href={"/posts/" + post.id}>Read More</a>
                        </div>
                    }
                }
            </div>
        </div>
    }
}
```

### 4.5 Middleware

Middleware processes HTTP requests before they reach controllers:

```zen
interface Middleware {
    fn handle(request: Request, next: fn(Request): Response): Response;
}

class AuthMiddleware implements Middleware {
    fn handle(request: Request, next: fn(Request): Response): Response {
        if !auth().check() {
            return redirect("/login");
        }
        return next(request);
    }
}

class IsAdminMiddleware implements Middleware {
    fn handle(request: Request, next: fn(Request): Response): Response {
        if !auth().user().is_admin() {
            return abort(403, "Unauthorized");
        }
        return next(request);
    }
}

class LoggingMiddleware implements Middleware {
    fn handle(request: Request, next: fn(Request): Response): Response {
        let start_time = microtime();
        let response = next(request);
        let duration = microtime() - start_time;
        
        log().info("Request: " + request.method() + " " + request.path() + " (" + duration + "ms)");
        
        return response;
    }
}
```

### 4.6 Database Migrations

Manage database schema with migrations:

```zen
// database/migrations/2025_01_01_000000_create_users_table.zen

migration "2025_01_01_000000_create_users_table" {
    fn up() {
        Schema.create("users", fn(table: Blueprint) {
            table.id();  // Creates 'id' primary key
            table.string("name");
            table.string("email").unique();
            table.string("password");
            table.string("avatar_url").nullable();
            table.string("bio", 500).nullable();
            table.bool("is_active").default(true);
            table.bool("is_admin").default(false);
            table.timestamp("email_verified_at").nullable();
            table.string("remember_token", 100).nullable();
            table.timestamps(); // Creates created_at and updated_at
            
            table.index("email");
        });
    }

    fn down() {
        Schema.drop("users");
    }
}

// Run migrations
// zenpkg migrate

// Rollback
// zenpkg migrate:rollback
```

## 5. Request Lifecycle

1. **Entry Point**: Request hits `public/index.zen`
2. **Bootstrapping**: Application initializes and loads configuration
3. **Service Container**: Services and dependencies are registered
4. **Routing**: Router matches URL to appropriate route
5. **Middleware (Before)**: Request passes through middleware (auth, logging, etc.)
6. **Controller**: Designated controller method executes business logic
7. **Middleware (After)**: Response passes through middleware again
8. **View Rendering**: If returning a View, components compile to HTML
9. **Response**: Final HTTP response sent to client

## 6. Security Features

### CSRF Protection
```zen
// Enable CSRF token on forms
<form action="/users" method="POST">
    {{ csrf_field() }}
    <input type="text" name="name" />
    <button type="submit">Create</button>
</form>
```

### SQL Injection Prevention
```zen
// Always use parameterized queries (automatic with ORM)
let user = User.where("email", "=", user_input).first(); // Safe
```

### XSS Protection
```zen
// Automatic output encoding
<p>{user_generated_content}</p> <!-- Automatically escaped -->
```

### Password Hashing
```zen
let password_hash = hash("password123");
let is_valid = check_hash("password123", password_hash);
```

## 7. CLI Integration

Use the `zenpkg` CLI for project management:

```bash
# Create new project
zenpkg new my_app
cd my_app

# Generate scaffolding
zenpkg make:controller UserController
zenpkg make:model User
zenpkg make:migration create_users_table
zenpkg make:request StoreUserRequest
zenpkg make:middleware AuthMiddleware

# Database operations
zenpkg migrate
zenpkg migrate:rollback
zenpkg seed:run

# Development
zenpkg serve            # Start dev server on localhost:8000
zenpkg serve --port=3000

# Testing
zenpkg test
zenpkg test tests/Feature/UserTest.zen

# Production
zenpkg build
zenpkg deploy
```

## 8. Configuration

Configuration files are in `config/` directory:

```zen
// config/app.zen
export config = {
    "app_name": "My Zenith App",
    "app_env": env("APP_ENV", "production"),
    "debug": env("APP_DEBUG", false),
    "url": env("APP_URL", "http://localhost:8000"),
    "timezone": "UTC",
    "locale": "en",
};

// config/database.zen
export config = {
    "default": env("DB_CONNECTION", "mysql"),
    "connections": {
        "mysql": {
            "driver": "mysql",
            "host": env("DB_HOST", "127.0.0.1"),
            "port": env("DB_PORT", 3306),
            "database": env("DB_DATABASE", "zenith"),
            "username": env("DB_USERNAME", "root"),
            "password": env("DB_PASSWORD", ""),
        },
        "sqlite": {
            "driver": "sqlite",
            "database": "database.sqlite",
        },
    },
};
```

## 9. Testing

Write tests for your application:

```zen
// tests/Feature/UserTest.zen

test "user can view user profile" {
    let user = User.factory().create();
    let response = get("/users/" + user.id);
    
    response.assertStatus(200);
    response.assertSee(user.name);
}

test "user can store new user" {
    let response = post("/users", {
        "name": "Alice",
        "email": "alice@example.com",
    });
    
    response.assertRedirect("/users");
    assertDatabaseHas("users", {
        "email": "alice@example.com",
    });
}

test "unauthorized user cannot delete user" {
    let response = delete("/users/1");
    response.assertStatus(401);
}
```

## 10. Deployment

### Docker
```docker
FROM zenith:latest
WORKDIR /app
COPY . .
RUN zenpkg install
RUN zenpkg build --release
EXPOSE 8000
CMD ["zenpkg", "serve", "--host=0.0.0.0"]
```

### Environment Configuration
```bash
APP_ENV=production
APP_DEBUG=false
APP_URL=https://myapp.com
DB_HOST=db.example.com
DB_USERNAME=zenith_user
DB_PASSWORD=secure_password
```

## 11. Roadmap

- **v1.0**: Core MVC framework with ORM and UI components
- **v1.5**: Advanced routing, service providers, events system
- **v2.0**: Real-time features (WebSockets), GraphQL support
- **v3.0**: Distributed caching, microservices support

---

See also: [Zenith Language](./ZenithLanguage.md) | [Compiler](./ZenithCompiler.md) | [Package Manager](./ZenPackageManager.md)
