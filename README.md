# Montana State University Capstone: Attitude Determination
This is our general repository for all capstone-related code and resources.

## About Us
### Who are we?
Team 25, Attitude Determination Using Priors **(ADUP)**
*Montana State University 2019 Capstone*
 
| **Member**         | **Project Specialty**        | **Major**                |
|--------------------|------------------------------|--------------------------|
| **Tori Royal**     | Software/Image Interpolation | *Electrical Engineering* |
| **Sierra MacLeod** | Software                     | *Computer Engineering*   |
| **Steven Kaiser**  | Software/Mathematics         | *Electrical Engineering* |
| **Randy Young**    | Asset Generation/Simulation  | *Computer Engineering*   |
    
### What are we doing?

**Our Problem:**
Attitude determination is a critical component in the fields of security and defense to monitor the behavior of potentially malicious vehicles in motion. However, most typical approaches may take a substantial amount of time and struggle in non-ideal conditions of poor image resolution and bad lighting. By making use of a well-defined model to mathematically understand possible positions prior to analyzing a monocular video of the specified model in motion, it is possible to cut down on processing time and increase algorithm robustness.

**Our Goals:**
Given the 3D model of a vehicle and a monocular video of it in motion, the relative attitude of the vehicle in space will be determined.

An algorithm will be developed to:
 - Accept a 3D model of a vehicle and a video of it in motion as input data
 - Preprocess the model to move computational time away from processing the video
 - Utilize knowledge of various priors of the vehicle’s motion
 - Provide and visualize the positional data once computed

Once the algorithm is developed, its capability to determine the vehicle’s attitude in a variety of conditions will be assessed.

