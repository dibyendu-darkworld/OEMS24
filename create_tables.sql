CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE vehicles (
    vehicle_id SERIAL PRIMARY KEY,
    type VARCHAR(50) CHECK (type IN ('cab', 'bike')) NOT NULL,
    category VARCHAR(50) CHECK (
        (type = 'cab' AND category IN ('Mini', 'Sedan', 'SUV', 'Luxury', 'Rental')) OR 
        (type = 'bike' AND category IN ('Normal', 'Electric'))
    ) NOT NULL,
    model VARCHAR(100) NOT NULL,
    registration_number VARCHAR(20) UNIQUE NOT NULL,
    availability BOOLEAN DEFAULT TRUE,
    price NUMERIC(10,2) DEFAULT 0.0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    vehicle_id INT REFERENCES vehicles(vehicle_id),
    pickup_location TEXT NOT NULL,
    drop_location TEXT NOT NULL,
    fare NUMERIC(10,2) NOT NULL,
    status VARCHAR(50) CHECK (status IN ('pending', 'completed', 'cancelled')) DEFAULT 'pending',
    booked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE vehicle_purchase (
    purchase_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    vehicle_id INT REFERENCES vehicles(vehicle_id),
    down_payment NUMERIC(10,2) NOT NULL,
    remaining_amount NUMERIC(10,2) NOT NULL,
    purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) CHECK (status IN ('active', 'completed')) DEFAULT 'active'
);

CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    booking_id INT REFERENCES bookings(booking_id) DEFAULT NULL,
    purchase_id INT REFERENCES vehicle_purchase(purchase_id) DEFAULT NULL,
    amount NUMERIC(10,2) NOT NULL,
    payment_method VARCHAR(50) CHECK (payment_method IN ('credit card', 'debit card', 'UPI', 'wallet')),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);