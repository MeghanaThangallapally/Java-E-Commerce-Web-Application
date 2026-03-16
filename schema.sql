-- ============================================================
--  ShopFlow E-Commerce  |  MySQL 8.x  |  schema.sql
-- ============================================================

CREATE DATABASE IF NOT EXISTS shopflow
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE shopflow;

-- ── users ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
    id          INT          NOT NULL AUTO_INCREMENT,
    name        VARCHAR(100) NOT NULL,
    email       VARCHAR(100) NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,          -- salt:hash (SHA-256)
    role        ENUM('user','admin') DEFAULT 'user',
    created_at  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- ── products ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS products (
    id          INT             NOT NULL AUTO_INCREMENT,
    name        VARCHAR(200)    NOT NULL,
    category    VARCHAR(100),
    price       DECIMAL(10,2)   NOT NULL,
    stock       INT             NOT NULL DEFAULT 0,
    description TEXT,
    image_url   VARCHAR(255),
    PRIMARY KEY (id)
);

-- ── orders ────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS orders (
    id           INT           NOT NULL AUTO_INCREMENT,
    user_id      INT           NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status       VARCHAR(50)   DEFAULT 'Processing',
    order_date   TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_order_user FOREIGN KEY (user_id) REFERENCES users(id)
);

-- ── order_items ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS order_items (
    id          INT           NOT NULL AUTO_INCREMENT,
    order_id    INT           NOT NULL,
    product_id  INT           NOT NULL,
    quantity    INT           NOT NULL,
    price       DECIMAL(10,2) NOT NULL,           -- price at time of purchase
    PRIMARY KEY (id),
    CONSTRAINT fk_item_order   FOREIGN KEY (order_id)   REFERENCES orders(id),
    CONSTRAINT fk_item_product FOREIGN KEY (product_id) REFERENCES products(id)
);

-- ============================================================
--  Seed Data
-- ============================================================

-- Default admin   (password: admin123)
INSERT INTO users (name, email, password, role) VALUES
('Admin', 'admin@shopflow.com',
 'dGVzdHNhbHQxMjM0NTY3:oHgYxzV0LzF3J2XqP9RmKtN8wQcBvYsDpEuAiZ4lMnU=',
 'admin');

-- Sample products
INSERT INTO products (name, category, price, stock, description, image_url) VALUES
('Wireless Headphones',  'Electronics',  2999.00, 15, 'Premium noise-cancelling wireless headphones',   'images/headphones.jpg'),
('Running Shoes',        'Footwear',     3499.00,  8, 'Lightweight breathable running shoes',           'images/shoes.jpg'),
('Leather Wallet',       'Accessories',   899.00, 30, 'Slim genuine leather bifold wallet',             'images/wallet.jpg'),
('Smart Watch',          'Electronics',  8999.00,  5, 'Fitness tracking smartwatch with AMOLED display','images/watch.jpg'),
('Sunglasses',           'Accessories',  1499.00, 20, 'UV400 polarised sunglasses',                     'images/sunglasses.jpg'),
('Backpack',             'Bags',         2199.00, 12, '30L waterproof travel backpack',                  'images/backpack.jpg'),
('Bluetooth Speaker',    'Electronics',  1999.00, 10, '360° surround sound portable speaker',            'images/speaker.jpg'),
('Cotton T-Shirt',       'Clothing',      499.00, 50, '100% organic cotton round-neck t-shirt',          'images/tshirt.jpg');
