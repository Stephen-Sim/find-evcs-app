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

<img src="https://github.com/Stephen-Sim/find-evcs-app/assets/74543535/3f419cf2-d9b8-4ebc-9e77-329886ad5715" height="500">

<img src="https://github.com/Stephen-Sim/find-evcs-app/assets/74543535/7cbaeca7-f73b-4321-9c08-d9eca23cf904" height="500">

## Technologies Used

- **Mobile App Framework:** Developed using Flutter.
- **RESTful API:** Developed using Laravel 8. Check out the [GitHub repository](https://github.com/Stephen-Sim/find-evcs-api) for the API code.
- **External API:** Google Maps API is used for mapping and location services.

## To set up and run the Rest API, follow these steps:

1. Clone the GitHub repository: `git clone https://github.com/Stephen-Sim/find-evcs-api`
2. Navigate to the project directory: `cd your-repo`
3. Install dependencies: `composer install`
4. Set up the database: `php artisan migrate`
5. Seed the database: `php artisan db:seed`

## Usage

1. Launch the mobile app on your preferred emulator or physical device.
2. Log in as an admin or a regular user.
3. Admins can perform CRUD operations on EV stations.
4. Regular users can view nearby EV stations and leave reviews.


Thank you for using Find EVCS! If you have any questions or concerns, feel free to contact our group members.
