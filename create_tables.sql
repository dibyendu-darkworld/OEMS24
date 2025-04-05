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

CREATE TABLE drivers (
    driver_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    phone VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE,
    password_hash TEXT NOT NULL,
    license_number VARCHAR(50),
    vehicle_id INTEGER REFERENCES vehicles(vehicle_id),
    is_available BOOLEAN DEFAULT TRUE,
    current_lat DOUBLE PRECISION,
    current_lng DOUBLE PRECISION,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE driver_earnings (
    earning_id SERIAL PRIMARY KEY,
    driver_id INTEGER REFERENCES drivers(driver_id),
    booking_id INTEGER REFERENCES bookings(booking_id),
    amount NUMERIC(10, 2),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE driver_sessions (
    session_id SERIAL PRIMARY KEY,
    driver_id INT REFERENCES drivers(driver_id),
    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    logout_time TIMESTAMP
);

CREATE TABLE repayment_history (
    repayment_id SERIAL PRIMARY KEY,
    purchase_id INT REFERENCES vehicle_purchase(purchase_id),
    booking_id INT REFERENCES bookings(booking_id),
    amount NUMERIC(10,2),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE ride_feedback (
    feedback_id SERIAL PRIMARY KEY,
    booking_id INT UNIQUE REFERENCES bookings(booking_id),
    user_id INT REFERENCES users(user_id),
    driver_id INT REFERENCES drivers(driver_id),
    rating INT CHECK (rating BETWEEN 1 AND 5) NOT NULL,
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

