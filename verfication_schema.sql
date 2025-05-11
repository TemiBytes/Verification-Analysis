-- CREATE A DATABASE CALLED "verifications_project"
CREATE DATABASE verifications_project;

-- USE DATABASE
USE verifications_project;

-- CREATE VERIFICATIONS TABLE

CREATE TABLE verifications (
	id INT AUTO_INCREMENT PRIMARY KEY,
    session_id VARCHAR(100),
    app_id VARCHAR(100),
    selfie_url VARCHAR(255),
    id_url VARCHAR(255),
    status VARCHAR(50),
    confidence DOUBLE,
    id_type VARCHAR(50),
    mode VARCHAR(50),
    datetime DATETIME,
	aml_reference VARCHAR(100),
    review_comment VARCHAR(255),
    review_date DATETIME,
    id_number VARCHAR(50),
    review_process VARCHAR(50),
    reference_id VARCHAR(100),
    environment VARCHAR(50),
    steps_completed INT,
    country VARCHAR(50),
    r_action VARCHAR(50),
    back_url VARCHAR(100),
    address_exists BOOLEAN,
    address VARCHAR(255),
    ucode VARCHAR(100),
    reviewed_by VARCHAR(100),
    reviewer VARCHAR(100),
    review_status INT,
    failed_id_capture VARCHAR(100),
    direct_feedback BOOLEAN,
    email VARCHAR(100),
    selfie_to_human_review BOOLEAN,
    reason_for_human_review_selfie VARCHAR(100),
    reason_for_human_review_id VARCHAR(100),
    duplicate_check BOOLEAN,
    flow_id VARCHAR(100),
    check_background BOOLEAN,
    verification_id VARCHAR(100),
    customer_id VARCHAR(100),
    service_provider_down BOOLEAN
);