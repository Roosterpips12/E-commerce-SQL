# E-commerce-SQL
# E-commerce Database System

A complete SQL database system for managing an e-commerce platform, including product management, customer orders, shopping cart functionality, and inventory tracking.

## 📊 Key Features

- Complete product catalog management
- Customer profile and order management
- Shopping cart system
- Order processing and tracking
- Inventory management with auto alerts
- Review and rating system
- Multi-address support for customers
- Automated stock management
- Sales analytics capabilities

## 🛠 Technologies Used

- MySQL 8.0
- Stored Procedures
- Triggers
- Foreign Keys and Constraints
- Transaction Management

## 📋 Database Schema

### Core Tables

#### Products
- Product information and inventory
- Price management
- Stock tracking
- Category classification

#### Customers
- Customer profiles
- Authentication data
- Contact information
- Activity tracking

#### Orders
- Order processing
- Payment tracking
- Shipping management
- Status updates

#### Shopping Cart
- Active cart items
- Price calculations
- Quantity management

## 💻 Installation

1. Clone the repository
```bash
git clone https://github.com/[your-username]/ecommerce-system.git
```

2. Import the database schema
```bash
mysql -u [username] -p [database_name] < schema.sql
```

3. Import test data
```bash
mysql -u [username] -p [database_name] < test_data.sql
```

## 📊 Sample Queries

### Get Best Selling Products
```sql
SELECT p.Name, SUM(oi.Quantity) as TotalSold
FROM Products p
JOIN OrderItems oi ON p.ProductID = oi.ProductID
GROUP BY p.ProductID
ORDER BY TotalSold DESC
LIMIT 10;
```

### Get Customer Purchase History
```sql
SELECT o.OrderID, o.OrderDate, o.TotalAmount
FROM Orders o
WHERE o.CustomerID = [customer_id]
ORDER BY o.OrderDate DESC;
```

## 📈 Business Analytics

1. **Sales Reports**
   - Daily/Monthly/Annual sales
   - Product performance
   - Category performance

2. **Customer Analytics**
   - Purchase patterns
   - Customer lifetime value
   - Retention metrics

3. **Inventory Reports**
   - Stock levels
   - Reorder suggestions
   - Product turnover

## 🔧 Maintenance

### Regular Tasks
- Backup database daily
- Check stock alerts
- Monitor order processing
- Update product prices

### Performance Optimization
- Indexed key columns
- Optimized queries
- Regular cleanup of abandoned carts

