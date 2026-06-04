# Testing Standards

A comprehensive guide to testing patterns, strategies, and best practices for achieving high-quality test coverage.

## Table of Contents

1. [Testing Pyramid](#testing-pyramid)
2. [Unit Testing](#unit-testing)
3. [Integration Testing](#integration-testing)
4. [End-to-End Testing](#end-to-end-testing)
5. [Coverage Targets](#coverage-targets)
6. [Mocking Strategies](#mocking-strategies)
7. [Test Organization](#test-organization)
8. [Best Practices](#best-practices)

## Testing Pyramid

The testing pyramid guides how to balance different types of tests:

```
        /\         E2E Tests (Few)
       /  \          - Test complete user flows
      /____\         - Slow, expensive, brittle
     /      \      Integration Tests (Some)
    /________\       - Test component interactions
   /          \      - Moderate speed and cost
  /____________\   Unit Tests (Many)
 /              \    - Test individual functions
/________________\   - Fast, cheap, reliable
                   
```

**Distribution:**
- 70% Unit Tests
- 20% Integration Tests
- 10% E2E Tests

## Unit Testing

Unit tests verify individual functions, methods, or components in isolation.

### Characteristics

- Fast (milliseconds)
- Isolated (no external dependencies)
- Focused (one thing per test)
- Deterministic (same result every time)

### Unit Test Patterns

#### Testing Pure Functions

**✓ Good:**
```csharp
// Function under test
public static class DiscountCalculator
{
    public static decimal CalculateDiscount(decimal price, decimal discountPercent)
    {
        if (price < 0 || discountPercent < 0 || discountPercent > 100)
            throw new ArgumentException("Invalid input");
        return price * (discountPercent / 100);
    }
}

// Tests
public class CalculateDiscountTests
{
    [Fact]
    public void ShouldCalculateCorrectDiscountAmount()
    {
        Assert.Equal(10m, DiscountCalculator.CalculateDiscount(100m, 10m));
        Assert.Equal(10m, DiscountCalculator.CalculateDiscount(50m, 20m));
    }

    [Fact]
    public void ShouldHandleZeroDiscount()
    {
        Assert.Equal(0m, DiscountCalculator.CalculateDiscount(100m, 0m));
    }

    [Fact]
    public void ShouldHandle100PercentDiscount()
    {
        Assert.Equal(100m, DiscountCalculator.CalculateDiscount(100m, 100m));
    }

    [Fact]
    public void ShouldThrowForNegativePrice()
    {
        Assert.Throws<ArgumentException>(() =>
            DiscountCalculator.CalculateDiscount(-10m, 10m));
    }

    [Theory]
    [InlineData(100, -5)]
    [InlineData(100, 150)]
    public void ShouldThrowForInvalidDiscountPercent(decimal price, decimal percent)
    {
        Assert.Throws<ArgumentException>(() =>
            DiscountCalculator.CalculateDiscount(price, percent));
    }
}
```

#### Testing Classes

**✓ Good:**
```csharp
// Class under test
public class ShoppingCart
{
    private readonly List<CartItem> _items = new();

    public void AddItem(CartItem item) => _items.Add(item);
    public decimal GetTotal() => _items.Sum(i => i.Price);
    public int GetItemCount() => _items.Count;
}

// Tests
public class ShoppingCartTests
{
    public class AddItemTests
    {
        private readonly ShoppingCart _cart = new();

        [Fact]
        public void ShouldAddItemToCart()
        {
            _cart.AddItem(new CartItem { Id = 1, Price = 10m });
            Assert.Equal(1, _cart.GetItemCount());
        }

        [Fact]
        public void ShouldAllowMultipleItems()
        {
            _cart.AddItem(new CartItem { Id = 1, Price = 10m });
            _cart.AddItem(new CartItem { Id = 2, Price = 20m });
            Assert.Equal(2, _cart.GetItemCount());
        }
    }

    public class GetTotalTests
    {
        private readonly ShoppingCart _cart = new();

        [Fact]
        public void ShouldReturn0ForEmptyCart()
        {
            Assert.Equal(0m, _cart.GetTotal());
        }

        [Fact]
        public void ShouldCalculateTotalOfSingleItem()
        {
            _cart.AddItem(new CartItem { Id = 1, Price = 15m });
            Assert.Equal(15m, _cart.GetTotal());
        }

        [Fact]
        public void ShouldCalculateTotalOfMultipleItems()
        {
            _cart.AddItem(new CartItem { Id = 1, Price = 10m });
            _cart.AddItem(new CartItem { Id = 2, Price = 20m });
            _cart.AddItem(new CartItem { Id = 3, Price = 5m });
            Assert.Equal(35m, _cart.GetTotal());
        }
    }
}
```

#### Testing Async Methods

**✓ Good:**
```csharp
// Method under test
public class UserService(IApiClient api)
{
    public async Task<User> FetchUserAsync(int userId)
    {
        var response = await api.GetAsync<User>($"/users/{userId}");
        return response.Data;
    }
}

// Tests
public class FetchUserTests
{
    private readonly Mock<IApiClient> _apiMock = new();
    private readonly UserService _sut;

    public FetchUserTests()
    {
        _sut = new UserService(_apiMock.Object);
    }

    [Fact]
    public async Task ShouldReturnUserDataOnSuccess()
    {
        var mockUser = new User { Id = 1, Name = "John" };
        _apiMock.Setup(a => a.GetAsync<User>("/users/1"))
                .ReturnsAsync(new ApiResponse<User> { Data = mockUser });

        var user = await _sut.FetchUserAsync(1);

        Assert.Equal(mockUser, user);
        _apiMock.Verify(a => a.GetAsync<User>("/users/1"), Times.Once);
    }

    [Fact]
    public async Task ShouldThrowOnFailure()
    {
        _apiMock.Setup(a => a.GetAsync<User>(It.IsAny<string>()))
                .ThrowsAsync(new HttpRequestException("Network error"));

        await Assert.ThrowsAsync<HttpRequestException>(() => _sut.FetchUserAsync(1));
    }
}
```

#### Testing Controllers

**✓ Good:**
```csharp
// Controller under test
[ApiController]
[Route("api/auth")]
public class AuthController(IAuthService authService) : ControllerBase
{
    [HttpPost("login")]
    public async Task<IActionResult> Login(LoginRequest request)
    {
        var result = await authService.LoginAsync(request.Email, request.Password);
        if (result is null) return Unauthorized(new { Error = "Invalid credentials" });
        return Ok(result);
    }
}

// Tests
public class AuthControllerTests
{
    private readonly Mock<IAuthService> _authServiceMock = new();
    private readonly AuthController _sut;

    public AuthControllerTests()
    {
        _sut = new AuthController(_authServiceMock.Object);
    }

    [Fact]
    public async Task ShouldReturnOkWithTokenOnValidCredentials()
    {
        var loginResult = new LoginResult { Token = "jwt-token", User = new User { Email = "user@example.com" } };
        _authServiceMock.Setup(s => s.LoginAsync("user@example.com", "password123"))
                        .ReturnsAsync(loginResult);

        var result = await _sut.Login(new LoginRequest { Email = "user@example.com", Password = "password123" });

        var okResult = Assert.IsType<OkObjectResult>(result);
        Assert.Equal(loginResult, okResult.Value);
    }

    [Fact]
    public async Task ShouldReturnUnauthorizedOnInvalidCredentials()
    {
        _authServiceMock.Setup(s => s.LoginAsync(It.IsAny<string>(), It.IsAny<string>()))
                        .ReturnsAsync((LoginResult?)null);

        var result = await _sut.Login(new LoginRequest { Email = "user@example.com", Password = "wrongpassword" });

        Assert.IsType<UnauthorizedObjectResult>(result);
    }
}
```

## Integration Testing

Integration tests verify that multiple components work together correctly.

### Characteristics

- Moderate speed (seconds)
- Tests real interactions
- May use real or test database
- Tests interfaces between components

### Integration Test Patterns

**✓ Good:**
```csharp
// Testing service layer integration
public class UserServiceIntegrationTests : IAsyncLifetime
{
    private TestDatabase _database = null!;
    private UserService _userService = null!;

    public async Task InitializeAsync()
    {
        _database = await TestDatabase.CreateAsync();
        _userService = new UserService(_database);
    }

    public async Task DisposeAsync()
    {
        await _database.ClearAsync();
        await _database.DisposeAsync();
    }

    [Fact]
    public async Task ShouldCreateAndRetrieveUser()
    {
        var userData = new CreateUserRequest { Email = "test@example.com", Name = "Test User" };

        var createdUser = await _userService.CreateUserAsync(userData);
        Assert.NotNull(createdUser.Id);
        Assert.Equal(userData.Email, createdUser.Email);

        var retrievedUser = await _userService.GetUserAsync(createdUser.Id);
        Assert.Equivalent(createdUser, retrievedUser);
    }

    [Fact]
    public async Task ShouldThrowWhenGettingNonExistentUser()
    {
        await Assert.ThrowsAsync<UserNotFoundException>(() => _userService.GetUserAsync(999));
    }

    [Fact]
    public async Task ShouldUpdateUserDetails()
    {
        var user = await _userService.CreateUserAsync(new CreateUserRequest
        {
            Email = "test@example.com",
            Name = "Original Name"
        });

        var updated = await _userService.UpdateUserAsync(user.Id, new UpdateUserRequest
        {
            Name = "Updated Name"
        });

        Assert.Equal("Updated Name", updated.Name);
        Assert.Equal("test@example.com", updated.Email);
    }
}
```

### API Integration Testing

**✓ Good:**
```csharp
// Testing API endpoints with WebApplicationFactory
public class AuthApiIntegrationTests(WebApplicationFactory<Program> factory)
    : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient _client = factory.CreateClient();

    [Fact]
    public async Task ShouldLoginWithValidCredentials()
    {
        var payload = new { email = "user@example.com", password = "password123" };
        var response = await _client.PostAsJsonAsync("/api/auth/login", payload);

        response.EnsureSuccessStatusCode();
        var body = await response.Content.ReadFromJsonAsync<LoginResponse>();
        Assert.NotNull(body?.Token);
        Assert.Equal("user@example.com", body.User.Email);
    }

    [Fact]
    public async Task ShouldRejectInvalidCredentials()
    {
        var payload = new { email = "user@example.com", password = "wrongpassword" };
        var response = await _client.PostAsJsonAsync("/api/auth/login", payload);

        Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
        var body = await response.Content.ReadFromJsonAsync<ErrorResponse>();
        Assert.Equal("Invalid credentials", body?.Error);
    }

    [Fact]
    public async Task ShouldRequireAuthenticationForProtectedRoutes()
    {
        var response = await _client.GetAsync("/api/users/profile");
        Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
    }
}
```

## End-to-End Testing

E2E tests verify complete user workflows from UI to backend.

### Characteristics

- Slow (seconds to minutes)
- Test real user scenarios
- Use real browser
- Most expensive to maintain

### E2E Test Patterns

**✓ Good:**
```csharp
// Using Playwright for .NET
public class UserLoginFlowTests : PageTest
{
    public override BrowserNewContextOptions ContextOptions() => new()
    {
        BaseURL = "http://localhost:5000"
    };

    [Fact]
    public async Task ShouldAllowUserToLoginSuccessfully()
    {
        await Page.GotoAsync("/");
        await Page.ClickAsync("[data-testid=login-link]");
        await Page.WaitForSelectorAsync("[data-testid=login-form]");

        await Page.FillAsync("[data-testid=email-input]", "user@example.com");
        await Page.FillAsync("[data-testid=password-input]", "password123");
        await Page.ClickAsync("[data-testid=submit-button]");

        await Page.WaitForURLAsync("**/dashboard");
        await Expect(Page.Locator("[data-testid=user-name]")).ToContainTextAsync("John Doe");
    }

    [Fact]
    public async Task ShouldShowErrorForInvalidCredentials()
    {
        await Page.GotoAsync("/");
        await Page.ClickAsync("[data-testid=login-link]");
        await Page.FillAsync("[data-testid=email-input]", "user@example.com");
        await Page.FillAsync("[data-testid=password-input]", "wrongpassword");
        await Page.ClickAsync("[data-testid=submit-button]");

        await Expect(Page.Locator("[data-testid=error-message]")).ToContainTextAsync("Invalid credentials");
    }

    [Fact]
    public async Task ShouldAllowUserToLogout()
    {
        // Login first
        await LoginUserAsync(Page, "user@example.com", "password123");

        // Then logout
        await Page.ClickAsync("[data-testid=user-menu]");
        await Page.ClickAsync("[data-testid=logout-button]");

        await Page.WaitForURLAsync("**/");
        await Expect(Page.Locator("[data-testid=login-link]")).ToBeVisibleAsync();
    }
}
```

## Coverage Targets

### Minimum Coverage Requirements

- **Overall Coverage:** 80% minimum
- **Critical Paths:** 90%+ (auth, payments, data mutations)
- **Utility Functions:** 95%+ (should be easy to fully test)
- **New Code:** 90%+ (don't lower coverage with new changes)

### What to Cover

**High Priority (Must Test):**
- Business logic
- Data transformations
- Authentication and authorization
- Payment processing
- User input validation
- Error handling
- Edge cases and boundary conditions

**Medium Priority (Should Test):**
- API controllers
- API endpoints
- Database queries / repositories
- State management
- Navigation flows

**Low Priority (Optional):**
- Trivial getters/setters
- Simple utility functions
- Third-party library wrappers
- Configuration files

### What NOT to Test

- Third-party library internals
- Generated code (migrations, build artifacts, scaffolded code)
- Mock objects themselves
- Framework code
- Constants and configuration

## Mocking Strategies

### When to Mock

- External APIs
- Database connections
- File system operations
- Time-dependent functions
- Random number generation
- Third-party services

### Mock Examples

**Mocking with Moq:**
```csharp
var mockService = new Mock<IUserService>();

// Setup return values
mockService.Setup(s => s.GetUserAsync(It.IsAny<int>()))
           .ReturnsAsync(new User { Id = 1, Name = "John" });

mockService.Setup(s => s.CreateUserAsync(It.IsAny<CreateUserRequest>()))
           .ReturnsAsync(new User { Id = 2 });

// Verify calls
mockService.Verify(s => s.GetUserAsync(42), Times.Once);
mockService.Verify(s => s.CreateUserAsync(It.IsAny<CreateUserRequest>()), Times.Never);
```

**Mocking Interfaces:**
```csharp
// Define the interface
public interface IEmailSender
{
    Task SendAsync(string to, string subject, string body);
}

// Mock in tests
var mockEmailSender = new Mock<IEmailSender>();
mockEmailSender.Setup(s => s.SendAsync(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
               .Returns(Task.CompletedTask);

// Inject via constructor
var sut = new UserService(mockEmailSender.Object);
```

**Mocking with Callbacks:**
```csharp
var sentEmails = new List<string>();
mockEmailSender
    .Setup(s => s.SendAsync(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
    .Callback<string, string, string>((to, _, _) => sentEmails.Add(to))
    .Returns(Task.CompletedTask);
```

**Mocking Time (.NET 8+):**
```csharp
// Using the built-in TimeProvider abstraction
var fakeTime = new FakeTimeProvider(new DateTimeOffset(2024, 1, 1, 0, 0, 0, TimeSpan.Zero));

// Inject into the service
var sut = new SchedulerService(fakeTime);

// Advance time in tests
fakeTime.Advance(TimeSpan.FromDays(1));
```

## Test Organization

### File Structure

```
tests/
├── MyApp.UnitTests/
│   ├── Services/
│   │   ├── UserServiceTests.cs
│   │   └── AuthServiceTests.cs
│   ├── Utils/
│   │   └── DateUtilsTests.cs
│   └── Controllers/
│       └── AuthControllerTests.cs
├── MyApp.IntegrationTests/
│   ├── AuthApiTests.cs
│   └── UserServiceIntegrationTests.cs
└── MyApp.E2eTests/
    ├── LoginFlowTests.cs
    └── CheckoutFlowTests.cs
```

### Naming Conventions

- Test projects: `MyApp.UnitTests`, `MyApp.IntegrationTests`, `MyApp.E2eTests`
- Test classes: `[ClassName]Tests` or nested `[ClassName]Tests.[MethodName]Tests`
- Test methods: `Should[ExpectedBehavior]` or `Should[ExpectedBehavior]When[Condition]`

### Test Structure (AAA Pattern)

```csharp
[Fact]
public void ShouldCalculateTotalCorrectly()
{
    // Arrange - Set up test data
    var items = new[]
    {
        new CartItem { Price = 10m },
        new CartItem { Price = 20m }
    };

    // Act - Execute the code under test
    var total = CalculateTotal(items);

    // Assert - Verify the result
    Assert.Equal(30m, total);
}
```

## Best Practices

### 1. Write Descriptive Test Names

**✓ Good:**
```csharp
[Fact]
public void ShouldReturn0ForEmptyCart() { ... }

[Fact]
public void ShouldThrowWhenPriceIsNegative() { ... }

[Fact]
public void ShouldRedirectToDashboardAfterSuccessfulLogin() { ... }
```

**✗ Bad:**
```csharp
[Fact]
public void Works() { ... }

[Fact]
public void Test1() { ... }

[Fact]
public void ShouldCalculate() { ... }
```

### 2. Test One Thing Per Test

**✓ Good:**
```csharp
[Fact]
public void ShouldValidateEmailFormat()
{
    Assert.True(ValidateEmail("user@example.com"));
}

[Fact]
public void ShouldRejectEmailWithoutAtSign()
{
    Assert.False(ValidateEmail("userexample.com"));
}
```

**✗ Bad:**
```csharp
[Fact]
public void ShouldValidateEmail()
{
    Assert.True(ValidateEmail("user@example.com"));
    Assert.False(ValidateEmail("userexample.com"));
    Assert.False(ValidateEmail(""));
    // Testing too many scenarios
}
```

### 3. Keep Tests Independent

Tests should not depend on each other or share state.

**✓ Good:**
```csharp
public class UserTests : IAsyncLifetime
{
    private readonly TestDatabase _database = new();

    public Task InitializeAsync() => _database.ClearAsync();
    public Task DisposeAsync() => Task.CompletedTask;

    [Fact]
    public async Task ShouldCreateUser()
    {
        var user = await CreateUserAsync(new CreateUserRequest { Email = "test@example.com" });
        Assert.NotNull(user);
    }

    [Fact]
    public async Task ShouldFindUserByEmail()
    {
        await CreateUserAsync(new CreateUserRequest { Email = "test@example.com" });
        var user = await FindUserAsync("test@example.com");
        Assert.NotNull(user);
    }
}
```

### 4. Test Edge Cases

Always test:
- Null/empty inputs
- Boundary values (min, max)
- Invalid inputs
- Error conditions

```csharp
public class CalculateAgeTests
{
    [Fact]
    public void ShouldCalculateAgeCorrectly()
    {
        Assert.Equal(34, AgeCalculator.CalculateAge(new DateTime(1990, 1, 1)));
    }

    [Fact]
    public void ShouldThrowForNullBirthdate()
    {
        Assert.Throws<ArgumentNullException>(() => AgeCalculator.CalculateAge(null));
    }

    [Fact]
    public void ShouldThrowForFutureBirthdate()
    {
        Assert.Throws<ArgumentException>(() =>
            AgeCalculator.CalculateAge(new DateTime(2050, 1, 1)));
    }

    [Fact]
    public void ShouldHandleSameDayAge0()
    {
        Assert.Equal(0, AgeCalculator.CalculateAge(DateTime.Today));
    }
}
```

### 5. Use Test Data Builders

**✓ Good:**
```csharp
// Factory method pattern
private static User CreateTestUser(Action<User>? configure = null)
{
    var user = new User
    {
        Id = 1,
        Email = "test@example.com",
        Name = "Test User",
        Age = 25
    };
    configure?.Invoke(user);
    return user;
}

[Fact]
public void ShouldRejectUnderageUser()
{
    var user = CreateTestUser(u => u.Age = 17);
    Assert.False(AgeValidator.IsAdult(user));
}
```

### 6. Clean Up After Tests

```csharp
public class ServiceTests : IAsyncLifetime
{
    private readonly TestDatabase _database = new();
    private readonly TestServer _server = new();

    public async Task InitializeAsync()
    {
        await _database.InitializeAsync();
        await _server.StartAsync();
    }

    public async Task DisposeAsync()
    {
        await _database.ClearAsync();
        await _database.DisposeAsync();
        await _server.StopAsync();
    }
}
```

## Summary

**Key Principles:**
- Test behavior, not implementation
- Write tests alongside code (TDD when appropriate)
- Aim for 80%+ coverage
- Focus on critical paths
- Test edge cases and errors
- Keep tests fast and independent
- Use the testing pyramid as a guide
- Mock external dependencies
- Write descriptive test names
- Refactor tests like production code

**Remember:** Good tests give you confidence to refactor and change code without breaking functionality.
