# Clean Code Checklist

A reference guide for writing clean, maintainable code. Use this checklist during development and code review.

## Naming Conventions

### Variables

**✓ Good:**
```csharp
var userEmail = "user@example.com";
var totalPrice = CalculateTotal(items);
var isAuthenticated = CheckAuth();
private const int MaxRetryAttempts = 3;
```

**✗ Bad:**
```csharp
var e = "user@example.com";
var tp = CalculateTotal(items);
var auth = CheckAuth();
private const int max = 3;
```

**Rules:**
- Use descriptive, meaningful names
- Use `camelCase` for local variables and parameters
- Use `PascalCase` for methods, properties, classes, and constants
- Use `_camelCase` for private fields
- No single-letter variables except loop counters (i, j, k)
- Boolean variables should start with is, has, can, should
- Avoid abbreviations unless widely understood

### Methods

**✓ Good:**
```csharp
decimal CalculateOrderTotal(IEnumerable<Item> items, decimal taxRate) { ... }
bool ValidateEmailFormat(string email) { ... }
User GetUserById(int userId) { ... }
string FormatCurrency(decimal amount) { ... }
```

**✗ Bad:**
```csharp
decimal Calc(IEnumerable<Item> i, decimal t) { ... }
bool Validate(string e) { ... }
User Get(int id) { ... }
string Format(decimal a) { ... }
```

**Rules:**
- Use verb phrases (Calculate, Validate, Format, Get, Create, Update, Delete)
- Method names should describe what they do
- Use `PascalCase` in C#
- Be specific: `GetUserById` not `GetUser`

### Classes and Records

**✓ Good:**
```csharp
public class UserAuthenticationService { ... }
public class OrderProcessor { ... }
public record CreateUserRequest { ... }
public class ProductCard { ... }
```

**✗ Bad:**
```csharp
public class UAS { ... }
public class Processor { ... }
public record Form1 { ... }
public class Card { ... }
```

**Rules:**
- Use PascalCase
- Use nouns or noun phrases
- Be descriptive and specific
- Avoid abbreviations

## Function Design

### Single Responsibility Principle

Each method should do one thing and do it well.

**✓ Good:**
```csharp
bool ValidateEmail(string email)
{
    var regex = new Regex(@"^[^\s@]+@[^\s@]+\.[^\s@]+$");
    return regex.IsMatch(email);
}

bool ValidatePassword(string password)
{
    return password.Length >= 8;
}

User CreateUser(string email, string password)
{
    if (!ValidateEmail(email)) throw new ArgumentException("Invalid email");
    if (!ValidatePassword(password)) throw new ArgumentException("Invalid password");
    return _database.Users.Insert(new User { Email = email, Password = password });
}
```

**✗ Bad:**
```csharp
User CreateUser(string email, string password)
{
    // Doing too many things: validation, hashing, database insert
    var emailRegex = new Regex(@"^[^\s@]+@[^\s@]+\.[^\s@]+$");
    if (!emailRegex.IsMatch(email)) throw new ArgumentException("Invalid email");
    if (password.Length < 8) throw new ArgumentException("Invalid password");
    var hashedPassword = BCrypt.HashPassword(password);
    return _database.Users.Insert(new User { Email = email, Password = hashedPassword });
}
```

### Method Size

Keep methods small - under 50 lines is ideal, under 20 is better.

**✓ Good:**
```csharp
Order ProcessOrder(Order order)
{
    ValidateOrder(order);
    var total = CalculateTotal(order);
    var payment = ProcessPayment(order, total);
    return CreateOrderRecord(order, payment);
}
```

**✗ Bad:**
```csharp
Order ProcessOrder(Order order)
{
    // 150 lines of validation, calculation, payment, and database operations
    // ...
}
```

### Parameter Count

Limit to 3-4 parameters. Use request objects for more.

**✓ Good:**
```csharp
User CreateUser(CreateUserRequest request) { ... }

decimal CalculatePrice(decimal basePrice, PriceOptions options) { ... }
```

**✗ Bad:**
```csharp
User CreateUser(string email, string name, int age, string street, string city, string state, string zip, string phone) { ... }

decimal CalculatePrice(decimal basePrice, decimal tax, decimal discount, decimal shipping, decimal handling, decimal fees) { ... }
```

### Return Early

Reduce nesting by returning early.

**✓ Good:**
```csharp
Payment? ProcessPayment(Order order)
{
    if (order == null) return null;
    if (!order.Items.Any()) return null;
    if (order.Total <= 0) return null;

    return ChargeCard(order);
}
```

**✗ Bad:**
```csharp
Payment? ProcessPayment(Order order)
{
    if (order != null)
    {
        if (order.Items.Any())
        {
            if (order.Total > 0)
            {
                return ChargeCard(order);
            }
        }
    }
    return null;
}
```

## DRY Principle (Don't Repeat Yourself)

Extract repeated code into methods.

**✓ Good:**
```csharp
string FormatCurrency(decimal amount)
{
    return amount.ToString("C", new CultureInfo("en-US"));
}

var subtotal = FormatCurrency(49.99m);
var tax = FormatCurrency(4.50m);
var total = FormatCurrency(54.49m);
```

**✗ Bad:**
```csharp
var subtotal = (49.99m).ToString("C", new CultureInfo("en-US"));
var tax = (4.50m).ToString("C", new CultureInfo("en-US"));
var total = (54.49m).ToString("C", new CultureInfo("en-US"));
```

## Error Handling

### Explicit Error Handling

Never swallow errors silently.

