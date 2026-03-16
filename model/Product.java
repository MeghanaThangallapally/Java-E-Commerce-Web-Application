package com.shopflow.model;

import java.math.BigDecimal;

public class Product {

    private int        id;
    private String     name;
    private String     category;
    private BigDecimal price;
    private int        stock;
    private String     description;
    private String     imageUrl;

    public Product() {}

    public Product(int id, String name, String category, BigDecimal price, int stock) {
        this.id       = id;
        this.name     = name;
        this.category = category;
        this.price    = price;
        this.stock    = stock;
    }

    // ---- Getters & Setters ----

    public int getId()                        { return id; }
    public void setId(int id)                 { this.id = id; }

    public String getName()                   { return name; }
    public void setName(String name)          { this.name = name; }

    public String getCategory()               { return category; }
    public void setCategory(String category)  { this.category = category; }

    public BigDecimal getPrice()              { return price; }
    public void setPrice(BigDecimal price)    { this.price = price; }

    public int getStock()                     { return stock; }
    public void setStock(int stock)           { this.stock = stock; }

    public String getDescription()            { return description; }
    public void setDescription(String desc)   { this.description = desc; }

    public String getImageUrl()               { return imageUrl; }
    public void setImageUrl(String imageUrl)  { this.imageUrl = imageUrl; }

    public boolean isInStock()                { return stock > 0; }

    @Override
    public String toString() {
        return "Product{id=" + id + ", name=" + name + ", price=" + price + ", stock=" + stock + "}";
    }
}
