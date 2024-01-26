# BITP 3453 Group Project - Find EVCS

## Overview

Welcome to the Find EVCS project, developed as part of the BITP 3435 course. This mobile app, created using Flutter, aims to provide users with the ability to locate Electric Vehicle Charging Stations (EVCS) around them. The system features a login page with options for both admin and regular users. Admins have the ability to perform CRUD (Create, Read, Update, Delete) operations on EV stations, while regular users can view stations within a 10km radius and leave reviews.

## Group Members

- Stephen Sim (B032220027)
- Tong Yung Huey (B032220028)
- Gui Yu Qin (B032220008)
- Siow Zhe Yi (B032220024)

## Project Features

### 1. User Authentication

- **Login Page:** Users can log in as an admin or access the main application as a regular user.
<img src="https://github.com/Stephen-Sim/find-evcs-app/assets/74543535/a030b7e2-50cf-4d7b-8a2d-6737a1d57bcb" height="500">

**Default Admin Credentials:**
- Username: yung huey
- Password: abc123

### 2. Admin Functionality

- **CRUD Operations:** Admins can Create, Read, Update, and Delete EV stations within the system.
<img src="https://github.com/Stephen-Sim/find-evcs-app/assets/74543535/957f61ec-cf8b-44e2-8058-68975a700ec5" height="500">

<img src="https://github.com/Stephen-Sim/find-evcs-app/assets/74543535/8491ac15-ca82-4c14-b2dc-1a91e84c40385" height="500">

<img src="https://github.com/Stephen-Sim/find-evcs-app/assets/74543535/8bf4dbdd-0412-4f7d-85c3-be766d2aba91" height="500">

### 3. User Functionality

- **View EV Stations:** Regular users can view EV stations within a 10km radius of their location.
- **Leave Reviews:** Users can provide reviews for EV stations.

<img src="https://github.com/Stephen-Sim/find-evcs-app/assets/74543535/e5ee0a98-5192-45d1-b397-ce5cd92b2ef8" height="500">

<img src="https://github.com/Stephen-Sim/find-evcs-app/assets/74543535/7cbaeca7-f73b-4321-9c08-d9eca23cf904" height="500">

## Technologies Used

- **Mobile App Framework:** Developed using Flutter.
- **RESTful API:** Developed using Laravel 8. Check out the [GitHub repository](https://github.com/Stephen-Sim/find-evcs-api) for the API code.
- **External API:** Google Maps API is used for mapping and location services.

## To set up and run the Rest API, follow these steps:

1. Clone the GitHub repository: `git clone https://github.com/Stephen-Sim/find-evcs-api`
2. Navigate to the project directory: `cd your-repo`
3. Create a MySQL database named `findevcs`.
4. Configure the database in the `.env` file with your MySQL credentials.
5. Install dependencies: `composer install`
6. Set up the database: `php artisan migrate`
7. Seed the database: `php artisan db:seed`

## Database Structure

### Entity Relationship Diagram

<img src="https://github.com/Stephen-Sim/find-evcs-app/assets/74543535/1f3f187f-bad4-40d1-a770-9f014737236b" width="800">

### 1. admins Table:

Fields:

- id: Auto-incremented primary key.
- username: Unique username for the admin.
- password: Password for admin login.

Purpose: This table stores information about administrators who have access to perform CRUD operations on EV stations. Each admin has a unique username and password for authentication.

### 2. stations Table:

Fields:

- id: Auto-incremented primary key.
- name: Name of the EV charging station.
- address: Location address of the charging station.
- total_charging_stations: Number of charging stations available.
- image: Base64-encoded string, representing the station's image.
- latitude: Latitude of the charging station location.
- longitude: Longitude of the charging station location.
- admin_id: Foreign key linking to the admins table, representing the admin who manages the station.
  
Purpose: This table stores information about EV charging stations, including their location, capacity, and the admin responsible for managing them.

### 3. reviews Table:

Fields:

- id: Auto-incremented primary key.
- rating: Numeric rating given by a user for a charging station.
- description: Textual description or comment provided by the user in the review.
- guest_name: Name of the user leaving the review.
- station_id: Foreign key linking to the stations table, representing the charging station being reviewed.
  
Purpose: This table stores user reviews for specific EV charging stations, including the rating, description, and the user's name. The station_id foreign key establishes a relationship with the corresponding charging station.

## Usage

1. Launch the mobile app on your preferred emulator or physical device.
2. Log in as an admin or a regular user.
3. Admins can perform CRUD operations on EV stations.
4. Regular users can view nearby EV stations and leave reviews.


Thank you for using Find EVCS! If you have any questions or concerns, feel free to contact our group members.


