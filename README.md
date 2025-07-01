# Low-Light-Enhancement-Using-a-Retinex-Based-Fast-Algorithm

## Description
This repository provides implementations of a Retinex-based fast algorithm for enhancing images captured under low-light conditions. The project includes both MATLAB and Python versions of the enhancement algorithm. The algorithm aims to improve visibility while preserving natural appearance and minimizing artifacts.

The implementation is based on the method described in the reference paper provided in the `docs/` folder. You can view the paper here:  
[Reference Paper (PDF)](docs/Reference paper.pdf)

## Repository Structure
```
├── Model
│ ├── matlab_version.m 
│ ├── python_version.py 
│
├── docs
│ └── Reference paper.pdf
| └── Report.pdf
│
├── resources
│ └── input
| └── output
│
├── README.md
├── requirements.txt

```
## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/Vaishu-999/Low-Light-Image-Enhancement-Using-a-Retinex-Based-Fast-Algorithm.git
   cd Low-Light-Enhancement-Using-a-Retinex-Based-Fast-Algorithm
## Prerequisites
1. Install the required Python dependencies:
   ```bash
   pip install -r requirements.txt
 Note: The MATLAB version does not require additional installation steps beyond having MATLAB installed.
## Usage Examples
1. Python Version:
   ```bash
   cd Model/python_version
2. Run the main script:
   ```bash
   python sourceCode.py
3. MATLAB Version:
   Open final_code.m in MATLAB.
   Run the script to enhance a sample low-light image.
