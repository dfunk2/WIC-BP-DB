
/*Create employee: */
DROP TABLE IF EXISTS employee;
CREATE TABLE employee(
    Eid INTEGER PRIMARY KEY,
    Fname VARCHAR(20) NOT NULL,
    lname VARCHAR(20) NOT NULL,
    other_language VARCHAR(20),
    Job_type VARCHAR(20) NOT NULL CHECK (Job_type IN ('WIC_Certifier', 'BF_Coordinator', 'Program_Coordinator')),
    PC_Eid INTEGER,
    FOREIGN KEY(PC_Eid) REFERENCES employee(Eid)
);


/*Create WIC_Certifier*/
DROP TABLE IF EXISTS WIC_Certifier;
CREATE TABLE WIC_Certifier(
    WC_Eid INTEGER PRIMARY KEY,
    new_client VARCHAR(20) NOT NULL,
    follow_up VARCHAR(20) NOT NULL,
    FOREIGN KEY (WC_Eid) REFERENCES employee(Eid)
);

/*Create BF_Coordinator*/
DROP TABLE IF EXISTS BF_Coordinator;
CREATE TABLE BF_Coordinator(
    BF_Eid INTEGER PRIMARY KEY,
    lactation_appt VARCHAR(20) NOT NULL,
    high_risk_appt VARCHAR(20) NOT NULL, 
    FOREIGN KEY (BF_Eid) REFERENCES employee(Eid)
);

/*client:*/
DROP TABLE IF EXISTS client;
CREATE TABLE client(
    Cid INTEGER PRIMARY KEY,
    Fname VARCHAR(20) NOT NULL,
    lname VARCHAR(20) NOT NULL,
    phone INTEGER NOT NULL, 
    email VARCHAR(20),
    Risk_level VARCHAR(20) NOT NULL
);

/*Visits:*/
DROP TABLE IF EXISTS visits;
CREATE TABLE visits(
    Eid INTEGER,
    Cid INTEGER,
    Appointment VARCHAR(20) NOT NULL,
    bp_eval VARCHAR(20) NOT NULL,
    Date date,
    FOREIGN KEY(Eid) REFERENCES employee(Eid),
    FOREIGN KEY(Cid) REFERENCES client(Cid),
    PRIMARY KEY (Eid, Cid) 
);

/*breastpump:*/
DROP TABLE IF EXISTS breastpump;
CREATE TABLE breastpump(
    Pid INTEGER PRIMARY KEY,
    brand VARCHAR(20) NOT NULL,
    model VARCHAR(20) NOT NULL,
    bp_transaction_form BOOLEAN NOT NULL, 
    bp_type VARCHAR(20) NOT NULL CHECK (bp_type IN ('rental', 'own')),
    Cid INTEGER, 
    FOREIGN KEY(Cid) REFERENCES client(Cid)
);

/*Report:*/
DROP TABLE IF EXISTS report; 
CREATE TABLE report(
    Report_id INTEGER PRIMARY KEY,
    rental_maintenance_hx DATE,
    rental_hx Date, 
    Pressure_test Date,
    rental_return Date, 
    BF_Eid INTEGER,
    Pid INTEGER,
    FOREIGN KEY(BF_Eid) REFERENCES BF_Coordinator(BF_Eid),
    FOREIGN KEY(Pid) REFERENCES breastpump(Pid)
);

/*rental:*/
DROP TABLE IF EXISTS rental;
CREATE TABLE rental(
    R_pid INTEGER PRIMARY KEY,
    DK_small BOOLEAN,
    DK_medium BOOLEAN,
    DK_large  BOOLEAN,
    WC_Eid INTEGER,
    pass BOOLEAN,
    fail BOOLEAN,
    FOREIGN KEY(R_pid) REFERENCES breastpump(pid),
    FOREIGN KEY(WC_Eid) REFERENCES WIC_Certifier(WC_Eid)
);




/*own:*/
DROP TABLE IF EXISTS own;
CREATE TABLE own(
    O_pid INTEGER PRIMARY KEY,
    M_Flag BOOLEAN NOT NULL,
    flange_small BOOLEAN,
    flange_medium BOOLEAN,
    flange_large BOOLEAN,
    WP_flag BOOLEAN NOT NULL,
    DK_small BOOLEAN,
    DK_medium BOOLEAN,
    DK_large BOOLEAN,
    FOREIGN KEY(O_pid) REFERENCES breastpump(pid)
    
);


/*certification:*/
DROP TABLE IF EXISTS certification;
CREATE TABLE certification(
    BF_Eid INTEGER,
    cert_id INTEGER,
    cert_name VARCHAR(20) NOT NULL,
    FOREIGN KEY(BF_Eid) REFERENCES BF_Coordinator(BF_Eid),
    PRIMARY KEY (BF_Eid, cert_id) 
);


/*insert into employee:*/
INSERT INTO employee(Eid, Fname, lname, other_language, Job_type, PC_Eid)
VALUES 
(4, 'Chi', 'Lao', 'Mandarin', 'Program_Coordinator', 4),
(1, 'Victor', 'Hugo', NULL, 'WIC_Certifier', 4),
(2, 'Mercedes', 'Lopez', 'Spanish', 'WIC_Certifier', 4),
(3, 'Maria', 'Fernandez', 'Spanish', 'BF_Coordinator', 4),
(5, 'Sarah', 'Williams', NULL, 'WIC_Certifier', 4);