**✓ Good:**
```csharp
async Task<User> FetchUserAsync(int userId)
{
    try
    {
        var response = await _api.GetAsync($"/users/{userId}");
        return response.Data;
    }
    catch (HttpException ex) when (ex.StatusCode == HttpStatusCode.NotFound)
    {
        throw new UserNotFoundException(userId);
    }
    catch (Exception ex)
    {
        _logger.LogError(ex, "Failed to fetch user {UserId}", userId);
        throw new ApiException("Failed to fetch user", ex);
    }
}
```

**✗ Bad:**
```csharp
async Task<User?> FetchUserAsync(int userId)
{
    try
    {
        var response = await _api.GetAsync($"/users/{userId}");
        return response.Data;
    }
    catch
    {
        return null; // Silent failure - bad!
    }
}
```

### Input Validation

Validate inputs early and explicitly.

**✓ Good:**
```csharp
decimal CalculateDiscount(decimal price, decimal percent)
{
    if (price < 0)
        throw new ArgumentException("Price must be a non-negative number");
    if (percent < 0 || percent > 100)
        throw new ArgumentException("Percent must be between 0 and 100");
    return price * (percent / 100);
}
```

**✗ Bad:**
```csharp
decimal CalculateDiscount(decimal price, decimal percent)
{
    return price * (percent / 100); // No validation!
}
```

## Comments

### Comment the "Why" Not the "What"

**✓ Good:**
```csharp
// Using exponential backoff to prevent API overwhelm during outages
var delay = Math.Pow(2, attempt) * 1000;

// Legacy accounts (pre-2023) are grandfathered into old pricing
if (account.CreatedAt < new DateTime(2023, 1, 1))
{
    return LegacyPricing;
}
```

**✗ Bad:**
```csharp
// Calculate delay
var delay = Math.Pow(2, attempt) * 1000;

// Check if date is before 2023
if (account.CreatedAt < new DateTime(2023, 1, 1))
{
    return LegacyPricing;
}
```

### Avoid Obvious Comments

**✓ Good:**
```csharp
// Complicated logic that needs explanation
var result = ComplexCalculation();
```

**✗ Bad:**
```csharp
// Increment i
i++;

// Set name to John
var name = "John";
```

### Remove Dead Code and Commented Code

**✓ Good:**
```csharp
Order ProcessOrder(Order order)
{
    ValidateOrder(order);
    return CreateOrder(order);
}
```

**✗ Bad:**
```csharp
Order ProcessOrder(Order order)
{
    ValidateOrder(order);
    // var oldMethod = ProcessOldWay(order);
    // return oldMethod;
    return CreateOrder(order);
}
```

## Code Organization

### File Structure

Organize files logically using a layered or Clean Architecture structure:

```
src/
├── MyApp.Api/              # Presentation layer
│   ├── Controllers/
│   │   ├── AuthController.cs
│   │   └── UsersController.cs
│   └── Program.cs
├── MyApp.Application/      # Business logic
│   ├── Services/
│   │   ├── AuthService.cs
│   │   └── UserService.cs
│   └── DTOs/
│       ├── CreateUserRequest.cs
│       └── UserResponse.cs
├── MyApp.Domain/           # Domain models
│   └── Entities/
│       ├── User.cs
│       └── Order.cs
└── MyApp.Infrastructure/   # Data access & external services
    ├── Repositories/
    │   └── UserRepository.cs
    └── Persistence/
        └── AppDbContext.cs
```

### File Size

Keep files under 300 lines. Split large files into smaller classes.

### Namespaces and Classes

**✓ Good:**
```csharp
// DateUtils.cs
namespace MyApp.Application.Utils;

public static class DateUtils
{
    public static string FormatDate(DateTime date) { ... }
    public static DateTime ParseDate(string str) { ... }
    public const string DateFormat = "yyyy-MM-dd";
}
```

**✗ Bad:**
```csharp
// Utils.cs — mixing unrelated concerns in one static class
public static class Utils
{
    public static string FormatDate(DateTime date) { ... }
    public static DateTime ParseDate(string str) { ... }
    public static decimal CalculateTotal(IEnumerable<decimal> prices) { ... }
    public static bool ValidateEmail(string email) { ... }
}
```

## Git Commit Practices

### Commit Messages

Follow Conventional Commits format:

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code refactoring
- `test`: Test changes
- `docs`: Documentation
- `chore`: Maintenance

**Examples:**
```
feat(auth): add password reset functionality

fix(api): handle null response from user service

refactor(utils): extract date formatting logic

test(auth): add edge case tests for login

docs(readme): update installation instructions
```

### Commit Size

- Commit after each logical unit of work
- Keep commits small and focused
- One concern per commit
- Commit frequently (at least daily)

**✓ Good:**
```
feat(auth): add User entity
feat(auth): add login endpoint
feat(auth): add session management
test(auth): add unit tests for auth service
```

**✗ Bad:**
```
feat(auth): complete entire authentication system
# (One massive commit with 50+ file changes)
```

## Quick Reference Checklist

When writing code, ask yourself:

- [ ] Are my variable and method names descriptive?
- [ ] Are my methods small (under 50 lines)?
- [ ] Does each method have a single responsibility?
- [ ] Have I eliminated code duplication?
- [ ] Are errors handled explicitly?
- [ ] Do comments explain "why" not "what"?
- [ ] Have I removed dead code and commented code?
- [ ] Is input validation in place?
- [ ] Are edge cases handled?
- [ ] Would another developer understand this code?
- [ ] Can this be simplified?
- [ ] Have I followed project conventions?
- [ ] Are my commits small and focused?
- [ ] Are my commit messages clear?

## Summary

**The Golden Rule:** Write code that your future self (or another developer) will thank you for.

Clean code is:
- **Readable** - Easy to understand
- **Maintainable** - Easy to modify
- **Testable** - Easy to test
- **Scalable** - Easy to extend
- **Reliable** - Handles errors gracefully

Remember: Code is read far more often than it is written. Optimize for readability.
