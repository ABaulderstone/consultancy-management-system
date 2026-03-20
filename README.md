# Consultancy Job Scheduler

## Rationale

Pragmatically, this is a self-learning exercise to familiarize myself with a new stack. It's been several years since I worked with Rails, and I've never really touched Svelte (although I thoroughly enjoy Rich Harris's talks).

I wanted something with a bit of teeth technically so the idea is to build software I would actually use day to day in my current role. Our consultancy is extremely lean and agile at the moment, but some bespoke software that tracks consultants, jobs, utilization, etc is extremely appealing.

This project will at a bear mininum

- allow admin to create users with profiles
- allow admin to assign contracts and keep track of contract history across consultants
- allow admin to create jobs, keep track of clients etc
- allow employees/consultants to log in and see their assigned work
- allow employees/consultants to edit their own details

I hope to build out:

- Utilisation data
- Job margin data
- Third party api integrations
- Calendar of work
- Upskilling pathways for benched consultants

## Tech Stack

**Backend:** Ruby on Rails 8 (API mode), PostgreSQL, JWT authentication

**Frontend:** SvelteKit, TypeScript, SCSS, Vite

**Infrastructure:** Docker, Docker Compose, Nginx reverse proxy

## Architecture

The project is a monorepo with three core services orchestrated via Docker Compose:

- `backend` — Rails 8 API running on port 3000
- `frontend` — SvelteKit app running on port 5142
- `db` — PostgreSQL 15
- `nginx` — Reverse proxy routing `/api` traffic to the Rails backend and serving the Svelte SPA for all other routes, eliminating CORS and CSRF complexity

```
├── backend/        # Rails 8 API
├── frontend/       # SvelteKit + TypeScript + SCSS
├── nginx/          # Nginx config
└── docker-compose.dev.yml
```

## Getting Started

### Prerequisites

- Docker
- Docker Compose

### Running the app

```bash
# Start all services
make dev

# Stop all services
make down

# Restart with rebuild
make restart
```

The app will be available at `http://localhost`.

### Database setup

```bash
make rails command="db:setup"
```

This creates the database, runs migrations, and seeds development data including a default admin user.

**Default admin credentials:**

```
email: admin@example.com
password: password123
```

Employee accounts are seeded with generated emails in the format `firstname.lastname.0001@example.com`. Generated passwords are printed to stdout during seeding.

### Common commands

```bash
make console                    # Rails console
make migrate                    # Run pending migrations
make logs                       # Tail all service logs
make psql                       # Connect to PostgreSQL directly
make generate name="model Foo"  # Run a Rails generator
make swagger                    # Regenerate OpenAPI docs
```

### Environment Variables

The backend expects the following environment variables, set via Docker Compose in development:

| Variable            | Description                                |
| ------------------- | ------------------------------------------ |
| `DATABASE_HOST`     | PostgreSQL host (defaults to `db` service) |
| `DATABASE_USER`     | PostgreSQL username                        |
| `DATABASE_PASSWORD` | PostgreSQL password                        |
| `RAILS_ENV`         | Rails environment                          |

### API Documentation

Interactive API documentation is available via Swagger UI at `/api-docs` in development.

To regenerate docs after API changes:

```bash
make swagger
```

The OpenAPI spec is generated directly from RSpec integration tests using rswag, ensuring docs stay in sync with actual API behaviour.

### Testing

#### Frontend

There will be three pillars of frontend testing.
`Storybook` for UI components. Particularly useful to visualise the impact of props or changing component state, and allows the tracking of functions on click, submit etc.

##### Running Storybook

```bash
make storybook
```

## Storybook is available at `http://localhost:6006`.

`vitest` will be used for unit testing utility and helper functions. If required `@testing-library` may be added for complex component interactions, but at this stage is not necessary.

---

`Playwright` will be used for end to end testing of pages - with mocked fetch calls

#### Backend

The test suite covers models, service objects, and request specs with JSON schema validation on all responses.

```bash
# Run full suite
make test

# Run a specific file
make test file=spec/requests/users_spec.rb

# Run a specific line
make test file=spec/requests/users_spec.rb:45
```

- **Model specs** — validations, associations, scopes and custom validation logic via Shoulda Matchers
- **Service specs** — business logic tested in isolation, including transaction rollback behaviour
- **Request specs** — full HTTP stack tests with JSON schema validation on every response shape using `json_matchers`
- **Database isolation** — per-test isolation via DatabaseCleaner with transaction strategy

# Backend Architectural Decisions

### Service Object Pattern

Business logic is encapsulated in service objects inheriting from a shared `ApplicationService` base class, keeping controllers thin and logic testable in isolation.

```ruby
class Users::CreateUser < ApplicationService
  def call
    # generates email from name + padded ID
    # creates user and profile atomically in a transaction
    # returns { user:, password: } for downstream use
  end
end
```

### Authentication & Authorization

Stateless JWT authentication delivered via HttpOnly signed cookies, with bearer token support for API clients. Auth logic lives in composable concerns included by `ApplicationController`:

- `Authentication` — validates JWT and sets `Current.user` via a `before_action`
- `Authorization` — role-based access control with `only_admin!` and `authorize_admin_or_self!` helpers

### Error Handling

A centralised `ErrorHandling` concern provides consistent error responses across all endpoints. A status map drives rescue behaviour for all standard error types, with `ActiveRecord::RecordInvalid` returning structured field-level validation errors suitable for form handling on the frontend.

```json
{
  "status": 422,
  "error": "Unprocessable Content",
  "message": "Validation failed",
  "path": "/users",
  "timestamp": "2026-02-27T10:33:04Z",
  "details": {
    "last_name": ["can't be blank"]
  }
}
```

### Data Integrity

Business rules are enforced at multiple levels:

- Database-level unique partial index ensures only one active contract (with no end date) per user
- Model validations for `end_date_after_start_date` and `only_one_active_contract`
- Service layer automatically closes overlapping contracts when a new one is created, supporting both future-dated contracts and backdated administrative corrections

### Pagination

All collection endpoints return a consistent paginated envelope via Pagy:

```json
{
  "data": [...],
  "meta": { "page": 1, "limit": 20, "pages": 5, "count": 98 },
  "links": { "next": "...", "prev": null }
}
```

# Frontend Architectural Decisions

### Technology Choices

**SvelteKit** was chosen over plain Svelte for several reasons. Svelte 5 introduced a significantly new reactivity model and the third-party routing ecosystem hadn't caught up at the time of writing — SvelteKit's file based routing system was an easy choice - it was also familiar to `Next Js` which I have worked quite a bit in. It also leaves the door open for server-side rendering in future without any architectural changes, and its `$app/*` modules integrate cleanly with Storybook's SvelteKit addon.

**Bootstrap 5** via SCSS gives predictable, well-documented styling with a comprehensive component library. But also allows for easy overrides at a component level. This project does not use bootstrap js and instead relies on Svelte's reactivity model for UI interactions.

**TanStack Query** manages all server state. It provides automatic caching, background refetching, and separate `isLoading`/`isFetching`/`isError` states.

**Superforms with Zod** handles form state, validation and submission. Validation errors from the Rails API are mapped back onto form fields using the same field-level error structure, so backend validation errors appear inline exactly like client-side ones. A shared `handleFormSubmit` utility centralises this error mapping so individual forms only need to provide their happy path logic.

**Storybook** is used for component development and visual testing in isolation. It's particularly valuable for stateful UI components like the data table (loading, fetching, empty, error, sorted states) and form inputs (default, error, disabled).

### API Layer

The frontend communicates with the Rails backend through a typed HTTP client in `src/lib/api/`. The client handles automatic camelCase/snake_case conversion in both directions so the frontend always works with camelCase and Rails always receives snake_case. It also centralises authentication via `credentials: 'include'`, and error parsing into typed `ApiError` instances.

### Component Structure

```
src/lib/components/
├── ui/           # Generic, domain-agnostic components
│   ├── Button/
│   ├── Modal/
│   ├── DataTable/
│   ├── Pagination/
│   └── Form/
├── users/        # Domain-specific components
│   └── UserTable/
└── layout/
    └── Navbar/
```

UI components are designed to be reusable without domain knowledge. Domain components like `UserTable` compose UI components with application-specific column definitions and data shapes.
