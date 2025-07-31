#!/bin/bash 

set -e 

# MySQL server information 
MYSQL_SERVER_IP="192.168.245.130"  
DB_NAME="ProjectDB"
READ_ONLY_USER="readonly_user"
READ_ONLY_PASSWORD="Readonly@1234"
READ_WRITE_USER="readwrite_user"
READ_WRITE_PASSWORD="Readwrite@1234"


# Install MySQL client
echo "Installing MySQL client"
sudo apt update -y
sudo apt install mysql-client -y


echo "Testing connection to MySQL server at $MYSQL_SERVER_IP"

if mysql -h "$MYSQL_SERVER_IP" -u "$READ_ONLY_USER" -p"$READ_ONLY_PASSWORD" -e "SHOW DATABASES;" ; then
     echo "Successfully connected to MySQL server as $READ_ONLY_USER"
    
    else 
     echo "failed to connect to mysql server at $MYSQL_SERVER_IP" 
     exit 1
     fi


#Testing the read only user with select
echo "Running a sample SELECT query on $DB_NAME with the READ_ONLY_USER"

if mysql -h "$MYSQL_SERVER_IP" -u "$READ_ONLY_USER" -p"$READ_ONLY_PASSWORD" "$DB_NAME" -e "SHOW TABLES;" ; then
echo "Running a sample INSERT query on $DB_NAME with the READ_ONLY_USER"
else
    echo "Connected, but $DB_NAME may not contain tables yet."
fi 


if mysql -h "$MYSQL_SERVER_IP" -u "$READ_ONLY_USER" -p"$READ_ONLY_PASSWORD" "$DB_NAME" -e "CREATE TABLE IF NOT EXISTS client_test (
    id INT AUTO_INCREMENT PRIMARY KEY,
    message VARCHAR(100)
);" ; then 
    echo "INCORRECT, Succeeded to create table with read_only_user"

else 
    echo "CORRECT, Failed to create table with read_only_user"

fi  


# TESTING READ WRITE USER

echo "Testing CREATE operation with read-write user"
if mysql -h "$MYSQL_SERVER_IP" -u "$READ_WRITE_USER" -p"$READ_WRITE_PASSWORD" "$DB_NAME" -e "
CREATE TABLE IF NOT EXISTS client_test (
    id INT AUTO_INCREMENT PRIMARY KEY,
    message VARCHAR(100)
);" ; then
echo "Successfully connected and executed write query as $READ_WRITE_USER"
else 
echo "Failed to connect or execute write query as $READ_WRITE_USER"
fi 


echo "Testing INSERT operation with read-write user"
if mysql -h "$MYSQL_SERVER_IP" -u "$READ_WRITE_USER" -p"$READ_WRITE_PASSWORD" "$DB_NAME" -e "
INSERT INTO client_test (message) VALUES ('Hello from client!');
" ; then
    echo "INSERT successful as $READ_WRITE_USER"
else 
    echo "INSERT failed as $READ_WRITE_USER"
fi 



echo "Client script completed."