/*Insert data into WIC_Certifier:*/
INSERT INTO WIC_Certifier (WC_Eid, new_client, follow_up)
VALUES 
(1, 'New Client Appointment', 'Follow-up Appointment'),  
(2, 'New Client Appointment', 'Follow-up Appointment'),  
(5, 'New Client Appointment', 'Follow-up Appointment');  

/*Insert data into BF_Coordinator for Maria (Eid 3) - Lactation and High Risk Appointments*/
INSERT INTO BF_Coordinator (BF_Eid, lactation_appt, high_risk_appt)
VALUES 
(3, 'Lactation Consultation', 'High-Risk Appointment');


/*Insert into client:*/
INSERT INTO client (Cid, Fname, lname, phone, email, Risk_level)
VALUES
(11, 'Emma', 'Johnson', 5550101010, 'emma.johnson@email.com', 'Low'),
(12, 'Olivia', 'Martinez', 5550101020, 'olivia.martinez@email.com', 'Medium'),
(13, 'Leah', 'Smith', 5550101030, NULL, 'Medium'),
(14, 'Noah', 'Brown', 5550101040, 'noah.brown@email.com', 'Medium'),
(15, 'Ava', 'Davis', 5550101050, 'ava.davis@email.com', 'High');

/*insert into visits:*/
INSERT INTO visits(Eid, Cid, Appointment, bp_eval, Date)
VALUES
(1, 11, 'New_client', 'Manual', '2025-03-02'), 
(2, 12, 'Follow_up', 'Work', '2025-03-10'), 
(5, 13, 'Follow_up', 'Work', '2025-03-15'), 
(3, 14, 'Lactation_consultation', 'Rental', '2025-03-12'), 
(3, 15, 'High_Risk Appointment', 'Rental', '2025-03-06'); 

/*Insert Breastpumps:*/
INSERT INTO breastpump (Pid, brand, model, bp_transaction_form, bp_type, Cid)
VALUES 
(101, 'Medela', 'Manual', TRUE, 'own', 11),
(102, 'Medela', 'Pump in Style', TRUE, 'own', 12),
(103, 'Medela', 'Pump in Style', FALSE, 'own', 13),
(104, 'Medela', 'Lactina', TRUE, 'rental', 14),
(105, 'Medela', 'Lactina', FALSE, 'rental', 15);

/*insert into own:
 Pump owned by Emma (Pid 101 - Medela Manual) */
INSERT INTO own (O_pid, M_Flag, flange_small, flange_medium, flange_large, WP_flag, DK_small, DK_medium, DK_large)
VALUES (101, TRUE, FALSE, FALSE, TRUE,  FALSE, FALSE, FALSE, FALSE);

/*Pump owned by Olivia (Pid 102 - Medela Pump in Style)*/
INSERT INTO own (O_pid, M_Flag, flange_small, flange_medium, flange_large, WP_flag, DK_small, DK_medium, DK_large)
VALUES (102, FALSE, FALSE, FALSE, FALSE,  TRUE, TRUE, FALSE, FALSE);

/*Pump owned by Leah (Pid 103 - Medela Pump in Style)*/
INSERT INTO own (O_pid, M_Flag, flange_small, flange_medium, flange_large, WP_flag, DK_small, DK_medium, DK_large)
VALUES (103, FALSE, FALSE, FALSE, FALSE,  TRUE, FALSE, TRUE, FALSE);

/*insert into rental:*/
INSERT INTO rental (R_pid, DK_small, DK_medium, DK_large, pass, fail)
VALUES 
(104, FALSE, TRUE, FALSE, NULL, NULL), 
(105, FALSE, FALSE, TRUE, FALSE, TRUE); 

/*insert into cert:*/
INSERT INTO certification (BF_Eid, cert_id, cert_name) 
VALUES 
(3, 200, 'Lactation consultant'),  
(3, 201, 'Registered Dietitian');  

/*insert into report:
Report for Emma Johnson (Cid 11) - owned pump (Medela Manual). */
INSERT INTO report (Report_id, Pid, rental_maintenance_hx, rental_hx, Pressure_test, rental_return, BF_Eid)
VALUES
(112, 101, NULL, NULL, NULL, NULL, 3); 

/*Report for Olivia Martinez (Cid 12) - owned pump (Medela Pump in Style).*/
INSERT INTO report (Report_id, Pid, rental_maintenance_hx, rental_hx, Pressure_test, rental_return, BF_Eid)
VALUES
(113, 102, NULL, NULL, NULL, NULL, 3);  

/*Report for Leah Smith (Cid 13) - owned pump (Medela Pump in Style)*/
INSERT INTO report (Report_id, Pid, rental_maintenance_hx, rental_hx, Pressure_test, rental_return, BF_Eid)
VALUES
(114, 103, NULL, NULL, NULL, NULL, 3);  

/*Report for Noah Brown (Cid 14) - rental pump (Medela Lactina), has not returned the pump yet*/
INSERT INTO report (Report_id, Pid, rental_maintenance_hx, rental_hx, Pressure_test, rental_return, BF_Eid)
VALUES
(115, 104, NULL, '2025-03-12', NULL, NULL, 3);  

/*Report for Ava Davis (Cid 15) - rental pump (Medela Lactina), returned with a failed pressure test, maintenance date = return date*/
INSERT INTO report (Report_id, Pid, rental_maintenance_hx, rental_hx, Pressure_test, rental_return, BF_Eid)
VALUES 
(111, 105, '2025-03-06', '2025-03-05', '2025-03-06', '2025-03-06', 3); 