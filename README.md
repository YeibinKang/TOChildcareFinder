# TO Childcare Finder
> A childcare centres finder app for caregivers.
> This app uses data provided by the [City of Toronto Open Data Portal](https://open.toronto.ca).


## Project Problem & Motivation
The City of Toronto provides a wealth of information about licensed child care centers through its official website.

However, for parents trying to **find centers near their home**, **filter by CWELCC (child care fee reduction program) or subsidy eligibility**, and **check availability by age group**, the process is far from easy.

From my own experience:

1. I searched for “daycare” on Google Maps,
2. copied the names of centers,
3. looked each one up manually on the city’s website,
4. opened individual detail pages to check information,
5. and in many cases, had to call the center directly to ask about vacancies.

This process was time-consuming, repetitive, and frustrating.

Even now, many parents continue to ask in local communities and online forums how to find available daycare spots.

This ongoing struggle suggests that the current system remains inefficient and in need of improvement.

## Target User
Whether you're a new parent, an experienced caregiver, or simply exploring childcare options in Toronto — this app is designed to simplify your search.

## Main features
* Display a list of licensed child care centers using data from Toronto Open Data
* Filter centres based on CWELCC participation (fee reduction program), subsidy eligibility, age group availability, and proximity to your location
* Allow users to bookmark favorite centers for easy comparison and future reference

## Tech Stack

|  | Skills |
|----------|---------------------------|
| Frontend  | SwiftUI |
| Statement Management & Logic  | Swift                  |
| Backend/Database  | Firebase |

## Screenshots

| Map View | Childcare centre detail View | List View with favourite mark | Filtering View | Favourite List View |
|-----------------------|-----------------------|-----------------------|-----------------------|-----------------------|
| <img src="https://github.com/user-attachments/assets/94f9b983-1fc6-4973-8f37-e6454b449b67" width="250"> |<img src="https://github.com/user-attachments/assets/43dc90cb-602f-4cf1-9831-1edb3d841ce0" width="275"> |<img src="https://github.com/user-attachments/assets/60ac04a6-1a9e-4f07-b504-4ecba8ec5128" width="250"> | <img src="https://github.com/user-attachments/assets/e2d0a621-3e82-4313-9fe5-851f0cf832aa" width="275"> | <img src="https://github.com/user-attachments/assets/03251d15-cd5b-4089-8ce5-8ba6218f131c" width="250">|

### 🛠️ Work in Progress

The app is still under active development. Upcoming improvements include:

- [ ] Improve UI for `Map` and `Favourites` screens 
- [ ] Improved spacing and styling for filter controls
- [ ] Develop a tracking functionality for favourite centres
- [ ] Develop a community functionality for sharing reviews for centres


Your feedback is welcome!


## 🚀 Getting Started
1. Clone repository
```bash
git clone https://github.com/YeibinKang/TOChildcareFinder.git
```
2. Open in Xcode
open TOChildcareFinder.xcodeproj
