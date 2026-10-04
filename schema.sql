-- ERCS Database Initialization Script
CREATE DATABASE IF NOT EXISTS ercs_db;
USE ercs_db;

CREATE TABLE IF NOT EXISTS emergency_resources (
    resource_id INT PRIMARY KEY,
    resource_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE'
);

CREATE TABLE IF NOT EXISTS dispatch_logs (
    dispatch_id INT AUTO_INCREMENT PRIMARY KEY,
    resource_id INT NOT NULL,
    incident_type VARCHAR(100) NOT NULL,
    severity VARCHAR(20) NOT NULL,
    dispatch_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (resource_id) REFERENCES emergency_resources(resource_id)
);

-- Seed initial sample data
INSERT INTO emergency_resources (resource_id, resource_name, category, status) VALUES
(1042, 'Advanced Life Support Unit 04', 'Ambulance', 'AVAILABLE'),
(2091, 'Heavy Rescue Engine 12', 'Fire Engine', 'AVAILABLE'),
(3055, 'HazMat Response Vehicle', 'HazMat Unit', 'AVAILABLE');