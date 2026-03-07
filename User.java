package com.shopflow.model;

import java.sql.Timestamp;

public class User {

    private int       id;
    private String    name;
    private String    email;
    private String    password;   // stored as salt:hash
    private String    role;       // "user" | "admin"
    private Timestamp createdAt;

    public User() {}

    public User(int id, String name, String email, String role) {
        this.id    = id;
        this.name  = name;
        this.email = email;
        this.role  = role;
    }

    // ---- Getters & Setters ----

    public int getId()                     { return id; }
    public void setId(int id)              { this.id = id; }

    public String getName()                { return name; }
    public void setName(String name)       { this.name = name; }

    public String getEmail()               { return email; }
    public void setEmail(String email)     { this.email = email; }

    public String getPassword()            { return password; }
    public void setPassword(String pwd)    { this.password = pwd; }

    public String getRole()                { return role; }
    public void setRole(String role)       { this.role = role; }

    public Timestamp getCreatedAt()        { return createdAt; }
    public void setCreatedAt(Timestamp ts) { this.createdAt = ts; }

    public boolean isAdmin() { return "admin".equalsIgnoreCase(role); }

    @Override
    public String toString() {
        return "User{id=" + id + ", name=" + name + ", email=" + email + ", role=" + role + "}";
    }
}
