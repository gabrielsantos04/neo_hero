# README

This application was generated using [Ruby on Rails](https://rubyonrails.org/)

## Setup
The application was configured to use docker for easy setup and deployment. To get started, follow these steps:
1. Make sure you have [Docker](https://www.docker.com/get-started) installed on your machine.
2. Clone the repository to your local machine.
3. Navigate to the project directory in your terminal.
4. Run the following command to build and start the application:
5. ```bash
   docker compose build
   ```
6. ```bash
   docker compose up
    ```
7. The application should now be running on `http://localhost:3000`.
8. To stop the application, press `CTRL + C` in the terminal where the application is running, then run:
9. ```bash
   docker compose down
   ```
   
## API Endpoints
The application provides a RESTful API for managing characters and their interactions. Below are the available endpoints and their usage.
We should use a tool like [Postman](https://www.postman.com/) to interact with the API. 
As the application does not database the data is being storage in session.
   
## Creating a character
run a POST request to `/character` with the following body:
```json
{
  "character": {
    "name": "Character",
    "job": "warrior"
  }
}
```
The job can be one of the following: warrior, mage, rogue
The response will be a JSON object with the character's details, including the generated attributes.
Example response:
```json
{
  "name": "Character",
  "job": {
    "health_points": 12,
    "strength": 5,
    "dexterity": 6,
    "intelligence": 10,
    "class_name": "Warrior",
    "attack_modifier": 14,
    "speed_modifier": 2
  },
  "id": 245477,
  "alive": true,
  "errors": {},
  "current_health_points": 12
}
```

## Getting a character
To retrieve a character's details, run a GET request to `/character/:id`, where `:id` is the ID of the character you want to retrieve.

The response will be a JSON object with the character's details.
Example response:
```json
{
  "name": "Character",
  "job": {
    "health_points": 12,
    "strength": 5,
    "dexterity": 6,
    "intelligence": 10,
    "class_name": "Warrior",
    "attack_modifier": 14,
    "speed_modifier": 2
  },
  "id": 245477,
  "alive": true,
  "errors": {},
  "current_health_points": 12
}
```

## Getting all Characters
To retrieve the list of available jobs, run a GET request to `character/get_characters_list`.

Example response:
```json
[{
  "name": "Character",
  "job": {
    "health_points": 12,
    "strength": 5,
    "dexterity": 6,
    "intelligence": 10,
    "class_name": "Warrior",
    "attack_modifier": 14,
    "speed_modifier": 2
  },
  "id": 245477,
  "alive": true,
  "errors": {},
  "current_health_points": 12
}]
```

## Getting available jobs
To retrieve the list of available jobs, run a GET request to `/character/get_class_list`.

Example response:
```json
[
  {
    "health_points": 20,
    "strength": 10,
    "dexterity": 5,
    "intelligence": 5,
    "class_name": "Warrior",
    "attack_modifier": 9.0,
    "speed_modifier": 4.0
  },
  {
    "health_points": 12,
    "strength": 5,
    "dexterity": 6,
    "intelligence": 10,
    "class_name": "Mage",
    "attack_modifier": 14.2,
    "speed_modifier": 2.9
  },
  {
    "health_points": 15,
    "strength": 4,
    "dexterity": 10,
    "intelligence": 4,
    "class_name": "Thief",
    "attack_modifier": 12.0,
    "speed_modifier": 8.0
  }
]
```

## Combat
To make a character attack another character, run a POST request to `/character/combat` with the following body:
```json
{
  "char1": <id>,
  "char2": <id>
}
```

The response will be a JSON object with the details of the combat.
Example response:
```json
{
  "battle_log": [
    "Battle between Anali (Mage) - 12 HP and Gabriela (Mage) 12 HP begins!",
    "Gabriela 1.2270725192702654 speed was faster than Anali 1.1470723393062825 speed and will begin this round.",
    "Gabriela attacks Anali with Clarity for 6.6586223222821666 damage. Anali has 5.3413776777178334 HP remaining.",
    "Anali attacks Gabriela with Teleport for 11.65938422627799 damage. Gabriela has 0.3406157737220106 HP remaining.",
    "Anali 1.6312306456315424 speed was faster than Gabriela 0.23297376497088393 speed and will begin this round.",
    "Anali attacks Gabriela with Ghost for 12.68054683313595 damage. Gabriela has 0 HP remaining.",
    "Anali wins the battle! Gabriela still has 0 HP remaining."
  ]
}
```

## Running Tests
To run the test suite, use the following command:
```bash
docker compose run web bundle exec rspec
```
To run a specific test file, use:
```bash
docker compose run web bundle exec rspec path/to/your_spec_file.rb
```

![Alt Text](public/request.gif)




